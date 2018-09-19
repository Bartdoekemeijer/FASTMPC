
function [sr,ap] = obssys_cent(k,sr,ap,gp)

% build wind farm model
gp = wfmodel(ap,gp);

%[kest,L,P] = kalman(sys,W,V*eye(ny),0);
[~,~,L]   = dare (gp.a',gp.c',gp.bn*gp.W*gp.bn',gp.dn*gp.V*gp.dn',...
    zeros(size (gp.c')),eye (size(gp.a,1)) ); L = L.';


sr.xe(:,k+1) = gp.a*sr.xe(:,k) + gp.b*sr.u(:,k) + L*(sr.y(:,k)-sr.ye(:,k));
sr.ye(:,k)   = gp.c*sr.xe(:,k) + gp.d*sr.u(:,k);

end




