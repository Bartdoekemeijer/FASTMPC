function gp = wfmodel(ap,gp)

% build wind farm model
gp.a = blkdiag(ap.a{:});
gp.b = blkdiag(ap.b{:});
gp.c = blkdiag(ap.c{:});
gp.d = blkdiag(ap.d{:});

% error channel
gp.ce = -gp.Mp'*gp.c;
gp.de = -gp.Mp'*gp.d;

end

