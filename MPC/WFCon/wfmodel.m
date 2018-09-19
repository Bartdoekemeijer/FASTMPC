function gp = wfmodel(ap,gp)

% build wind farm model
gp.a  = blkdiag(ap.a{:});
gp.b  = blkdiag(ap.b{:});
gp.bn = blkdiag(ap.bn{:});
gp.c  = blkdiag(ap.c{:});
gp.d  = blkdiag(ap.d{:});
gp.dn = blkdiag(ap.dn{:});

% error channel
gp.ce  = -gp.Mp'*gp.c;
gp.de  = -gp.Mp'*gp.d;
gp.den = -gp.Mp'*gp.dn;   

end

