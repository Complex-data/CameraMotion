clc; clear all; close all;

%% Parameter setup

% Camera parameters
param.f     = 645.2;
param.cu    = 635.9;
param.cv    = 194.1;
param.base  = 0.571;

% The total rotation of the vehicle
rot = zeros(1034, 1);

% The position of the vehicle which will be newly calculated
x = 0;
y = 0;

% The position of the vehicle in the last time step
x_prev = 0;
y_prev = 0;

% Parameters for the UKF
% Inital covariances - should be relatively precise
Xcov = (1e-6)*eye(6);
sn_cov = 0.0001*eye(2);
mn_cov = eye(2);

% Output vectors and starting vector
Xfilt = zeros(6, 1034);
Xfilt(:, 1) = [0;0;0;0;0;0];

%% Read match data
load circular_matches.mat

%% Estimate Motion
for i = 1:1033
    I1p = imread(['../ImageData/LeftData/', num2str(i - 1, '%.6d'), '.png']);   
    I1c = imread(['../ImageData/LeftData/', num2str(i, '%.6d'), '.png']);
    
    % Extract the current matches
    m1p = circular_matches.m1p{i};
    m1c = circular_matches.m1c{i};

    % Extract coordinates
    uv1p = m1p.Location;
    uv1c = m1c.Location;
    
    % Calculate transition vectors
    du = uv1p(:, 1) - uv1c(:, 1);
    dv = uv1p(:, 2) - uv1c(:, 2);

    % Get change in rotation
    drot = mean(du);

    % Get rid of the rotation
    du = du - drot;

    % Get the velocity
    velo = mean(sqrt(du.^2 + dv.^2));
    
    % Our features are not uniformly distributed over the whole image
    % If we have large rotations this is no problem, most features will
    % point in the same direction. But if we only have small rotations
    % these might be biased to the side of the image on which we have more
    % features. To compensate for this these features get randomly added or
    % substracted, no matter what their original sign was.
    if abs(drot) > 15
        rot(i + 1) = rot(i) + drot;
    else
        bias = randi(2);
        if bias == 2
            bias = -1;
        end
        rot(i + 1) = rot(i) + bias*drot;
    end
    
    % Get the angle of the rotation
    theta = -rot(i + 1) * pi / 2500;
    % Time step
    h = 0.01;
    
    % New position - simple solution
    x = x + velo * h * cos(theta);
    y = y + velo * h * sin(theta);
    
    % Apply the UKF to incorporate our new measurement    
    [Xfilt(:, i + 1), Xcov] = unscented_kalman_filter([theta;velo], ...
    Xfilt(:, i), Xcov, sn_cov, mn_cov, ...
    @systemFunc, @measFunc);
    
    % Plot the position of the vehicle
    figure(1);
    subplot(4, 1, 1);
    hold on
    plot([x_prev, x], [y_prev, y], '-r')
    plot(x, y, 'ro')
    plot([Xfilt(1, i), Xfilt(1, i + 1)], [Xfilt(2, i), Xfilt(2, i + 1)], '-b')
    plot(Xfilt(1, i + 1), Xfilt(2, i + 1), 'sb')
    
    subplot(4, 1, 2);
    hold on
    plot(i, rot(i + 1), 'xg');
    
    subplot(4, 1, 3);
    hold on
    plot(i, velo, 'xb');
    
    % Plot the image with the matched features
    subplot(4, 1, 4);
    hold off
    showMatchedFeatures(I1p, I1c, m1p, m1c);
    
    % Save the current position so we can extend the plot next time
    x_prev = x;
    y_prev = y;
end