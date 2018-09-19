function sr = run_sowfa(k,sr,ap,gp)


% build wind farm model
gp = wfmodel(ap,gp);

sr.xs(:,k+1) = gp.a*sr.xs(:,k)  + gp.b*sr.u(:,k) + gp.bn*sr.n(:,k);
sr.ys(:,k)   = gp.c*sr.xs(:,k)  + gp.d*sr.u(:,k) + gp.dn*sr.n(:,k);
sr.es(:,k)   = gp.ce*sr.xs(:,k) + gp.de*sr.u(:,k) + gp.den*sr.n(:,k) + gp.Pnref(k);
    
end