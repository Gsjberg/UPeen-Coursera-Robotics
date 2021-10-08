function [ u1, u2 ] = controller(~, state, des_state, params)
%CONTROLLER  Controller for the planar quadrotor
%
%   state: The current state of the robot with the following fields:
%   state.pos = [y; z], state.vel = [y_dot; z_dot], state.rot = [phi],
%   state.omega = [phi_dot]
%
%   des_state: The desired states are:
%   des_state.pos = [y; z], des_state.vel = [y_dot; z_dot], des_state.acc =
%   [y_ddot; z_ddot]
%
%   params: robot parameters

%   Using these current and desired states, you have to compute the desired
%   controls

kv_z = 20;
kp_z = 130;
kv_phi = 50;
kp_phi = 1000;
kv_y = 5;
kp_y = 40;

y = state.pos(1);
z = state.pos(2);
y_dot = state.vel(1);
z_dot = state.vel(2);
phi = state.rot;
phi_dot = state.omega;

y_de = des_state.pos(1);
z_de = des_state.pos(2);
y_de_dot = des_state.vel(1);
z_de_dot = des_state.vel(2);
y_de_ddot = des_state.acc(1);
z_de_ddot = des_state.acc(2);
phi_de_dot = 0;
phi_de_ddot = 0;

m = params.mass;
g = params.gravity;
Ixx = params.Ixx;

u1 = m*(g + z_de_ddot + kv_z*(z_de_dot - z_dot) + kp_z*(z_de - z));
phi_de = (-1/g)*(y_de_ddot + kv_y*(y_de_dot - y_dot) + kp_y*(y_de - y));
u2 = Ixx*(phi_de_ddot + kv_phi*(phi_de_dot - phi_dot) + kp_phi*(phi_de - phi));

% FILL IN YOUR CODE HERE

end

