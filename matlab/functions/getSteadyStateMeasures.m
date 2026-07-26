function exposureResponses = getSteadyStateMeasures(elasticities, initializedVars,...
                                                        modelResponses, e)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getSteadyStateMeasures.m computes the log deviation from steady-state of
% real exports, TiVA, and phiness of trade. 
% Inputs:
%       elasticities    Structure   elasticities: .rho, .esp, .psi
%       initializedVars Structure   containing:
%           .A_m        Double  direct requirement matrix (NRxNR)
%           .AT_mm      Double  intermediate use trade share (NRxNR)
%           .AT_c       Double  final use trade share (NxNR)
%           .B_m        Double  share of src sect used as intermed. inputs (NRxNR)
%           .B_c        Double  share of upstream output used in final cons. (NRxN)
%           .Upsilon    Double  share of nominal VA in total nominal cons. (NxNR)
%           .eta        Double  share of value added in production (NRx1)
%       modelResonses   Structure containing:
%           .lnP        Double  prices in deviations from steady-state (NR x 1)
%           .lnY        Double  real output in deviations from steady-state (NR x 1)
%       e               integer loop index value
% Output:
%       exposureResponse Structure:
%           .lnHOT      Double  log HOT in deviation from steady-state (NRx1)
%           .lnX        Double  log exports in deviation from steady-state (NRx1)
%           .lnTVA      Double  log TiVA in deviation from steady-state (NRx1)
%           .lnPhi      Double  log Phi in deviation from steady-state (NRx1)
% Required functions:                                                 %
%   - getPhi.m  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data Preparation

% Initialized variables
A_m = initializedVars.A_m;
Adom_m = initializedVars.Adom_m;
AT_mm = initializedVars.AT_mm;
ATdom_mm = initializedVars.ATdom_mm;
AT_c = initializedVars.AT_c;
ATdom_c = initializedVars.ATdom_c;
B_m = initializedVars.B_m;
Bdom_m = initializedVars.Bdom_m;
B_c = initializedVars.B_c;
Bdom_c = initializedVars.Bdom_c;
Upsilon = initializedVars.Upsilon;
eta = initializedVars.eta;

% Model Responses
lnP  = modelResponses.lnP;
lnPY = modelResponses.lnPY;

% Elasticities
rho = elasticities.rho(e,1);%Final goods substitution elasticity
eps = elasticities.eps(e,1);%Intermediate goods substitution elasticity

% Parameters and Steady-State Matrices A,B.
[NR,N] = size(B_c);
R = NR/N;

% Intermediate and final consumption as dev. from stst.
lnPM = lnPY;
lnPC = Upsilon*lnPY;

%% HOT
% Steady-State HOT
IA = (eye(size(A_m))-A_m);% (I-A) matrices
IAdom = (eye(size(Adom_m))-Adom_m);% (I-Adom) matrices
HOT = 1 - ((IAdom\Bdom_c*ones(size(Bdom_c,2),1)) ./ (IA\(B_c*ones(size(B_c,2),1))));% Steady-State HOT
HOT(HOT < 0.01) = NaN;%To discipline ratio = (1-HOT)/HOT.

%%% lnHOT
lnHOT = ((1-HOT)./HOT).*(lnPY);
lnHOT(isinf(lnHOT))=NaN;

%% TiVA
% Steady-State TiVA/VA.
IA = (eye(size(A_m))-A_m);
TVA = IA\(B_c-Bdom_c)*ones(N,1);

%%%lnTVA
H1 = (1-rho)*(diag(IA\B_c*ones(size(B_c,2),1)) - IA\B_c*AT_c)*lnP + IA\B_c*lnPC;
H2 = (1-rho)*(diag(IA\Bdom_c*ones(size(Bdom_c,2),1))-IA\Bdom_c*AT_c)*lnP + IA\Bdom_c*lnPC;
lnTVA = ((H1  - H2)./ TVA) - lnPY;
lnTVA(isinf(lnTVA)) = NaN;

%% Exports (X)

% Steady-State exports (PXi)
PX = (sum(B_m-Bdom_m,2)+sum(B_c-Bdom_c,2))./eta;
ETAPX = diag((1./PX).*(1./eta));

%%%lnPX
lnXI = (1-eps)*(diag((B_m-Bdom_m)*ones(size(B_m,2),1))-(B_m-Bdom_m)*(AT_mm-ATdom_mm))*lnP;
lnPI = (1-rho)*(diag((B_c-Bdom_c)*ones(size(B_c,2),1))-(B_c-Bdom_c)*(AT_c-ATdom_c))*lnP;
lnX = ETAPX*(lnXI + (B_m-Bdom_m)*lnPM + lnPI + (B_c-Bdom_c)*lnPC) - lnPY;


%% Phi
%Steady-State Phi (phi_ir) and Steady-State exports (PXj)
[phi_ir,phi_ijr] = getPhi(B_m, B_c);%Steady-State Phi
PHI = (phi_ijr.^(1/2)) ./ phi_ir;
PHI = PHI-PHI.*kron(eye(N,N),ones(R,1));
PHI(isinf(PHI)) = NaN;
PHI(isnan(PHI)) = 0;

