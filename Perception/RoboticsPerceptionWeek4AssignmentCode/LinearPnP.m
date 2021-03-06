function [C, R] = LinearPnP(X, x, K)
%% LinearPnP
% Getting pose from 2D-3D correspondences
% Inputs:
%     X - size (N x 3) matrix of 3D points
%     x - size (N x 2) matrix of 2D points whose rows correspond with X
%     K - size (3 x 3) camera calibration (intrinsics) matrix
% Outputs:
%     C - size (3 x 1) pose transation
%     R - size (3 x 1) pose rotation
%
% IMPORTANT NOTE: While theoretically you can use the x directly when solving
% for the P = [R t] matrix then use the K matrix to correct the error, this is
% more numeically unstable, and thus it is better to calibrate the x values
% before the computation of P then extract R and t directly



%{
N = size(x,1);
A = zeros(2*N, 12);
row = 1;
for i=1:N
    x_i = [x(i,:) 1];
    skew = Vec2Skew(x_i); 
    X_tilt = [X(i,:) 1];
    DiagX = [X_tilt zeros(1,4) zeros(1,4); zeros(1,4) X_tilt zeros(1,4); zeros(1,4) zeros(1,4) X_tilt];
    A_i = skew * DiagX;
    %1 4 7 10 : 1 2 3 4
    A(row:row+2, 1:end) = A_i;
    row = row+3;
end
[~,~,v] = svd(A);
P = v(:,end);
P = reshape(P, [4,3])';
R = K^(-1)*P(:, 1:3);
[u1,d1,v1] = svd(R);
if det(u1*v1') > 0
    R = u1*v1';
    t = K'*P(:,end)/d1(1,1);
elseif det(u1*v1') < 0
    R = -u1*v1';
    t = -K'*P(:,end)/d1(1,1);
end
C = -R'*t;
end
%}

N = size(X,1);
X = [X,ones(N,1)];
x = [x,ones(N,1)];
x_calibrated = K\x';
x = x_calibrated';
A = zeros(2*N,12);


for i = 1:N
    A(i*2-1,1:4) = -X(i,:);
    A(i*2-1,9:12) = x(i,1)*X(i,:);
    A(i*2,5:8) = -X(i,:);
    A(i*2,9:12) = x(i,2)*X(i,:);
end

[~,~,V] = svd(A);

P = reshape(V(:,12),4,3)';
Rw = P(:,1:3);
t = P(:,4);

[U,D,V] = svd(Rw);

if det(U*V') >0
    R = U*V';
    t = t/D(1);
elseif det(U*V') <0
    R = -U*V';
    t = -t/D(1);
end

C = -(R')*t;

end








