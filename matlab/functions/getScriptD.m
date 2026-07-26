function SD = getScriptD(psi, alpha, eta, AT_mm, AT_c, SM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getScriptD.m returns Script D
% Inputs:
%       psi     Int     Frisch Labour Elasticity
%       eta     Double  share of value added in production (NRx1)
%       AT_mm   Double  intermediate use trade share (NRxNR)
%       AT_c    Double  final use trade share (NxNR)
%       SM      Double  script M (NRxNR)
% Output:
%       DA      Double  scriptD (NRxNR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Lambda
I = eye(size(AT_c,2), size(AT_c,2));
AC = kron(AT_c, ones(size(AT_c,2)/size(AT_c,1),1));
SD = (psi/(1+psi))*diag(eta)*diag(alpha)*(I-AC)*pinv(I-SM)...
                         + (I-diag(eta))*(I-AT_mm)*pinv(I-SM);
end

