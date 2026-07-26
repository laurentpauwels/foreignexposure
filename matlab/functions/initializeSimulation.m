function [initializedVars] = initializeSimulation(wiot16_data,wiot16_text,sea16_data,sea16_text)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initializeSimulation.m computes all necessary variables for the Simulations 
% Inputs:
%       wiot16_data     Structure   IO data WIOD 2016 data 
%       wiot16_text     Structure   IO meta data WIOD 2016 
%       sea16_data      Structure   Socio-Economic data WIOD 2016
%       sea16_text      Structure   Socio-Economic meta data WIOD 2016
%
% Output:
%       initializedVars     Structure contain all required variables 
% Required functions: 
% - getShares.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defining IDs
country = sea16_text.countries;
countrycode = wiot16_text.countrycode;%Alpha-3 country code
industryname = wiot16_text.industries;
industrycode = wiot16_text.industrycode;%NACE2 classification
industrycode_wiod = wiot16_text.industrycode_wiod;%WIOD 'r#' identification
years = wiot16_text.years;

% IO Dataset Parameters:
nind = size(industrycode,1); % # of industries
ncty = size(countrycode,1); % # of countries
nyrs = size(years,1); % # of years
ncat  = size(wiot16_text.finalcat,1); % # final demand categories

%% Intermediate demand, Final demand, Gross Output, and Value Added

PM = wiot16_data.Z;%M matrix with M_ij^rs as a typical element.
PF = wiot16_data.F;%F matrix with F_ij^dr as a typical element (d = # final categories per ctry).
PY = max(squeeze(sum(PM,2,'omitnan')) + squeeze(sum(PF,2,'omitnan')),0);%Gross Output %(J x S by 1) by years.
PC = PF(:,1:ncat:end,:) + PF(:,4:ncat:end,:);%consHouseholds + invest
PG = PF(:,2:ncat:end,:) + PF(:,3:ncat:end,:);%consNGO + consGov
%PF_nrxn = zeros(nind*ncty,ncty,nyrs);% PF_nrxn matrix with F_ij^r (summing all final demand categories)
%for j=1:ncty
%    PF_nrxn(:,j,:) = sum(PF(:,(j-1)*ncat+1:j*ncat,:),2);
%end
PVA = squeeze(sum(PM,2,'omitnan')) + squeeze(sum(PF,2,'omitnan'))...
    - squeeze(sum(PM,1,'omitnan'));% Computing PVA (correct. net invent) in current USD.
PVA(PVA<0)=NaN;

% USD and National Currency Nominal Value Added
% Fill missing values with Linear interpolation of neighboring, nonmissing
% values:
PVA_natcur = sea16_data.VA;
PVA_natcurIntrap = PVA_natcur;
PVA_natcurIntrap(PVA_natcurIntrap<=0) = NaN;

PVA_usdIntrap = PVA;
PVA_usdIntrap(PVA_usdIntrap<=0) = NaN;

for ii = 1:size(PVA_natcurIntrap,1)
    v = PVA_natcurIntrap(ii,:);
    idxNaN_v = isnan(v);
    numValsMissi_v = nnz(idxNaN_v);
    %Maximum 2 first missing obs and Maximum 2 last missing obs and no more
    %than 5 observations NaN
    if sum((isnan(v)),2) == nyrs || find(~idxNaN_v, 1, 'first') > 3 ...
            || find(~idxNaN_v, 1, 'last') < nyrs-2 || numValsMissi_v > 5
        v = nan(1,length(v));
    else
        v = fillmissing(v,'movmedian',10);
    end

    PVA_natcurIntrap(ii,:) = v;
end

for ii = 1:size(PVA_usdIntrap,1)
    w = PVA_usdIntrap(ii,:);
    idxNaN_w = isnan(w);
    numValsMissi_w = nnz(idxNaN_w);
    %Maximum 2 first missing obs and Maximum 2 last missing obs and no more
    %than 5 observations NaN
    if sum((isnan(w)),2) == nyrs || find(~idxNaN_w, 1, 'first') > 3 ...
            || find(~idxNaN_w, 1, 'last') < nyrs-2 || numValsMissi_w > 5
        w = nan(1,length(w));
    else
        w = fillmissing(w,'movmedian',10);
    end

    PVA_usdIntrap(ii,:) = w;
end

%% STEADY-STATE: Averages of WIOT Data
PYbar = squeeze(mean(PY,2, 'omitnan'));
PMbar = squeeze(mean(PM,3, 'omitnan'));
%PFbar_nrxn = squeeze(mean(PF_nrxn,3, 'omitnan'));
PCbar = squeeze(mean(PC,3, 'omitnan'));
%PGbar = squeeze(mean(PG,3, 'omitnan'));
PVAbar = squeeze(mean(PVA_usdIntrap,2, 'omitnan'));
PVAbar_natcur = squeeze(mean(PVA_natcurIntrap,2, 'omitnan'));
COMPbar = squeeze(mean(sea16_data.COMP,2, 'omitnan'));

%% MODEL COEFFICIENT AND PARAMETERS
% Share of value added in production:
eta = PVAbar ./ PYbar; %eta = VAbar./Ybar;
eta(eta>1) = NaN;
eta(eta<=0) = NaN;
etabar = repmat(squeeze(mean(reshape(eta,nind,ncty),2,'omitnan')),ncty,1);%Country averages

% Share of Labor:
alpha_r = COMPbar./PVAbar_natcur;
alpha_r(alpha_r>1) = NaN;
alpha_r(alpha_r<=0) = NaN;
alphabar = repmat(squeeze(mean(reshape(alpha_r,nind,ncty-1),2,'omitnan')),ncty,1);%Country averages

% A coefficients:
A_m = getShares(PMbar, transpose(PYbar));%PM ./ [PY_11,...,PY_ir,...,PY_NR]
Adom_m = A_m.*kron(eye(ncty,ncty),ones(nind,nind));%domestic only
AT_mm = transpose(getShares(PMbar,sum(PMbar,1,'omitnan'))); %A_mm^T with nansum(PMbar,1)) = 1xNR
ATdom_mm = AT_mm.*kron(eye(ncty,ncty),ones(nind,nind));%domestic only
AT_c = transpose(getShares(PCbar,sum(PCbar,1,'omitnan'))); %A_c^T with nansum(PCbar1c,1)) = 1xN
ATdom_c = AT_c.*transpose(kron(eye(ncty,ncty),ones(nind,1)));%domestic only

