function modelResponses = getSimulationModel(psi,...
    scriptMatrices, initializedVars, shock, shockType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getSimulationModel.m computes the key variables from Huo et al. (2023) in
% real and nominal terms at country-sector level. Note that "ln" stands for
% the log deviation of that variable from steady-state.
% Inputs:
%       psi             Integer     value of psi in loop index e
%       scriptMatrices  Structure   structure containing
%           .Lambda      Double  Lambda influence matrix (NRxNR)
%           .SH          Double  Script H matrix of coefficents (NRxNR)
%           .SM          Double  Script H matrix of coefficents (NRxNR)
%           .SP          Double  Script P matrix of coefficients (NRxNR)
%           .SD          Double  Script D matrix of coefficients (NRxNR)
%       initializedVars  Structure   structure containing
%           .AT_c        Double  final use trade share (NxNR)
%           .alpha       Double  labour share (NRx1)
%           .eta         Double  share of value added in production (NRx1)
%       shock            Double  vector of supply/demand/trade shocks (NR x 1)
%       shockType        String  specifying the model type ('supplyShock' or 'demandShock')
% Output in modelResponses structure
%       .lnY     Double  real output (NR x 1)
%       .lnP     Double  relative prices (NR x 1)
%       .lnPY    Double  nominal output (NR x 1)
%       .lnV     Double  real value added (NR x 1)
% Note that Lambda is NOT defined as the inverse (unlike Huo et al., 2021)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script Matrices:
SM = scriptMatrices.SM;
SP = scriptMatrices.SP;
SH = scriptMatrices.SH;
SD = scriptMatrices.SD;
Lambda = scriptMatrices.Lambda;

% Initialized Variables:
eta = initializedVars.eta;%labour share (NRx1)
alpha = initializedVars.alpha;%share of value added in production (NRx1)
AT_c = initializedVars.AT_c;%final use trade share (NxNR)

% Model
[NR,~] = size(SP);
N = size(AT_c,1);
I = eye(NR,NR);
AC = kron(AT_c, ones(NR/N,1));
switch shockType
    case 'supplyShock'
        lnY  = (I-Lambda)\shock;
        lnP  = SP*lnY;
        lnPc = AC*lnP;
        lnPY = lnP+lnY;
        lnH  = SH*lnY;
        lnV  = diag(1./eta)*shock + diag(alpha)*lnH;
    case 'demandShock'
        lnY  = (I-Lambda)\SD*shock;
        lnP  = SP*lnY + pinv(I-SM)*shock;
        lnPc = AC*lnP;
        lnPY = lnP+lnY;
        lnH  = SH*lnY+(psi/(1+psi))*(I-AC)*shock;
        lnV  = diag(alpha)*lnH;
    otherwise
        error('Invalid model type. Choose either "supplyShock" or "demandShock".');
end

% Store the results in structure
modelResponses = struct();
modelResponses.lnY  = lnY;
modelResponses.lnP  = lnP;
modelResponses.lnPc = lnPc;
modelResponses.lnPY = lnPY;
modelResponses.lnH  = lnH;
modelResponses.lnV  = lnV;
end