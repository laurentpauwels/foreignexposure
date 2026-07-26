function TVA = getTiVA(Z,F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getTiVA.m extract Trade-in-Value-Added (TiVA_i^r) as discussed in 
% Johnson and Noguera (2012). The difference is that this measure is summed 
% over all destination (j) countries. 
% Inputs:
%       Z      Double      intermediate input-output matrix (NRxNR) 
%       F      Double      Final demand (NRxN) matrix
% Output:
%       TiVA   Double      trade-in-value-added (NR x 1)
% Reference:
% Johnson, R. C. and Noguera, G. (2012). Accounting for intermediates: 
% Production Sharing and Trade in Value Added. 
% Journal of International Economics, 86(2):224 – 236.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NR = size(F,1);
N = size(F,2);
R = NR/N;

% Gross Output (PY)
Y = max(squeeze(sum(Z,2,'omitnan')) + squeeze(sum(F,2,'omitnan')),0);

% Value Added
VA = Y - transpose(squeeze(sum(Z,1,'omitnan')));%Value Added
VA(VA<0)=0;

% Direct requirement
A = Z ./ transpose(Y);
A(isinf(A)) = 0;
A(isnan(A)) = 0;

% Domestic only
Fdom = F.*kron(eye(N),ones(R,1));%squeeze(sum(F.*kron(eye(N),ones(nind,nfinal)),2));

% Final exports
XF =  squeeze(sum(F-Fdom,2,'omitnan'));

% TiVA
I = eye(R*N);%Identity matrix
TVA = diag(VA ./ Y) * ((I-A) \ XF); %Final exports
TVA(isinf(TVA)) = NaN;
end