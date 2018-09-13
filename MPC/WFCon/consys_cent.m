
function [sr,ap] = consys_cent(k,sr,ap,gp)


yalmip('clear');

cons  = [];

xinit = sr.x(:,k)*gp.sc;

    % define decision variables for the windfarm
    U  = sdpvar(gp.Nu*gp.Nh,1);
    
    % build wind farm model
    gp = wfmodel(ap,gp);    
    
    % build contraints set
    gp = constset(ap,gp);  
    
    % build matrices horizon
    gp = matsys(gp);         

    
    Y    = gp.C *xinit + gp.D*U;                                % power and force
    Z    = gp.Ce*xinit + gp.De*U + gp.Pnref(k:k+gp.Nh-1)*gp.sc;    % wind farm error    

    F    = Y(gp.MF);
    P    = Y(gp.MP);    

    cons = [cons, gp.ulb <= U <= gp.uub];
     
    if k == 1
        dU = [ U(1:gp.Na)-sr.u(:,k)*gp.sc ; U(gp.Na+1:end)-U(1:end-gp.Na)];
        %cons = [cons, -gp.duc*gp.sc <= dU <= gp.duc*gp.sc];
    else
        dU = [ U(1:gp.Na)-sr.u(:,k-1)*gp.sc ; U(gp.Na+1:end)-U(1:end-gp.Na)];
        %cons = [cons, -gp.duc*gp.sc <= dU <= gp.duc*gp.sc];
    end
           
    %cons = [cons, gp.ylb(gp.MP) <= P <= gp.yub(gp.MP)];
    %cons = [cons, gp.ylb(gp.MF) <= F <= gp.yub(gp.MF)];
    
    if k == 1
        dF  = [ F(1:gp.Na)-sr.y(gp.Mf,k)*gp.sc ; F(gp.Na+1:end)-F(1:end-gp.Na)];
    else
        dF = [ F(1:gp.Na)-sr.y(gp.Mf,k-1)*gp.sc ; F(gp.Na+1:end)-F(1:end-gp.Na)];
    end

    cost = Z'*gp.Q*Z + dU'*gp.R*dU ;

    
%% finite horizon optimization problem
if k==1
    sr.ops = sdpsettings('solver','cplex','verbose',0,'cachesolvers',1);
end

optimize(cons,cost,sr.ops)


%% assign the decision variables
Uopt        = value(U);
temp        = reshape(Uopt,[gp.Na,gp.Nh]);
for i=1:gp.Nh
    sr.U(i,k,:)   = temp(:,i)/gp.sc; % full horizon optimal action
end

sr.u(:,k)   = sr.U(1,k,:); % 1st step optimal action

Yopt        = value(Y);
temp        = reshape(Yopt,[gp.Ny,gp.Nh]);
for i=1:gp.Nh
    sr.Y(i,k,:)   = temp(:,i)/gp.sc; 
end

Zopt    = value(Z);
temp    = reshape(Zopt,[1,gp.Nh]);
for i=1:gp.Nh
    sr.Z(i,k,:)   = temp(:,i)/gp.sc; 
end

end




