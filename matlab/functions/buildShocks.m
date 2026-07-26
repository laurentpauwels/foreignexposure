function [lnZfor, lnZdom] = buildShocks(wiot16_data, shockfor, countrycode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% buildShocks.m construct shock = Standard deviation of country GO
% Inputs:
%       wiot16_data structure   IO data WIOD 2016 
%       shockfor    Char        country of origin for supply/demand shock 
%       countrycode Cell        list of alpha-3 country codes (Nx1)
% Output:
%       lnZ         Double  vector of foreign supply shocks (NR x 1)
%       lnZdom      Double  vector of domestic supply shocks (NR x 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Construct PY
PM = wiot16_data.Z;%M matrix with M_ij^rs as a typical element.
PF = wiot16_data.F;%F matrix with F_ij^dr as a typical element (d = # final categories per ctry).
PY = max(squeeze(sum(PM,2,'omitnan')) + squeeze(sum(PF,2,'omitnan')),0);%Gross Output %(J x S by 1) by years.

N = size(countrycode,1);
R = size(PY,1)/N;
shock_vec = zeros(N,1);
for i = 1:N
    sPY = log(sum(PY((R*(i-1))+1:R*i,:),1));%log(sum_r PY_it^r)
    shock_vec(i,1) = 1 + (sqrt(var(sPY)) / mean(sPY)); %1 + Sdev(PY_it) / mean(PY_it)
end

%Foreign shock's country of origin
forcntryid = find(contains(countrycode,{shockfor}));

%Domestic shock: All shocks - Foreign shock's country
lnZdom = kron(log(shock_vec),ones(R,1));
lnZdom((R*(forcntryid-1))+1:(R*forcntryid),:) = 0;

%Foreign shock
lnZfor = zeros(R*N,1);
lnZfor((R*(forcntryid-1))+1:(R*forcntryid),:) = log(shock_vec(forcntryid,1)*ones(R,1)); 
end