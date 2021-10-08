function [ u ] = controller(~, s, s_des, params)
%PD_CONTROLLER  PD controller for the height
%
%   s: 2x1 vector containing the current state [z; v_z]
%   s_des: 2x1 vector containing desired state [z; v_z]
%   params: robot parameters


%{
K_p = 130;
K_v = 20;
error = s_des(1)-s(1);
error_dot = s_des(2)-s(2);
z_doubledot = 0;
u = params.mass*(z_doubledot + K_p*error + K_v*error_dot + params.gravity);
%}
% FILL IN YOUR CODE HERE

u = params.mass*params.gravity;
end

