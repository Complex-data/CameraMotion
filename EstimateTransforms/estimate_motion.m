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
    theta = - rot(i + 1) * pi / 2500;
    % Time step
    h = 0.01;
    
    % New position
    x = x + velo * h * cos(theta);
    y = y + velo * h * sin(theta);
    
    % Plot the position of the vehicle
    figure(1);
    subplot(3, 1, 1);
    hold on
    plot([x_prev, x], [y_prev, y], '-r')
    plot(x, y, 'ro')
    
    subplot(3, 1, 2);
    hold on
    plot(i, rot(i + 1), 'xr');
    
    % Plot the image with the matched features
    subplot(3, 1, 3);
    hold off
    showMatchedFeatures(I1p, I1c, m1p, m1c);
    
    % Save the current position so we can extend the plot next time
    x_prev = x;
    y_prev = y;
    
    % Pause for a short moment
%     pause(0.01)
end