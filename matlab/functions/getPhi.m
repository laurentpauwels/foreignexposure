function [phi_nr, phi_nrxn] = getPhi(Z, F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getPhi.m extract the phi-ness of trade as in Baldwin et al. (2003) 
% and Head and Mayer (2004).
% Inputs:
%       Z          Double      intermediate input-output matrix (NRxNR)
%       F          Double      Final demand (NRxN) matrix
% Output:
%       phi_nr     Double      phi-ness of trade measure (NR x 1)
%       phi_nrxn   Double      phi-ness of trade measure (NR x N) with 1's
%                              on the (i,i) diagonal (domestic).
% Note:
% Require partitionIO.m to turn Z into 5 dimension (R,R,N,N,T), with
% typical element (r,s,i,j,y)

% References:
% 1. Baldwin, R., Forslid, R., Martin, P., and Robert-Nicoud, F. (2003). 
% The Core-Periphery Model: Key Features and Effects. 
% In The Monopolistic Competition Revolution in Retrospect, 
% pages 213–235. Cambridge University Press.
% 2. Head, K. and Mayer, T. (2004). The Empirics of Agglomeration and Trade. 
% In Handbook of Regional and Urban Economics, chapter 59. North-Holland.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NR = size(F,1);
N = size(F,2);
R = NR/N;

Z_4D = reshape(Z,R,N,R,N);
Z_r_ij = squeeze(sum(Z_4D,3,'omitnan')); %sum_s: summing over all sector s per country
F_r_ij = reshape(F,R,N,N);

phi_nr = zeros(R,N);
phi_nrxn = zeros(R*N,N);
for i = 1:N
    phiv_ijr = zeros(R,N-1);
    phif_ijr = ones(R,N);
    v = 0;
    for j = 1:N
        if i == j
            continue
        end
        v = v + 1;

        % Intermediates
        z_ij = squeeze(Z_r_ij(:,i,j));
        z_ji = squeeze(Z_r_ij(:,j,i));
        z_ii = squeeze(Z_r_ij(:,i,i));
        z_jj = squeeze(Z_r_ij(:,j,j));

        % Finals
        f_ij = squeeze(F_r_ij(:,i,j));
        f_ji = squeeze(F_r_ij(:,j,i));
        f_ii = squeeze(F_r_ij(:,i,i));
        f_jj = squeeze(F_r_ij(:,j,j));

        % Totals
        zf_ijjiy_prod = (z_ij+f_ij) .* (z_ji+f_ji);
        zf_iijjy_prod = (z_ii+f_ii) .* (z_jj+f_jj);
        phiv_ijr(:,v) = sqrt(zf_ijjiy_prod ./ zf_iijjy_prod);
        phif_ijr(:,j) = phiv_ijr(:,v);
    end

    phiv_ijr(isinf(phiv_ijr)) = NaN;
    phif_ijr(isinf(phif_ijr)) = NaN;

    phi_nrxn((i-1)*R+1:i*R,:) = phif_ijr;

    %Sum of phi_ijr over j neq i
    phi_nr(:,i) = sum(phiv_ijr,2,'omitnan');

end
phi_nr = reshape(phi_nr,R*N,1);
end