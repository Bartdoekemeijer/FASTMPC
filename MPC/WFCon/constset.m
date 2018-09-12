function gp = constset(ap,gp)

yub = [];
ylb = [];
uub = [];
ulb = [];

% output constraints
% Pm <= P <= PM
% Fm <= F <= FM
for i=1:gp.Na
    
    Pm  = ap.Pm;
    PM  = ap.PM;
    
    Fm  = ap.Fm;
    FM  = ap.FM;
    
    yub = [yub; [PM FM]' ];
    ylb = [ylb; [Pm Fm]' ];
    
    uub = [uub; ap.uM];
    ulb = [ulb; ap.um];
    
end

% constaints for the complete horizon
gp.yub = repmat(yub, gp.Nh,1);
gp.ylb = repmat(ylb, gp.Nh,1);

% control constraints for the complete horizon
gp.uub = repmat(uub, gp.Nh,1);
gp.ulb = repmat(ulb, gp.Nh,1);

end

