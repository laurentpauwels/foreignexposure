function scriptMatrices = getScriptMatrix(elasticities, initializedVars, e)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getScriptMatrix.m computes the main components of the Huo et al (2023) 
% model: scriptH, scriptP, scriptM, and Lambda.
% Inputs:
%       elasticities    structure  elasticity vectors: .rho, .esp, .psi
%       initializedVars structure  contains matrices: 
%              .AT_mm   Double  intermediate use trade share (NRxNR)
%              .AT_c    Double  final use trade share (NxNR)
%              .B_m     Double  share of src sect used as intermed. inputs (NRxNR)
%              .B_c     Double  share of upstream output used in final cons. (NRxN)
%              .Upsilon Double  share of nominal VA in total nominal cons. (NxNR)
%              .alpha   Double  labour share (NRx1)
%              .eta     Double  share of value added in production (NRx1)
%       e               integer loop index value
% Output in scriptMatrices structure:
%       .SM      Double  Script M (NRxNR)
%       .SP      Double  Script P (NRxNR)
%       .SH      Double  Script H (NRxNR)
%       .Lambda  Double  Lambda (NRxNR)
% Required functions
% - getScriptM.m
% - getScriptH.m
% - getScriptP.m
% - getScriptD.m
% - getLambda.m
% Note that Lambda is NOT defined as the inverse (unlike Huo et al., 2021)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialized variables
AT_mm = initializedVars.AT_mm;
AT_c = initializedVars.AT_c;
B_m = initializedVars.B_m;
B_c = initializedVars.B_c;
Upsilon = initializedVars.Upsilon;
alpha = initializedVars.alpha;
eta = initializedVars.eta;

% Elasticities
rho = elasticities.rho(e,1);%Final goods substitution elasticity
eps = elasticities.eps(e,1);%Intermediate goods substitution elasticity
psi = elasticities.psi(e,1);%Frisch elasticity

% Script Matrices
SM = getScriptM(rho, eps, B_m, B_c, AT_mm, AT_c, Upsilon);%script M
if rho == 1 && eps == 1
    SP = -eye(size(SM,1),size(SM,2));%script P in Cobb-Douglas case
else
    SP = getScriptP(B_m, B_c, Upsilon, SM);%script P
end
SH = getScriptH(psi, AT_c, SP); %Script H (without LAMBDA)
SD = getScriptD(psi, alpha, eta, AT_mm, AT_c, SM); %Script D
Lambda = getLambda(psi, alpha, eta, AT_mm, AT_c, SP);%LAMBDA NOT INVERSED

% Store the results in structure
scriptMatrices = struct();
scriptMatrices.SM = SM;
scriptMatrices.SP = SP;
scriptMatrices.SH = SH;
scriptMatrices.SD = SD;
scriptMatrices.Lambda = Lambda;
end
