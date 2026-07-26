%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%multilateralMeasures.m produces multilateral.txt.                    %
%Imbs & Pauwels (2025), "Measuring Foreign Exposure"                  %
% Required data:                                                      %
%   - ppp_natcupusd.mat                                               %
%   - industryShort.mat                                               %
%   - sea16_strc.mat                                                  %
%   - wiot16_strc.mat                                                 %
% Required functions:                                                 %
%   - getHOT.m                                                        %
%   - getPhi.m                                                        %
%   - getTiVA.m                                                       %                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PATHS
% Add folders to path
io_funfolder = fullfile('.', 'functions');
io_scrfolder = fullfile('.', 'scripts');
io_dtafolder = fullfile('.', 'data','processed',filesep);
io_outfolder = fullfile('.', 'output');

addpath(io_funfolder);
addpath(io_scrfolder);
addpath(io_dtafolder);
addpath(io_outfolder);

% output text file (xls takes too long)
filename_output = './output/multilateral.txt';
  
%% DATA PROCESSING
load('ppp_natcupusd.mat')% Load IMF PPP, Implied PPP conversion rate (National currency per international dollar)
load('industryShort.mat')% Load industry shortened names for graphical representations
load('sea16_strc.mat')% Load WIOD Socio-Economic Accounts data
load('wiot16_strc.mat')% Load WIOD16 data

% Defining IDs
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

%PM matrix with PM_ij^rs as a typical element.
PM = wiot16_data.Z;
PMdom = PM.*kron(eye(ncty),ones(nind));% Domestic only

%PF matrix with F_ij^dr as a typical element (d = # final categories per ctry).
PF = wiot16_data.F;
PFdom = PF.*kron(eye(ncty),ones(nind,ncat));% Domestic only

%Gross Output %(J x S by 1) by years.
PY = max(squeeze(sum(PM,2,'omitnan')) + squeeze(sum(PF,2,'omitnan')),0);

% Computing PVA (correct. net invent) in current USD.
PVA = squeeze(sum(PM,2,'omitnan')) + squeeze(sum(PF,2,'omitnan'))...
    - squeeze(sum(PM,1,'omitnan'));
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

%% OPENNESS MEASURES: HOT, PHI, TiVA, & EXPORTS 

%%% International Trade (X)
EXM = squeeze(sum(PM,2,'omitnan') - sum(PMdom,2,'omitnan'));%Intermediate Exports 
EXF = reshape(squeeze(sum(PF - PFdom,2,'omitnan')),nind*ncty,nyrs); %Final Exports.
EXP = EXM + EXF;

% PF_nrxn matrix with PF_ij^r (summing all final demand categories)
PF_nrxn = zeros(nind*ncty,ncty,nyrs);
for j=1:ncty
    PF_nrxn(:,j,:) = sum(PF(:,(j-1)*ncat+1:j*ncat,:),2);
end

%%% HOT, TiVA, Phi
HOT = zeros(nind*ncty,nyrs);
Phi = zeros(nind*ncty,nyrs);
TVA = zeros(nind*ncty,nyrs);
for ii = 1:nyrs
    % High Order Trade
    HOT(:,ii) = getHOT(PM(:,:,ii),PF_nrxn(:,:,ii));
    % Phiness of trade
    Phi(:,ii) = getPhi(PM(:,:,ii), PF_nrxn(:,:,ii));
    % TiVA
    TVA(:,ii) = getTiVA(PM(:,:,ii), PF_nrxn(:,:,ii));
end

%% %% RESHAPING for DATASET, IDs & OUTPUT TABLE %% %% 
% IDs
country_i = repmat(reshape(transpose(repmat(countrycode,1,nind)),nind*ncty,1),nyrs,1);
countryname_i = repmat(reshape(transpose(repmat([country;"Rest of World"],1,nind)),nind*ncty,1),nyrs,1);
sector_r = repmat(reshape(repmat(industryShort,1,ncty),nind*ncty,1),nyrs,1);
sector_long = repmat(reshape(repmat(industryname,1,ncty),nind*ncty,1),nyrs,1);
sectorcode_r = repmat(reshape(repmat(industrycode_wiod,1,ncty),nind*ncty,1),nyrs,1);
nacecode_r = repmat(reshape(repmat(industrycode,1,ncty),nind*ncty,1),nyrs,1);
year = kron(years,ones(nind*ncty,1));

% Main variables
hot_ir = reshape(HOT,nind*ncty*nyrs,1);
x_ir = reshape(EXP,nind*ncty*nyrs,1);
tva_ir = reshape(TVA,nind*ncty*nyrs,1);
phi_ir = reshape(Phi,nind*ncty*nyrs,1);
go = reshape(PY,nind*ncty*nyrs,1);%Gross Output
va = reshape(PVA_usdIntrap,nind*ncty*nyrs,1);
va_natcur = reshape([PVA_natcurIntrap;nan(nind,nyrs)],nind*ncty*nyrs,1);%VA in national currency (Millions)

%Prices and Exchange rates
ppp_usdpnatcu_ir = reshape(kron([1./ppp_natcupusd;nan(1,nyrs)],ones(nind,1)),nind*ncty*nyrs,1); % PPP is National currency per international dollar
va_pi = reshape([sea16_data.VA_PI;nan(nind,nyrs)],nind*ncty*nyrs,1);%Industry price indices

% Output Table (Dataset)
tab1 = table(countryname_i, country_i,...
    sector_long, sector_r, sectorcode_r, nacecode_r, year,... 
    hot_ir,phi_ir, x_ir, tva_ir,...
    go,va_natcur, va, va_pi,ppp_usdpnatcu_ir);

writetable(tab1,filename_output)

clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%%%%%%%%%%%%%%%%%% %% END OF PROGRAMMING FILE %% %%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%