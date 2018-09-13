
function gp = matsys(gp)


Am  = gp.a;
Bm  = gp.b;
Cm  = gp.c;
Dm  = gp.d;
Cme = gp.ce;
Dme = gp.de;

Nh = gp.Nh;

A  = Am;
Ai = A;
AA = Ai;
for ii = 2:Nh
    Ai = A*Ai;
    AA = [AA;Ai];
end
gp.A = AA;


AiB = Bm;
BB  = kron(eye(Nh),AiB);
for ii = 1:Nh-1
    AiB = A*AiB;
    BB = BB+kron(diag(ones(Nh-ii,1),-ii),AiB);
end
gp.B = BB;


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

Ce  = Cme;
A   = Am;
Ai  = eye(size(Am,1));
CCe = Ce;
for ii = 2:Nh
    CCe = [CCe;Ce*Ai];
    Ai  = A*Ai;
end
gp.Ce = CCe;

Ce   = Cme;
A    = Am;
Ai   = eye(size(Am,1));
DDe  = kron(eye(Nh),Dme);
for ii = 1:Nh-1
    DDe = DDe+kron(diag(ones(Nh-ii,1),-ii),Ce*Ai*Bm);
    Ai  = A*Ai;
end
gp.De = DDe;

end

