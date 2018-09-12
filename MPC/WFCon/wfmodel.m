function [gp,ap] = wfmodel(ap,gp)


% build wind farm model
gp.a = blkdiag(ap.a{:});
gp.b = blkdiag(ap.b{:});
gp.c = blkdiag(ap.c{:});
% add error channel
gp.a  = [gp.a zeros(gp.Nx-1,1)];
gp.a  = [gp.a;-repmat([0 1 0],1,gp.Na) 0];
gp.b  = [gp.b; zeros(1,gp.Na)];
gp.c  = blkdiag(gp.c, 1);
gp.d  = zeros(size(gp.c,1),size(gp.b,2));
% build B and D matrix for wind farm reference
gp.br = [zeros(gp.Nx-1,1); 1];
gp.dr = zeros(size(gp.c,1),size(gp.br,2));

end

