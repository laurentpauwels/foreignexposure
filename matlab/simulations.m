%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%simulations.m produces FIGURES 1-4 and C.1 - C.2.                     %
%Imbs & Pauwels (2025), "Measuring Foreign Exposure"                  %
% Required data:                                                      %
%   - industryShort.mat                                               %
%   - sea16_strc.mat                                                  %
%   - wiot16_strc.mat                                                 %
% Required functions:                                                 %
%   - runSimulation.m                                                 %
%   - initializeSimulation.m                                          %
%   - buildShocks.m                                                   %
%   - graph3Dresponse.m                                               %
%   - graph3Dregression.m                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PATHS
% Add folders to path
io_funfolder = fullfile('.', 'functions');
io_scrfolder = fullfile('.', 'scripts');
io_dtafolder = fullfile('.', 'data');
io_outfolder = fullfile('.', 'output');

addpath(io_funfolder);
addpath(io_scrfolder);
addpath(genpath(io_dtafolder));
addpath(genpath(io_outfolder));

%% DATA PROCESSING
load('industryShort.mat')% Load industry shortened names for graphical representations
load('sea16_strc.mat')% Load WIOD Socio-Economic Accounts data
load('wiot16_strc.mat')% Load WIOD16 data

%% INITIALIZATION
initializedVars  = initializeSimulation(wiot16_data,wiot16_text,sea16_data,sea16_text);

%% SHOCKS: Standard deviation of country GO.
shockfor = 'USA'; %Choose country of origin for foreign shock
lnZfor = buildShocks(wiot16_data, shockfor,initializedVars.countrycode);
lnDfor = lnZfor;


%% FIGURES 1 - 4, C.1 and C.2: 3D GRAPHS
%%%% Simulations
simulation_rho = [0;0.05;(0.1:0.1:2.5)'];
simulation_eps = [0;0.05;(0.1:0.1:1.5)'];
simulation_psi = 0.723;

simulationElasticities = struct();
simulationElasticities.rho = kron(simulation_rho,ones(size(simulation_eps,1),1));
simulationElasticities.eps = repmat(simulation_eps,size(simulation_rho,1),1);
simulationElasticities.psi = simulation_psi*ones(size(simulation_rho,1)*size(simulation_eps,1),1);

supplySimulation = runSimulation(initializedVars, simulationElasticities,...
                                 lnZfor, 'supplyShock');
save supplySimulation.mat

demandSimulation = runSimulation(initializedVars, simulationElasticities,...
                                 lnDfor, 'demandShock');
save demandSimulation.mat


%%%% FIGURES 1 - 4, C.1 and C.2:

% Response lnPc/lnHOT ratio 3D surface
% positive_val, negative_val
graphBoundaries = struct();
graphBoundaries.max_val = 1;
graphBoundaries.min_val = -1;

% Kappa = alpha * psi / (1+psi)
psi = 0.723;
Kappa = (initializedVars.alpha)*(psi/(1+psi));

% FIGURE 1: Supply Response
figure_supplyResponse = figure;
graph3Dresponse((Kappa.*supplySimulation.lnPc)./(supplySimulation.lnHOT),...
    simulationElasticities, initializedVars, graphBoundaries)
exportgraphics(figure_supplyResponse,fullfile('.', 'output', 'figures','Figure1_supplyResponse3D.jpg'));
close(gcf);

% FIGURE 2: Demand Response
figure_demandResponse = figure;
graph3Dresponse((Kappa.*demandSimulation.lnPc)./(demandSimulation.lnHOT),...
    simulationElasticities, initializedVars,graphBoundaries)
exportgraphics(figure_demandResponse,fullfile('.', 'output', 'figures','Figure2_demandResponse3D.jpg'));
close(gcf);

% FIGURE 3: Supply beta
figure_Supplybeta3D = figure;
subplot(2, 2, 1);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnHOT,...
    initializedVars, simulationElasticities,0)
view([-39.5089 30.5870])
title('$\ln$ HOT','Interpreter','latex','FontSize',18);
subplot(2, 2, 2);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnX*10,...
    initializedVars,simulationElasticities,0)
