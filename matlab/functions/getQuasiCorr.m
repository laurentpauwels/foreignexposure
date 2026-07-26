function quasicorr = getQuasiCorr(X,demean)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getQuasiCorr.m constructs the Quasi-Correlation of Vector X. The whole time
% dimension T is required to calculate the standard deviation and demeaning
% the series. 
% Inputs:
%       X          Double     vector of size (NR,T) 
%       demean     int        Option to de-mean X or not
% Output:
%       quasicorr  Double     Quasi-Correlation matrix size (NRx(NR-1)/2,T)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[R,N,T] = size(X);%defining dimension 
pairs = (N*(N-1))/2;%pairs of countries

quasicorr = zeros(R*R,pairs,T);
for y = 1:T
    v = 0;
    for i = 1:N-1
        for j = i+1:N           
            v = v + 1;
            g_it = squeeze(X(:,i,y)); %VA growth in sect r of cty i at t
            g_jt = squeeze(X(:,j,y)); %VA growth in sect r of cty j at t
            if demean == 1
                gbar_i = squeeze(mean(X(:,i,:),3,'omitnan')); %average over time of g_irt
                gbar_j = squeeze(mean(X(:,j,:),3,'omitnan'));
            else
                gbar_i = 0;
                gbar_j = 0;
            end
            s_i = squeeze(std(X(:,i,:),0,3,'omitnan')); %standard dev. over time of g_irt
            s_j = squeeze(std(X(:,j,:),0,3,'omitnan'));
            s_i_s_j = s_i*transpose(s_j); 

            q_ijrsy_prod = ((g_it - gbar_i)*transpose(g_jt - gbar_j))./(s_i_s_j); %(R x 1) x (1 x R)
            quasicorr(:,v,y) = reshape(transpose(q_ijrsy_prod),R*R,1);
        end
    end
end

end