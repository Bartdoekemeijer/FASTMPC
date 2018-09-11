clc, clearvars

for i = 1:36
    lindata = ReadFASTLinear(['FAST.SFunc.', int2str(i), '.lin']);
    sys{i} = ss(lindata.A, lindata.B, lindata.C*pi/30, lindata.D, 'InputName', lindata.u_desc, 'OutputName', lindata.y_desc);
    stabb(i) = all(real(eig(sys{i})) <= 0);
end