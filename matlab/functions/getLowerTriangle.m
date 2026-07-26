function vec = getLowerTriangle(N,x,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getLowerTriangle.m performs outer product of vector x or the outer product
% of x and z (Optional), then extracts the lower-triangular blocks and 
% turn them into a vector.
% Inputs:
%       x     Double      vector (NRx1) 
%       z     Double      vector (NRx1) [OPTIONAL]
% Output:
%       vec   Double      vector (NRx(NR-R)/2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[NR, ~] = size(x);
R = NR/N;

if nargin == 2
    z = x;
end

ivec = (1:N-1)';
blocksize = [0;(R*N-R*ivec)*R];
csblocks = cumsum(blocksize);

vec = zeros((R*N)*(R*N-R)/2,1);
xoutprod = transpose(x(:,1)*transpose(z(:,1)));
for i = 1:N-1
    block = xoutprod((R*i)+1:end,(R*(i-1))+1:R*i);
    vec(csblocks(i)+1:csblocks(i+1),1) = reshape(block,[],1);
end

end