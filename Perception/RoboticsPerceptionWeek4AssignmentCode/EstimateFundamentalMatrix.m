function F = EstimateFundamentalMatrix(x1, x2)
%% EstimateFundamentalMatrix
% Estimate the fundamental matrix from two image point correspondences 
% Inputs:
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Output:
%    F - size (3 x 3) fundamental matrix with rank 2

N = size(x1,1);
A = zeros(N, 9);
for i = 1:N
    A(i,:) = [x1(i,1)*x2(i,1), x1(i,1)*x2(i,2), x1(i,1), x1(i,2)*x2(i,1), x1(i,2)*x2(i,2), x1(i,2), x2(i,1), x2(i,2), 1];
end
[~, ~, v] = svd(A);
F = v(:,end);
F = reshape(F, 3, 3);
[u2, d2, v2] = svd(F);
d2(end, end) = 0;
F = u2*d2*v2';
F = F/norm(F);
end


