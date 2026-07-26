function simulatedResponses = runSimulation(initializedVars, elasticities, shock, shockType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runSimulation.m computes the simulations. 
% Inputs:
%       initializedVars     Structure contain all required variables 
%       elasticities        Structure elasticities: .rho, .esp, .psi
%       shock               Double    vector of supply/demand shocks (NR x 1)
%       shockType           String    specifying the model type 
%                                     ('supplyShock' or 'demandShock')
% Output:
%       simulatedResponses  table     table with output ((NRxNumberElasticities) x 1)
% Required functions:                                                 %
%   - getScriptMatrix.m
%   - getSimulationModel.m 
%   - getSteadyStateMeasures.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nelastComb = size(elasticities.rho,1);

%% Use the parameters from initializedVars
nind = initializedVars.nind;
ncty = initializedVars.ncty;


%% SIMULATIONS
lnY  = zeros(ncty*nind,nelastComb);
lnP  = zeros(ncty*nind,nelastComb);
lnPc = zeros(ncty*nind,nelastComb);
lnPY = zeros(ncty*nind,nelastComb);
lnV  = zeros(ncty*nind,nelastComb);

lnHOT = zeros(ncty*nind,nelastComb);
lnX   = zeros(ncty*nind,nelastComb);
lnTVA = zeros(ncty*nind,nelastComb);
lnPhi = zeros(ncty*nind,nelastComb);

Inan = ones(nind*ncty,1);
Inan(initializedVars.PYbar==0) = NaN;
parfor e = 1:nelastComb

    % MODEL KEY MATRICES: scriptT, scriptM, scriptP, scriptH, Lambda
    scriptMatrices = getScriptMatrix(elasticities, initializedVars, e);

    % MODEL - US SHOCK
    switch shockType
        case 'supplyShock'
            modelResponses = getSimulationModel(elasticities.psi(e,1),...
                scriptMatrices, initializedVars, shock, shockType);
        case 'demandShock'            
            modelResponses = getSimulationModel(elasticities.psi(e,1),...
                scriptMatrices, initializedVars, shock, shockType);
            %modelResponses = getTransportCostResponse(scriptMatrices,...
            %    initializedVars, elasticities, shock, e)
            otherwise
        error('Invalid model type. Choose either "supplyShock" or "demandShock".');
    end
    lnY(:,e)  = (modelResponses.lnY).*Inan;
    lnP(:,e)  = (modelResponses.lnP).*Inan;
    lnPc(:,e) = (modelResponses.lnPc).*Inan;
    lnPY(:,e) = (modelResponses.lnPY).*Inan;
    lnV(:,e)  = (modelResponses.lnV).*Inan;

    % OPENNESS MEASURES
     exposureResponses = getSteadyStateMeasures(elasticities,...
        initializedVars, modelResponses, e);

    lnHOT(:,e) = (exposureResponses.lnHOT).*Inan;
    lnX(:,e)   = (exposureResponses.lnX).*Inan;
    lnTVA(:,e) = (exposureResponses.lnTVA).*Inan;
    lnPhi(:,e) = (exposureResponses.lnPhi).*Inan;
    fprintf('Just finished simulation #%d\n', e);

end

%% Store the results in structure
simulatedResponses = struct();
simulatedResponses.lnY  = lnY;
simulatedResponses.lnP  = lnP;
simulatedResponses.lnPc = lnPc;
simulatedResponses.lnPY = lnPY;
simulatedResponses.lnV  = lnV;

simulatedResponses.lnHOT = lnHOT;
simulatedResponses.lnX   = lnX;
simulatedResponses.lnTVA = lnTVA;
simulatedResponses.lnPhi = lnPhi;

simulatedResponses.nelastComb = nelastComb;
end