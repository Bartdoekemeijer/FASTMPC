function [gp,ap,sr] =  InitializeController(Wp)


%% global parameters

gp            = struct;

gp.Nsim       = Wp.N/(2*Wp.h);      % total simulation time
gp.Nh         = 10;                 % # samples in prediction horizon
gp.Na         = Wp.Nt;              % # wind turbines
gp.Nu         = gp.Na;              % #inputs
gp.Nx         = 14+1;          % #states (this one you have to know before loading turbine model)

gp.MF         = logical(repmat([repmat([1 0 0]',gp.Na,1); 0],gp.Nh,1));
gp.Mf         = logical([repmat([1 0 0]',gp.Na,1); 0]);
gp.MP         = logical(repmat([repmat([0 1 0]',gp.Na,1); 0],gp.Nh,1));
gp.Mp         = logical([repmat([0 1 0]',gp.Na,1); 0]);
gp.MU         = logical(repmat([repmat([0 0 1]',gp.Na,1);0],gp.Nh,1));
gp.ME         = logical(repmat([zeros(gp.Nx-1,1); 1],gp.Nh,1));

gp.Q          = 1e4*eye(gp.Nh);                 % weigth on tracking
gp.S          = 0*eye(gp.Nh*gp.Na);             % weigth on variation of the force
gp.R          = 1e4*eye(gp.Nh*gp.Nu);         % weigth on control signal

gp.duc        = 2e-1;                           % limitation on du/dt
gp.dfc        = Inf;                            % limitation on dF/dt

% wind farm reference
gp.Pnref      = zeros(gp.Nsim+gp.Nh,1); 

load(strcat(Wp.controller,'/libraries/AGC_PJM_RegD_Norm2s')); gp.AGCdata    = AGCdata(:,2); 

gp.Pgreedy            = 7.490235760251439e+06; % Simulation horizon of 900s

gp.Pnref(1:Wp.N0)     = 0.6*gp.Pgreedy; 
gp.Pnref(Wp.N0+1:end) = 0.6*gp.Pgreedy ;%+ .5*gp.Pgreedy*gp.AGCdata(1:gp.Nsim+gp.Nh-Wp.N0);

%% turbine parameters

ap              = struct;

ap.uM           = 5*10^6;       % maximim power input
ap.um           = .1*10^6;      % minimum power input
ap.PM           = ap.uM;        % upperbounds and lower bounds output
ap.Pm           = ap.um;
ap.FM           = ap.uM;
ap.Fm           = ap.um;

correct_input   = 1; % These need to be defined?
correct_output  = 1:2;

for kk = 1:gp.Na
    ap.T{kk}     = ReadFASTLinear('Lin8_NREL5MW.lin');
    ap.a{kk}     = ap.T{kk}.A; %load model turbine i from Pref to [Pi Fi]
    ap.b{kk}     = ap.T{kk}.B(:,correct_input);
    ap.c{kk}     = ap.T{kk}.C(correct_output,:);   
    ap.d{kk}     = ap.T{kk}.D(correct_output,correct_input);
end                                                                                                                              

% constraints definitions
ap.duc        = 5e-2;                                           % limitation on du/dt
ap.dfc        = Inf*ones(gp.Na,gp.Nsim);                        % limitation on dF/dt
ap.MF         = logical(repmat([1 0 0]',gp.Nh,1));
ap.Mf         = logical([repmat([1 0 0]',gp.Na,1); 0]);
ap.MP         = logical(repmat([0 1 0]',gp.Nh,1));
ap.Mp         = logical([repmat([0 1 0]',gp.Na,1); 0]);
ap.MU         = logical(repmat([0 0 1]',gp.Nh,1));
ap.Mu         = logical([repmat([0 0 1]',gp.Na,1); 0]);

%% simulation results

sr                = struct;

sr.x              = zeros(gp.Nx,gp.Nsim);       % state x
sr.U              = zeros(gp.Nh,gp.Nsim,gp.Na);
sr.u              = zeros(gp.Na,gp.Nsim);       % control signal Pr
sr.y              = zeros(gp.Nx,gp.Nsim);       % output 
sr.e              = zeros(1,gp.Nsim);           % wind farm error
sr.error          = zeros(gp.Na,1);             % #of wrong optimization steps

end
