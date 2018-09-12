
function gp = matsys(gp)


Am  = gp.a;
Bm  = gp.b;
Bmr = gp.br;
Cm  = gp.c;
Dm  = gp.d;
Dmr = gp.dr;


Nh = gp.Nh;

A = Am;
Ai = A;
AA = Ai;
for ii = 2:Nh
    Ai = A*Ai;
    AA = [AA;Ai];
end
gp.A = AA;


AiB = Bm;
BB = kron(eye(Nh),AiB);
for ii = 1:Nh-1
    AiB = A*AiB;
    BB = BB+kron(diag(ones(Nh-ii,1),-ii),AiB);
end
gp.B = BB;

AiBr = Bmr;
BBr = kron(eye(Nh),AiBr);
for ii = 1:Nh-1
    AiBr = A*AiBr;
    BBr = BBr+kron(diag(ones(Nh-ii,1),-ii),AiBr);
end
gp.Br = BBr;

C  = Cm;
A  = Am;
Ai = eye(size(Am,1));
CC = C;
for ii = 2:Nh
    Ai = A*Ai;
    CC = [CC;C*Ai];
end
gp.C = CC;

A    = Am;
Ai   = eye(size(Am,1));
DD   = kron(eye(Nh),Dm);
for ii = 1:Nh-1
    DD = DD+kron(diag(ones(Nh-ii,1),-ii),Cm*Ai*Bm);
    Ai = A*Ai;
end
gp.D = DD;

A     = Am;
Ai   = eye(size(Am,1));
DDr   = kron(eye(Nh),Dmr);
for ii = 1:Nh-1
    DDr = DDr+kron(diag(ones(Nh-ii,1),-ii),Cm*Ai*Bmr);
    Ai = A*Ai;
end
gp.Dr = DDr;



end

