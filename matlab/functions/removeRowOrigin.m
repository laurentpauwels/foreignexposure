function response_cln = removeRowOrigin(response, initializedVars, nelastcomb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% removeRowOrigin.m: removes the ROW and the country of origin for the
% shock, in this case the US.
% Inputs:
%       response            Double    simulated response (R,N,#elast. comb) 
%       initializedVars     Structure contain all required variables
%       nelastcomb          Double    # of combination .rho, .esp
% Output:
%       response_cln        Double    simulated response without USA and ROW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nind = initializedVars.nind;
ncty = initializedVars.ncty;
response = reshape(response,nind,ncty,nelastcomb);

% Remove RoW
response(:,contains(initializedVars.countrycode,{'ROW'}),:) = [];
% Remove USA
response(:,contains(initializedVars.countrycode,{'USA'}),:) = [];
% Reshape
response_cln = reshape(response,(ncty-2)*nind,nelastcomb);

end