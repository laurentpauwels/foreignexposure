function HOT = getHOT(Z,F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getHOT.m extract the downstream impact of foreign shocks (global 
% value chains), i.e. the impact on country/ies,sector(s) (i,r) of shocks
% in all other countries j.
% Inputs:
%       Z     Double      intermediate input-output matrix (NRxNR) 
%       F     Double      Final demand (NRxN) matrix
% Output:
%       HOT   Double       downstream measure (NR x 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NR = size(F,1);
N = size(F,2);
R = NR/N;

% Gross Output (PY)
Y = max(squeeze(sum(Z,2,'omitnan')) + squeeze(sum(F,2,'omitnan')),0);

% Direct requirement
A = Z ./ transpose(Y);
A(isinf(A)) = 0;
A(isnan(A)) = 0;

% Domestic only
Fdom = sum(F.*kron(eye(N),ones(R,1)),2,'omitnan');%squeeze(sum(F.*kron(eye(N),ones(nind,nfinal)),2));
Adom = A.*kron(eye(N),ones(R));%Domestic direct requirement

% HOT
I = eye(R*N);
YA = (I-A)\sum(F,2,'omitnan'); 
HOT = 1-(((I-Adom)\Fdom)./YA);
HOT(HOT<0) = 0;
HOT(isinf(HOT)) = NaN;
end