% B coefficients:
B_m = getShares(PMbar,PYbar);%PM ./ [PY_11;...;PY_ir;...;PY_NR]
Bdom_m = B_m.*kron(eye(ncty,ncty),ones(nind,nind));%domestic only
B_c = getShares(PCbar,PYbar);
Bdom_c = B_c.*kron(eye(ncty,ncty),ones(nind,1));%domestic only

% Upsilon:
PVAbar(isnan(PVAbar)) = 0;
PC_i = transpose(sum(PCbar,1, 'omitnan')); %transpose(PVAbar ./ kron(GDP,ones(nind,1)))
Upsilon = transpose(PVAbar./ kron(PC_i,ones(nind,1))) .* kron(diag(ones(ncty,1)),ones(1,nind));

%% STORE VARIABLES
% Steady-State Shares
initializedVars = struct();
initializedVars.PYbar = PYbar;
initializedVars.A_m = A_m;
initializedVars.Adom_m = Adom_m;
initializedVars.AT_mm = AT_mm;
initializedVars.ATdom_mm = ATdom_mm;
initializedVars.AT_c = AT_c;
initializedVars.ATdom_c = ATdom_c;
initializedVars.B_m = B_m;
initializedVars.Bdom_m = Bdom_m;
initializedVars.B_c = B_c;
initializedVars.Bdom_c = Bdom_c;
initializedVars.Upsilon = Upsilon;
initializedVars.alpha = alphabar;
initializedVars.eta = etabar;

% IO Dataset Parameters
initializedVars.nind = nind; % # of industries
initializedVars.ncty = ncty; % # of countries
initializedVars.nyrs = nyrs; % # of years
initializedVars.ncat = ncat; % # final demand categories

% IDs
initializedVars.country = country;
initializedVars.countrycode = countrycode; % Alpha-3 country code
initializedVars.industryname = industryname;
initializedVars.industrycode = industrycode; % NACE2 classification
initializedVars.industrycode_wiod = industrycode_wiod; % WIOD 'r#' identification
initializedVars.years = years;

end