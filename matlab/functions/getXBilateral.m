function X_ijrs = getXBilateral(Y, Z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getXBilateral.m constructs a bilateral export matrix.
% Inputs:
%       Z          Double     IO matrix size (NRxNR)
%       Y          Double     Denominator (VA or GO) size (R,N)
% Output:
%       X_ijrs     Double      Bilateral exports (R*R,pairs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[R,N] = size(Y);
Z_rxnxrxn = reshape(Z,R,N,R,N);

pairs = (N*(N-1))/2;
X_ijrs = zeros(R*R,pairs);
v = 0;
for i = 1:N-1
    for j = i+1:N
        v = v + 1;

        Z_ij = squeeze(Z_rxnxrxn(:,i,:,j));
        Z_ji = squeeze(Z_rxnxrxn(:,j,:,i));
        Z_ijji_sum = Z_ij + Z_ji;
        sum_y_ijr = (squeeze(Y(:,i))+squeeze(Y(:,j)));
        X_ijrs_mat = Z_ijji_sum ./ sum_y_ijr;
        X_ijrs(:,v) = reshape(X_ijrs_mat',R*R,1);
    end
end
X_ijrs(isinf(X_ijrs)) = NaN;
end