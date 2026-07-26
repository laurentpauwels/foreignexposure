function [country_i, country_j, sectcode_r, sectcode_s, sector_r, sector_s, year] = ...
    getIdBilateral(indname,indcode, ctrycode, years)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getIdBilateral.m returns the bilateral pairs of countries (i,j), pairs of 
% industries (r,s), and years in ordered sequence corresponding to the 
% measures and data generated in bilateralMeasures.m. The lists are of size
% [(R*R)*(N*(N-1)/2]*T
% Inputs:
%       indname               cell      list of industry name (short)
%       indcode               cell      list of industry code 
%       ctrycode              cell      list of country code (or name)
%       years                 double    list of years covered
% Output:
%       country_i           cell      list of countries   
%       country_j           cell      list of countries   
%       sector_r            cell      list of industries 
%       sector_s            cell      list of industries
%       sectcode_r          cell      list of industry code
%       sectcode_s          cell      list of industry code
%       year                double    list of years
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nind = size(indcode,1);
nctry =  size(ctrycode,1);
nyrs = size(years,1);

pairs = (nctry*(nctry-1))/2;


sector_r = cell((nind*nind)*(pairs)*nyrs,1);
sector_s = cell((nind*nind)*(pairs)*nyrs,1);
sectcode_r = cell(nind*nctry*nyrs,1);
sectcode_s = cell(nind*nctry*nyrs,1);
country_i = cell((nind*nind)*(pairs)*nyrs,1);
country_j = cell((nind*nind)*(pairs)*nyrs,1);
year = zeros((nind*nind)*(pairs)*nyrs,1);

v = 0;

for y = 1:nyrs
    for i = 1:nctry-1
        for j = i+1:nctry
            for r = 1:nind
                for s = 1:nind
                    v = v + 1;
                    sectcode_r(v,1) = indcode(r,1);
                    sectcode_s(v,1) = indcode(s,1);
                    sector_r(v,1) = indname(r,1);
                    sector_s(v,1) = indname(s,1);
                    country_i(v,1) = ctrycode(i,1);
                    country_j(v,1) = ctrycode(j,1);
                    year(v,1) = years(y,1);
                end
            end
        end
    end
end

end