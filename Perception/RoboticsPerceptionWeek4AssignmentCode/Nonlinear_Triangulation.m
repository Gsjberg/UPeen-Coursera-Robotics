function X = Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)
%% Nonlinear_Triangulation
% Refining the poses of the cameras to get a better estimate of the points
% 3D position
% Inputs: 
%     K - size (3 x 3) camera calibration (intrinsics) matrix
%     x
% Outputs: 
%     X - size (N x 3) matrix of refined point 3D locations 

%{
    N = size(x1, 1);
    X = zeros(N, 3);
    for i = 1:N
        X_single = X0(i,:);
        for j = 1:5
            x1_single = x1(i,:);
            x2_single = x2(i,:);
            x3_single = x3(i,:);
            X_single = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1_single, x2_single, x3_single, X_single);
        end
        X(i,:) = X_single;
    end
end

function X = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)
    %measured image points
    b = [x1(1) x1(2) x2(1) x2(2) x3(1) x3(2)]';
        uvw1 = K*R1*(X0' - C1);
        uvw2 = K*R2*(X0' - C2);
        uvw3 = K*R3*(X0' - C3);
        u1 = uvw1(1); v1 = uvw1(2); w1 = uvw1(3);
        u2 = uvw2(1); v2 = uvw2(2); w2 = uvw2(3);
        u3 = uvw3(1); v3 = uvw3(2); w3 = uvw3(3);
        f_X = [u1/w1 v1/w1 u2/w2 v2/w2 u3/w3 v3/w3]';
        J1 = Jacobian_Triangulation(C1, R1, K, X0);
        J2 = Jacobian_Triangulation(C2, R2, K, X0);
        J3 = Jacobian_Triangulation(C3, R3, K, X0);
        J = [J1 J2 J3]';
        X_delta = (J'*J)^(-1)*J'*(b - f_X);
        X = X0 + X_delta';
end

function J = Jacobian_Triangulation(C, R, K, X)
    uvw = K*R*(X - C);
    u = uvw(1);
    v = uvw(2);
    w = uvw(3);
    
    %intrinsic parameters
    f = K(1,1);
    px = K(1,3);
    py = K(2,3);
    
    %Jacobian Parameters
    part_u = [f*R(1,1) + px*R(3,1) f*R(1,2) + px*R(3,2) f*R(1,3) + px*R(3,3)];
    part_v = [f*R(2,1) + py*R(3,1) f*R(2,2) + py*R(3,2) f*R(2,3) + py*R(3,3)];
    part_w = [R(3,1) R(3,2) R(3,3)];
    part_f = [(w*part_u - u*part_w)/w^2 ; (w*part_v - v*part_w)/w^2];
    J = part_f';
end
%}

N = size(X0,1);
X = zeros(size(X0));
aaa = size(X);
for i = 1 : N
    
    X_temp = X0(i,:);
    %aaa = size(X_temp)
    for j = 1 : 5
        X_temp = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1(i,:), x2(i,:), x3(i,:), X_temp);
    end
    aaa = size(X_temp);
    X(i,:) = X_temp;
    
    %aaa = size(X_temp);
end

end

function X = Single_Point_Nonlinear_Triangulation(K, C1, R1, C2, R2, C3, R3, x1, x2, x3, X0)

% reprojection
x1p = K * R1*( X0' - C1);
x1p = (x1p ./ repmat(x1p(3, :), [3, 1]))';
x2p = K * R2 * (X0' - repmat(C2, [1 size(X0,1)]));
x2p = (x2p ./ repmat(x2p(3, :), [3, 1]))';
x3p = K * R3 * (X0' - repmat(C3, [1 size(X0,1)]));
x3p = (x3p ./ repmat(x3p(3, :), [3, 1]))';

% delta x computation
b = [ x1(1), x1(2), x2(1), x2(2), x3(1), x3(2) ]'; 
f_x = [ x1p(1), x1p(2), x2p(1), x2p(2), x3p(1), x3p(2) ]';

J =[ Jacobian_Triangulation(C1, R1, K, X0)',...
     Jacobian_Triangulation(C2, R2, K, X0)',...
     Jacobian_Triangulation(C3, R3, K, X0)' ]';

error = (x1(1)-x1p(1))^2 + (x1(2)-x1p(1))^2 + ...
        (x2(1)-x2p(1))^2 + (x2(2)-x2p(1))^2 + ...
        (x3(1)-x3p(1))^2 + (x3(2)-x3p(1))^2;
fprintf("Error: %f\n",error);

delta_X = (J'*J)\(J'*(b-f_x));

% X update
X = X0 + delta_X';

aaa = size(X0);
aaa = size(delta_X);
aaa = size(X);
end


function J = Jacobian_Triangulation(C, R, K, X)

%pixel coordinate component
x = K * R *( X' - C);
u = x(1);
v = x(2);
w = x(3);

% intrinsic matrix component extraction
f = K(1,1);
px = K(1,3);
py = K(2,3);

% Jacobain computation
du = [ f*R(1,1)+px*R(3,1), f*R(1,2)+px*R(3,2), f*R(1,3)+px*R(3,3)];
dv = [ f*R(2,1)+py*R(3,1), f*R(2,2)+py*R(3,2), f*R(2,3)+py*R(3,3)];
dw = [ R(3,1), R(3,2), R(3,3)];


J = [(w*du-u*dw)/(w^2);(w*dv-v*dw)/(w^2)];
   
end
