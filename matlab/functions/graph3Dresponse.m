function graph3Dresponse(response, elasticities, initializedVars,...
                            graphBoundaries)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph3Dresponse.m:
% Inputs:
%       response            Double    simulated response lnVhat (R,N,#elast. comb) 
%       elasticities        Structure elasticities: .rho, .esp, .psi
%       initializedVars     Structure contain all required variables 
%       graphBoundaries     Structure contain int max_val and min_val boundaries
% Output:
%       3D Graph of simulated response to a shock
% Required functions:                                                 %
%   - removeRowOrigin.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sim_rho = elasticities.rho;
sim_eps = elasticities.eps;
nelastcomb = size(sim_rho,1);

max_val = graphBoundaries.max_val;
min_val = graphBoundaries.min_val;

response_cln  = removeRowOrigin(response, initializedVars, nelastcomb);
median_response = transpose(median(response_cln,1,'omitnan'));


tab_ctrysect = table(sim_rho,sim_eps,median_response,...
    'VariableNames',["rho","eps","response"]);
tab_ctrysect.response(tab_ctrysect.response>max_val,:) = max_val;
tab_ctrysect.response(tab_ctrysect.response<min_val,:) = min_val;

rho = unique(sim_rho);
eps = unique(sim_eps);

format shortG
fprintf('The average response in the simulations is equal #%f',...
    round(mean(tab_ctrysect.response,1,'omitnan'),4));

%axes1 = axes('Parent',figure1);
%hold(axes1,'on');

[X,Y]=meshgrid(rho,eps);
Z = reshape(tab_ctrysect.response,size(Y));
C = Z;
surf(X,Y,Z,C)
colormap(gray)
colorbar
zlim([min_val max_val]);
xlabel('${\rho}$','Interpreter','latex','FontSize',18)
ylabel('${\epsilon}$','Interpreter','latex','FontSize',18)
zlabel('Response','Interpreter','latex','FontSize',18)
view([-38.238 12.378])
%view([-37.8381818181818 46.7999998616535]);
%grid(axes1,'on');
%hold(axes1,'off');
grid on
%colorbar(axes1);

end
% xlabel('Substitution in final goods (${\rho}$)','Interpreter','latex','FontSize',12,'Rotation',10)
% ylabel('Substitution in intermediates (${\epsilon}$)','Interpreter','latex','FontSize',12,'Rotation',-15);
% zlabel('Relative responses of CPI and output','Interpreter','latex','FontSize',12)
