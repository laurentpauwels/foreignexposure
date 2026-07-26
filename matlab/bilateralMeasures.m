%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bultilateralMeasures.m produces bilateral.txt.                    %
%Imbs & Pauwels (2025), "Measuring Foreign Exposure"                  %
% Required data:                                                      %
%   - ppp_natcupusd.mat                                               %
%   - industryShort.mat                                               %
%   - sea16_strc.mat                                                  %
%   - wiot16_strc.mat                                                 %
% Required functions:                                                 %
%   - getHOT.m                                                        %
%   - getPhi.m                                                        %
%   - getTiVA.m                                                       % 
%   - getPhiBilateral.m                                               %
%   - getXBilateral.m                                                 % 
%   - getQuasiCorr.m                                                  % 
%   - getIdBilateral.m                                                % 
%   - getLowerTriangle.m                                              % 
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
filename_output = './output/bilateral.txt';
  
%% DATA PROCESSING
% Load IMF PPP, Implied PPP conversion rate 
% (National currency per international dollar)
load('ppp_natcupusd.mat')

% Load industry shortened names for graphical representations
load('industryShort.mat')

% Load WIOD Socio-Economic Accounts data
load('sea16_strc.mat')

% Load WIOD16 data
load('wiot16_strc.mat')

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

%Z matrix with Z_ij^rs as a typical element.
PM = wiot16_data.Z;
PMdom = PM.*kron(eye(ncty),ones(nind));% Domestic only

%F matrix with F_ij^dr as a typical element (d = # final categories per ctry).
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

% PF_nrxn matrix with F_ij^r (summing all final demand categories)
PF_nrxn = zeros(nind*ncty,ncty,nyrs);
for j=1:ncty
    PF_nrxn(:,j,:) = sum(PF(:,(j-1)*ncat+1:j*ncat,:),2);
end

% PPP PVA:
ppp_usdpnatcu = reshape(kron([1./ppp_natcupusd;nan(1,nyrs)],ones(nind,1)),...
    nind*ncty,nyrs);
pva_ppp = [PVA_natcurIntrap;nan(nind,nyrs)].*ppp_usdpnatcu;

%%% HOT, TiVA, Phi, PX/PY, PX/PVA

pairs = (ncty*(ncty-1))/2;%pairs of countries

HOT = zeros(nind*ncty,nyrs);
TVA = zeros(nind*ncty,nyrs);
hot_ijrs = zeros(nind*nind*pairs,nyrs);
tva_ijrs = zeros(nind*nind*pairs,nyrs);
phi_ijrs = zeros(nind*nind,pairs,nyrs);
xva_ijrs = zeros(nind*nind,pairs,nyrs);
xgo_ijrs = zeros(nind*nind,pairs,nyrs);
for ii = 1:nyrs
    % High Order Trade
    HOT(:,ii) = getHOT(PM(:,:,ii),PF_nrxn(:,:,ii));
    hot_ijrs(:,ii) = getLowerTriangle(ncty,HOT(:,ii));
    % TiVA
    TVA(:,ii) = getTiVA(PM(:,:,ii), PF_nrxn(:,:,ii));
    tva_ijrs(:,ii) = getLowerTriangle(ncty,TVA(:,ii));
    % Phi
    phi_ijrs(:,:,ii) = getPhiBilateral(PM(:,:,ii),ncty);
    % X/VA
    xva_ijrs(:,:,ii) = getXBilateral(reshape(pva_ppp(:,ii),nind,ncty),PM(:,:,ii));
    % X/GO
    xgo_ijrs(:,:,ii) = getXBilateral(reshape(PY(:,ii),nind,ncty),PM(:,:,ii));
end


%% %% SYNCHRONIZATION MEASURES %% %% 

%%Real value added:
va_pi = reshape([sea16_data.VA_PI;nan(nind,nyrs)],nind,ncty,nyrs);%Industry price indices
rva = (reshape(pva_ppp,nind,ncty,nyrs)./ va_pi)*100; 

%%Real growth rate
%d.ln(rVA_it/N_it) = ln[ (rVA_it) / (rVA_it-1) ] :
dva = nan(nind,ncty,nyrs);%First year is NaN (lost due to differencing) 
dva(:,:,2:end) = rva(:,:,2:nyrs) ./ rva(:,:,1:nyrs-1);
dva(dva<0) = NaN;%Remove rare case of negative VA
dlva = log(dva);
dlva(isinf(dlva)) = NaN;%Remove rare case of Inf or -Inf

%%Quasi correlction of real growth rate:
qdva_ijrs = getQuasiCorr(dlva,1);

%% %% RESHAPING for DATASET, IDs and OUTPUT TABLE %% %% 

% Main variables
xva_ijrs = reshape(xva_ijrs,nind*nind*pairs*nyrs,1);
xgo_ijrs = reshape(xgo_ijrs,nind*nind*pairs*nyrs,1);
phi_ijrs = reshape(phi_ijrs,nind*nind*pairs*nyrs,1);
tva_ijrs = reshape(tva_ijrs,nind*nind*pairs*nyrs,1);
hot_ijrs = reshape(hot_ijrs,nind*nind*pairs*nyrs,1);
qdva_ijrs = reshape(qdva_ijrs,nind*nind*pairs*nyrs,1);

% IDs
[country_i, country_j, sectcode_r, sectcode_s, sector_r, sector_s, year] = ...
    getIdBilateral(industryShort, industrycode_wiod, countrycode, years); 

% Output Table (Dataset)
tab = table(country_i, country_j, sector_r, sector_s, sectcode_r, sectcode_s, year, ...
hot_ijrs, tva_ijrs, xva_ijrs, xgo_ijrs ,phi_ijrs, ...
qdva_ijrs);

writetable(tab,filename_output) 
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% %% END OF PROGRAMMING FILE %% %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%