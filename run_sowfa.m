function sr = run_sowfa(k,sr,ap,gp)


% build wind farm model
gp = wfmodel(ap,gp);

sr.xs(:,k+1) = gp.a*sr.xs(:,k) + gp.b*sr.u(:,k);
sr.ys(:,k)   = gp.c*sr.xs(:,k) + gp.d*sr.u(:,k);

end