view([-39.5089 30.5870])
title('$\ln$ X','Interpreter','latex','FontSize',18);
subplot(2, 2, 3);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnTVA*100,...
    initializedVars,simulationElasticities,0)
title('$\ln$ T(VA)','Interpreter','latex','FontSize',18);
view([-39.5089 30.5870])
subplot(2, 2, 4);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnPhi,...
    initializedVars,simulationElasticities,0)
title('$\ln$ $\phi$','Interpreter','latex','FontSize',18);
view([-39.5089 30.5870])

exportgraphics(figure_Supplybeta3D,fullfile('.', 'output', 'figures','Figure3_supplyBeta3D.jpg'));

% FIGURE C.1.: Supply beta (Winsorized)
figure_Supplybeta3D_winsorized = figure;
subplot(2, 2, 1);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnHOT,...
    initializedVars, simulationElasticities,'useWinsor')
view([-39.5089 30.5870])
title('$\ln$ HOT','Interpreter','latex','FontSize',18);
subplot(2, 2, 2);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnX*10,...
    initializedVars,simulationElasticities,'useWinsor')
view([-39.5089 30.5870])
title('$\ln$ X','Interpreter','latex','FontSize',18);
subplot(2, 2, 3);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnTVA*100,...
    initializedVars,simulationElasticities,'useWinsor')
title('$\ln$ T(VA)','Interpreter','latex','FontSize',18);
view([-39.5089 30.5870])
subplot(2, 2, 4);
graph3Dregression(supplySimulation.lnV, supplySimulation.lnPhi,...
    initializedVars,simulationElasticities,'useWinsor')
title('$\ln$ $\phi$','Interpreter','latex','FontSize',18);
view([-39.5089 30.5870])

exportgraphics(figure_Supplybeta3D_winsorized,fullfile('.', 'output', 'figures','FigureC1_supplyBeta3D_winsorized.jpg'));

% FIGURE 4: Demand beta
figure_Demandbeta3D = figure;

subplot(2, 2, 1);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnHOT,...
    initializedVars, simulationElasticities,0)
title('$\ln$ HOT','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])
subplot(2, 2, 2);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnX*10,...
    initializedVars,simulationElasticities,0)
title('$\ln$ X','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])
subplot(2, 2, 3);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnTVA*100,...
    initializedVars,simulationElasticities,0)
title('$\ln$ T(VA)','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])
subplot(2, 2, 4);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnPhi,...
    initializedVars,simulationElasticities,0)
title('$\ln$ $\phi$','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])

exportgraphics(figure_Demandbeta3D,fullfile('.', 'output', 'figures','Figure4_demandBeta3D.jpg'));

% FIGURE C.2.: Demand beta (Winsorized)
figure_Demandbeta3D_winsorized = figure;

subplot(2, 2, 1);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnHOT,...
    initializedVars, simulationElasticities, 'useWinsor')
title('$\ln$ HOT','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])
subplot(2, 2, 2);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnX*10,...
    initializedVars,simulationElasticities, 'useWinsor')
title('$\ln$ X','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])
subplot(2, 2, 3);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnTVA*100,...
    initializedVars,simulationElasticities, 'useWinsor')
title('$\ln$ T(VA)','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])
subplot(2, 2, 4);
graph3Dregression(demandSimulation.lnV, demandSimulation.lnPhi,...
    initializedVars,simulationElasticities, 'useWinsor')
title('$\ln$ $\phi$','Interpreter','latex','FontSize',18);
view([-36.9412 70.8234])

exportgraphics(figure_Demandbeta3D_winsorized,fullfile('.', 'output', 'figures','FigureC2_demandBeta3D_winsorized.jpg'));

close(gcf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%