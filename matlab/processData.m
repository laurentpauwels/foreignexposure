%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%processData.m produces 4 .mat files:                                 %
% - wiot16_strc.mat                                                   %
% - sea16_strc.mat                                                    %
% - ppp_natcupusd.mat                                                 %
% - industryShort.mat                                                 %
%Imbs & Pauwels (2025), "Measuring Foreign Exposure"                  %
% Required data:                                                      %
%   - WIOT folder with CSV data                                       %
%   - SEA16 folder with Socio_Economic_Accounts.xlsx                  %
%   - imf-dm-export-20191120.xls                                      %
%   - WIOT16_description.xlsx                                         %
% Required scripts/functions:                                         %
%   - processSEA16.m                                                  %
%   - processWIOT16.m                                                 %
% NOTE: WIOD provides the data in XLSB format. Python is used to      % 
% convert XLSB into CSV files.                                        % 
% See convertXlsb2Csv.py code for unzipping and convertion.           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PATHS
% Add folders to path
io_funfolder = fullfile('.', 'functions');
io_scrfolder = fullfile('.', 'scripts');
io_dtrfolder = fullfile('.', 'data','raw','IMF',filesep);
io_dtpfolder = fullfile('.', 'data','processed',filesep);

addpath(io_funfolder);
addpath(io_scrfolder);
addpath(io_dtrfolder);
addpath(io_dtpfolder);

%% WIOD SEA16 Data Parsing
% The approximations (Tables 3-6) require parameter alpha
% alpha = Labor Compensation / Value Addded (in national currency)
% This is constructed from WIOD Socio-Economic Accounts (2016 release)
% Source: https://www.rug.nl/ggdc/valuechain/wiod/wiod-2016-release

% Parsing WIOD Socio-Economic Accounts (2016 release)
run("processSEA16.m")
clear

%% wiot16 Data Processing
% Source: WIOD 2016 release data is downloaded at http://wiod.org
run("processWIOT16.m")
clear

%% IMF PPP Data Processing
% Implied PPP conversion rate (National currency per international dollar)
% Source: IMF, variable=PPPEX 
% downloaded at http://www.econstats.com/weo/V013.htm on 20 Nov 2019

% Load WIOD16 data
load('sea16_strc.mat')
countries = sea16_text.countries;

% Import readme excel file
IMF_filename = 'imf-dm-export-20191120.xls';
IMF_table = readtable(IMF_filename , "UseExcel", false);

IMF_str.countries = table2cell(IMF_table(3:end,1));
IMF_str.years = table2array(IMF_table(1,2:end));
IMF_str.ppp = table2array(IMF_table(3:end,2:end));

[~,imfIdx] = ismember(countries,IMF_str.countries);
% These countries do no match due to differences in naming WIOD vs IMF:
% Hardcoding:
imfIdx(contains(countries,'Korea'),1) = find(contains(IMF_str.countries,'Korea'));
imfIdx(contains(countries,'Slovakia'),1) = find(contains(IMF_str.countries,'Slovak'));
imfIdx(contains(countries,'Taiwan'),1) = find(contains(IMF_str.countries,'Taiwan'));
imfIdx(contains(countries,'United Kingdom'),1) = find(contains(IMF_str.countries,'United Kingdom'));

yrsIdx = find(IMF_str.years>1999 & IMF_str.years<2015);
ppp_natcupusd = IMF_str.ppp(imfIdx,yrsIdx);%PPP national currency per international dollar

% save data into .mat file
save('./data/processed/ppp_natcupusd.mat', 'ppp_natcupusd');
clear

%% Industries name shortened
% For graphical representation names of industries are shortened. The
% mapping of the original industry name as in WIOD16 and industry codes 
% are contained in the excel file: WIOT16_description.xlsx. 
% Names of industries are shortened arbitrarily.

% Specify options, column names and types
opts = spreadsheetImportOptions("NumVariables", 7);
opts.Sheet = "Industries";
opts.DataRange = "A2:G57";
opts.VariableNames = ["V1", "V2", "V3", "V4", "V5", "V6", "industryShortName"];
opts.SelectedVariableNames = "industryShortName";
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char"];

% Import the data
WIOT16description = readtable("./data/raw/WIOD/WIOT16_description.xlsx", opts, "UseExcel", false);

% Convert to cell
industryShort = table2cell(WIOT16description);
numIdx = cellfun(@(x) ~isnan(str2double(x)), industryShort);
industryShort(numIdx) = cellfun(@(x) {str2double(x)}, industryShort(numIdx));

% Clear temporary variables
clear numIdx opts WIOT16description

% save data into .mat file
save('./data/processed/industryShort.mat', 'industryShort');
clear

