function phi_ijrs = getPhiBilateral(Z,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getPhiBilateral.m constructs the bilateral version of phi.
% Inputs:
%       Z          Double     matrix of size (NRxNR)
%       N          Int        Number of Countries
% Output:
%       phi_ijrs   Double     Bilateral phi (R*R,pairs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[NR,~] = size(Z);
R = NR/N;
Z_rxnxrxn = reshape(Z,R,N,R,N);

pairs = (N*(N-1))/2;
phi_ijrs = zeros(R*R,pairs);
v = 0;
for i = 1:N-1
    for j = i+1:N
        v = v + 1;

        Z_ij = squeeze(Z_rxnxrxn(:,i,:,j));
        Z_ji = squeeze(Z_rxnxrxn(:,j,:,i));
        Z_ijji_prod = Z_ij .* Z_ji;

        Z_ii = squeeze(Z_rxnxrxn(:,i,:,i));
        Z_jj = squeeze(Z_rxnxrxn(:,j,:,j));
        Z_iijjy_prod = Z_ii .* Z_jj;

        phi_mat = sqrt(Z_ijji_prod ./ Z_iijjy_prod);
        phi_ijrs(:,v) = reshape(phi_mat',R*R,1);
    end
end
phi_ijrs(isinf(phi_ijrs)) = NaN;
end