% Preliminaries

%B permutations:
Bdom_c_ji = repmat(reshape(sum(Bdom_c,2),R,N),N,1) - Bdom_c;
B_c_ji = reshape(permute(reshape(B_c-Bdom_c,R,N,N),[1 3 2]),R*N,N);
B_m_ji = reshape(permute(reshape(B_m-Bdom_m,R,N,R,N),[1 4 3 2]),R*N,R*N);
B_bil_ij = reshape(B_m,R,N,R,N);
Bdom_ii = zeros(R,R,N);
for i = 1:N
    Bdom_ii(:,:,i) = B_bil_ij(:,i,:,i);
end
Bdom_m_ji = repmat(reshape(Bdom_ii,R,R*N),N,1) - Bdom_m;

%lnPXij
ETAPXij = reshape(squeeze(sum(reshape(B_m-Bdom_m,R,N,R,N),3)),R*N,N)...
        + (B_c-Bdom_c);
PHIij = PHI./ETAPXij;
PHIij(isinf(PHIij)) = NaN;
PHIij(isnan(PHIij)) = 0;
PHIKij = kron(PHIij,ones(1,R));
lnXIij = (1-eps)*(diag(PHIKij.*(B_m-Bdom_m)*ones(size(B_m,2),1))...
    - PHIKij.*(B_m-Bdom_m)*(AT_mm-ATdom_mm))*lnP;
lnPIij = (1-rho)*(diag(PHIij.*(B_c-Bdom_c)*ones(size(B_c,2),1))...
    - PHIij.*(B_c-Bdom_c)*(AT_c-ATdom_c))*lnP;
lnPXij = lnXIij + PHIKij.*(B_m-Bdom_m)*lnPM + lnPIij + PHIij.*(B_c-Bdom_c)*lnPC;

%lnPXii
ETAPXii = sum(Bdom_m,2, 'omitnan') + sum(Bdom_c,2, 'omitnan');
PHIii = sum(PHI,2, 'omitnan')./ETAPXii;
PHIii(isinf(PHIii)) = NaN;
PHIii(isnan(PHIii)) = 0;  
lnXIii = (1-eps)*(diag(Bdom_m*ones(size(B_m,2),1))...
    -Bdom_m*ATdom_mm)*lnP;
lnPIii = (1-rho)*(diag(Bdom_c*ones(size(B_c,2),1))...
    -Bdom_c*ATdom_c)*lnP;
lnPXii = PHIii.*(lnXIii + Bdom_m*lnPM + lnPIii + Bdom_c*lnPC);

%lnPXji
ETAPXji = reshape(squeeze(sum(reshape(B_m_ji,R,N,R,N),3)),R*N,N)...
        + (B_c_ji);
PHIji = PHI./ETAPXji;
PHIji(isinf(PHIji)) = NaN;
PHIji(isnan(PHIji)) = 0;
PHIKji = kron(PHIji,ones(1,R));
lnXIji = (1-eps)*(diag(PHIKji.*B_m_ji*ones(size(B_m_ji,2),1))...
    -PHIKji.*B_m_ji*(AT_mm-ATdom_mm))*lnP;
lnPIji = (1-rho)*(diag(PHIji.*B_c_ji*ones(size(B_c_ji,2),1))...
    -PHIji.*B_c_ji*(AT_c-ATdom_c))*lnP;
lnPXji = lnXIji + PHIKji.*B_m_ji*lnPM + lnPIji + PHIji.*B_c_ji*lnPC;

%lnPXjj
ETAPXjj = reshape(squeeze(sum(reshape(Bdom_m_ji,R,N,R,N),3)),R*N,N)...
        + (Bdom_c_ji);
PHIjj = PHI./ETAPXjj;
PHIjj(isinf(PHIjj)) = NaN;
PHIjj(isnan(PHIjj)) = 0;
PHIKjj = kron(PHIjj,ones(1,R));
lnXIjj = (1-eps)*(diag(PHIKjj.*Bdom_m_ji*ones(size(Bdom_m_ji,2),1))...
    -PHIKjj.*Bdom_m_ji*ATdom_mm)*lnP;
lnPIjj = (1-rho)*(diag(PHIjj.*Bdom_c_ji*ones(size(Bdom_c_ji,2),1))...
    -PHIjj.*Bdom_c_ji*ATdom_c)*lnP;
lnPXjj = lnXIjj +PHIKjj.*Bdom_m_ji*lnPM + lnPIjj + PHIjj.*Bdom_c_ji*lnPC;

%%%lnPhi
lnPhi = (1/2)*(lnPXij-lnPXii+lnPXji-lnPXjj);
lnPhi(isinf(lnPhi)) = NaN;

%% Store the results in structure
exposureResponses = struct();
exposureResponses.lnHOT = lnHOT;
exposureResponses.lnX   = lnX;
exposureResponses.lnTVA = lnTVA;
exposureResponses.lnPhi = lnPhi;

end