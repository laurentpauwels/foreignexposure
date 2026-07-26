function graph3Dregression(Y, X, initializedVars, elasticities, useWinsor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph3Dregression.m:
% 1. Regress the simulated responses to a shock on the
%    approximate simulated responses. The regressions coefficient beta are extracted.
% 2. Construct 3D graph surface for a selection of elasticities rho and
%    epsilon, and save the graphs in io_plotfolder.
% Inputs:
%       X
%       Y
%       elasticities        Structure elasticities: .rho, .esp, .psi
%       initializedVars     Structure contain all required variables 
%       useWinsor           int       0 or 1 to winsor X and Y. 
% Output:
%       Graph of beta from regressing lnV_t on (alpha*psi)/(1+psi)lnPY_t
% Required functions:                                                 %
%   - removeRowOrigin.m
%   - winsorize.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off');
sim_rho = elasticities.rho;
sim_eps = elasticities.eps;
nelastcomb = size(sim_rho,1);

% Remove RoW and Shock Origin Country
Y_nr  = removeRowOrigin(Y, initializedVars, nelastcomb);
X_nr  = removeRowOrigin(X, initializedVars, nelastcomb);

%% Regressions
beta = zeros(nelastcomb,1);
tstat = zeros(nelastcomb,1);
pvalue = zeros(nelastcomb,1);
for i = 1:nelastcomb
    switch useWinsor
        case 'useWinsor'
            X_nr_wins = winsorize(X_nr(:,i), 0.05);
            Y_nr_wins = winsorize(Y_nr(:,i), 0.05);
            model = fitlm(X_nr_wins, Y_nr_wins);
        otherwise
            model = fitlm(X_nr(:,i), Y_nr(:,i));
    end
    beta(i,1) = model.Coefficients.Estimate(2);
    tstat(i,1) = model.Coefficients.tStat(2);
    pvalue(i,1) = model.Coefficients.pValue(2);
    % Set beta to 0 if pvalue > 0.01
    %if pvalue(i,1) > 0.01
    %    beta(i,1) = 0;
    %end
end

% Remove value and elasticities at rho,eps = 0 or 0.05
tab_sim = table(sim_rho,sim_eps,beta,pvalue,...
   'VariableNames',["rho","eps","beta","pvalue"]);
tab_sim(tab_sim.rho<0.05,:) = [];
tab_sim(tab_sim.eps<0.05,:) = [];
beta = tab_sim.beta;
pvalue = tab_sim.pvalue;
%test = (pvalue < 0.01 & beta >= 0);

elast_rho = unique(sim_rho);
elast_eps = unique(sim_eps);
elast_rho(elast_rho<0.05) = [];
elast_eps(elast_eps<0.05) = [];

%% 3D Graphs

[Xb, Yb] = meshgrid(elast_rho, elast_eps);
Zb = reshape(beta, size(Yb));

% Create a mask with three conditions
mask = zeros(size(beta));
mask(pvalue < 0.01 & beta >= 0) = 1; % Condition for pvalue < 0.01 and beta >= 0
mask(pvalue < 0.01 & beta < 0) = 2;  % Condition for pvalue < 0.01 and beta < 0
Cb = reshape(mask, size(Yb)); % Use mask as the color data

% Create a custom colormap
cmap = [0.95 0.95 0.95; % Light grey for 0 (pvalue >= 0.01)
    0.5 0.5 0.5; % Dark grey for 1 (pvalue < 0.01 and beta >= 0)
    0.8 0.8 0.8]; % Medium grey for 2 (pvalue < 0.01 and beta < 0)

% Plot the surface
surf(Xb, Yb, Zb, Cb)% 'EdgeColor', 'none')
colormap(cmap)

% Set the color limits to match the colormap
%caxis([0 2]);

% Set the Z-axis limits
zlim([-0.05 0.05]);
xlabel('${\rho}$','Interpreter','latex','FontSize',18)
ylabel('${\epsilon}$','Interpreter','latex','FontSize',18)
zlabel('$\hat{\beta}$','Interpreter','latex','FontSize',18, 'Rotation',10)
grid on;

end

% xlabel('Substitution in final goods (${\rho}$)','Interpreter','latex','FontSize',8,'Rotation',20)
% ylabel('Substitution in intermediates (${\epsilon})$','Interpreter','latex','FontSize',8,'Rotation',-30)
% zlabel('Estimated coefficient ($\hat{\beta}$)','Interpreter','latex','FontSize',8)
