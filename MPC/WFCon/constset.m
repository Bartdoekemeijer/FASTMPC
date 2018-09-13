function gp = constset(ap,gp)

yub = [];
ylb = [];
uub = [];
ulb = [];

% output constraints
% Pm <= P <= PM
% Fm <= F <= FM
for i=1:gp.Na
        
    yub = [yub; [ap.PM*gp.sc ap.FM*gp.sc]' ];
    ylb = [ylb; [ap.Pm*gp.sc ap.Fm*gp.sc]' ];
    
    uub = [uub; ap.uM*gp.sc];
    ulb = [ulb; ap.um*gp.sc];
    
end

% constaints for the complete horizon
gp.yub = repmat(yub, gp.Nh,1);
gp.ylb = repmat(ylb, gp.Nh,1);

% control constraints for the complete horizon
gp.uub = repmat(uub, gp.Nh,1);
gp.ulb = repmat(ulb, gp.Nh,1);

end

