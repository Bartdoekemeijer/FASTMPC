
function sys_ex_C_CL = FetchTurbineModel(WINDSPEED,h)

ETA_GEN = 0.944;

GS_PITCH = [0, 0.0174532925199433, 0.0496747556336848, 0.0818962187474262, 0.114117681861168, 0.146339144974909, 0.178560608088651, 0.210782071202392, 0.243003534316134, 0.275224997429875, 0.307446460543617, 0.339667923657358, 0.371889386771099, 0.404110849884841, 0.436332312998582];
GS_KP = [-0.0188268100000000, -0.0162486200000000, -0.0129696690000000, -0.0107918810000000, -0.00924030500000000, -0.00807879600000000, -0.00717668500000000, -0.00645580300000000, -0.00586652500000000, -0.00537582500000000, -0.00496087800000000, -0.00460539700000000, -0.00429745600000000, -0.00402811500000000, -0.00379054400000000];
GS_KI = [-0.00806863400000000, -0.00696369500000000, -0.00555843000000000, -0.00462509200000000, -0.00396013100000000, -0.00346234200000000, -0.00307572200000000, -0.00276677300000000, -0.00251422500000000, -0.00230392500000000, -0.00212609100000000, -0.00197374200000000, -0.00184176700000000, -0.00172633500000000, -0.00162451900000000];
T = 1:0.01:25;
U = heaviside(T./max(T)-0.1);

lindata = ReadFASTLinear(['Lin', int2str(WINDSPEED), '_NREL5MW.lin']);

iTHETA0 = find(contains(lindata.u_desc(:), 'collective blade-pitch command'));
iTAU0 = find(contains(lindata.u_desc(:), 'Generator torque'));
iOMEGA0 = find(contains(lindata.y_desc(:), 'GenSpeed'));
iROOTMOOP = find(contains(lindata.y_desc(:), 'RootMOoP1'));
THETA0 = lindata.u_op{iTHETA0};
TAU0 = lindata.u_op{iTAU0}*ETA_GEN;
OMEGA0 = lindata.y_op{iOMEGA0}*pi/30;

sys = ss(lindata.A, lindata.B, lindata.C*pi/30, lindata.D, 'InputName', lindata.u_desc, 'OutputName', lindata.y_desc);

%sys_ex = sys([iOMEGA0 iROOTMOOP], iTHETA0);
sys_ex = sys(iOMEGA0, iTHETA0);

sys_ex.InputName = {'Theta'};

%sys_ex.OutputName = {'Omega', 'Out-of-plane bending moment'};
sys_ex.OutputName = {'Omega'};

Kp = interp1(GS_PITCH, GS_KP, THETA0);
Ki = interp1(GS_PITCH, GS_KI, THETA0);
C = tf([Kp Ki],[1 0]);

% Remove origin zero to enforce LPF behavior of system dynamics
sys_dcfix   = zpk(min(pole(sys_ex)),0,1);
sys_ex(1,1) = minreal(sys_dcfix*sys_ex(1,1),[],false);

sys_ex      = minreal(sys_ex,[],false);

% Create open loop
sys_ex_C               = series(sys_ex, C);
sys_ex_C_CL            = feedback(sys_ex_C,1,1,1);
sys_ex_C_CL.InputName  = {'Power reference'};
%sys_ex_C_CL.OutputName = {'Power measured', 'Out-of-plane load'};
sys_ex_C_CL.OutputName = {'Power measured'};

sys_ex_C_CL            = c2d(sys_ex_C_CL,h);
end