function [F, M] = controller(t, state, des_state, params)
%CONTROLLER  Controller for the quadrotor
%
%   state: The current state of the robot with the following fields:
%   state.pos = [x; y; z], state.vel = [x_dot; y_dot; z_dot],
%   state.rot = [phi; theta; psi], state.omega = [p; q; r]
%
%   des_state: The desired states are:
%   des_state.pos = [x; y; z], des_state.vel = [x_dot; y_dot; z_dot],
%   des_state.acc = [x_ddot; y_ddot; z_ddot], des_state.yaw,
%   des_state.yawdot
%
%   params: robot parameters

%   Using these current and desired states, you have to compute the desired
%   controls


% =================== Your code goes here ===================

% Thrust
kp = [100; 100; 800];
kv = [1; 1; 1];
m = params.mass;
g = params.gravity;
I = params.I;
acc_c = des_state.acc + kv.*(des_state.vel - state.vel) + kp.*(des_state.pos - state.pos);
F = m*(g + acc_c(3));

if F<params.minF
    F=params.minF;
end
if F>params.maxF
    F=params.maxF;
end

% Moment
kv_angle = [1; 1; 1];
kp_angle = [160; 160; 160];
phi_de = (1/g)*(acc_c(1)*sin(des_state.yaw) - acc_c(2)*cos(des_state.yaw));
theta_de = (1/g)*(acc_c(1)*cos(des_state.yaw) + acc_c(2)*sin(des_state.yaw));
angle_de = [phi_de; theta_de; des_state.yaw];
omega_de = [0; 0; des_state.yawdot];
M = kp_angle.*(angle_de - state.rot) + kv_angle.*(omega_de - state.omega);

% =================== Your code ends here ===================

end
