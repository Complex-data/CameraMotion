clc; clear all; close all;

%% Parameter setup

% The total rotation of the vehicle
% rot = -10*2500/180;
% rot = -5*2500/180;
rot = 0;

% Parameters for the UKF
% Inital covariances - should be relatively precise
Xcov = (1e-6)*eye(6);
sn_cov = 0.01*eye(2);
mn_cov = [5, 0; 0, 10];

% Output vector for the Kalman Filter and starting vector
Xfilt = zeros(6, 1034);
Xfilt(:, 1) = [0; 0; 0; 8; 0; 0];

%% Read match data
load circle_matches_mineigen.mat
% load circle_matches_elas.mat

%% Estimate Motion
for i = 1:1033    
    % Extract coordinates
    uv1p = circle_matches_mineigen.uv1p{i};
    uv1c = circle_matches_mineigen.uv1c{i};
    
    % % Extract coordinates
    % uv1p = circle_matches_elas.uv1p{i};
    % uv1c = circle_matches_elas.uv1c{i};
    
    % Calculate transition vectors
    du = uv1p(:, 1) - uv1c(:, 1);
    dv = uv1p(:, 2) - uv1c(:, 2);

    % Get change in rotation
    drot = mean(du);

    % Get rid of the rotation
    du = du - drot;

    % Get the velocity
    velo = mean(sqrt(du.^2 + dv.^2));
    % % ELAS overestimates the speed. Use this line instead
    % velo = mean(sqrt(du.^2 + dv.^2))*0.6;
    
    % Our features are not uniformly distributed over the whole image
    % If we have large rotations this is no problem, most features will
    % point in the same direction. But if we only have small rotations
    % these might be biased to the side of the image on which we have more
    % features. To compensate for this these features get randomly added or
    % substracted, no matter what their original sign was.
    if abs(drot) > 15
        rot = rot + drot;
    else
        bias = randi(2);
        if bias == 2
            bias = -1;
        end
        rot = rot + bias*drot;
    end
    
    % Get the angle of the rotation
    theta = -rot * pi / 3000;

    % Apply the UKF to incorporate our new measurement    
    [Xfilt(:, i + 1), Xcov] = unscented_kalman_filter([theta;velo], ...
    Xfilt(:, i), Xcov, sn_cov, mn_cov, ...
    @systemFunc, @measFunc);
end

% Save the extracted movement
% save('elas_circle.mat', 'Xfilt')
save('min_eigen_circle.mat', 'Xfilt')