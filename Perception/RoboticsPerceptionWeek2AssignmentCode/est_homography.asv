function [ H ] = est_homography(video_pts, logo_pts)
% est_homography estimates the homography to transform each of the
% video_pts into the logo_pts
% Inputs:
%     video_pts: a 4x2 matrix of corner points in the video
%     logo_pts: a 4x2 matrix of logo points that correspond to video_pts
% Outputs:
%     H: a 3x3 homography matrix such that logo_pts ~ H*video_pts
% Written for the University of Pennsylvania's Robotics:Perception course

% YOUR CODE HERE
H = [];
A = [];
for i = 1:4
    xi_1 = video_pts(:,1);
    xi_2 = video_pts(:,2);
    xj_1 = logo_pts(:,1);
    xj_2 = logo_pts(:,2);
    ax = [-xi_1(i) -xi_2(i) -1 0 0 0 xi_1(i)*xj_1(i) xi_2(i)*xj_1(i) xj_1(i)];
    ay = [0 0 0 -xi_1(i) -xi_2(i) -1 xi_1(i)*xj_2(i) xi_2(i)*xj_2(i) xj_2(i)];
    A = cat(1,A,ax,ay);
end

[~,~,V] = svd(A);
h = V(:,9);
h = reshape(h,3,3);
H = h';
