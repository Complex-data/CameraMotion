clc, clear all, close all

figure(1);
hold on;
grid on;

title('Comparison of results of different algorithms to GPS', ...
    'Interpreter', 'latex')
xlabel('x', 'Interpreter', 'latex')
ylabel('y', 'Interpreter', 'latex')

%% GPS reference Data
sensorData = load('..\SensorData\00.txt');

x = sensorData(1:1035, 4);
y = sensorData(1:1035, 12);

plot(x, y);

%% Min Eigen Circle
load min_eigen_circle

% The reference implementation saves the path turned by -90 degrees
% compared to our own implementation
rot_matrix = [0 -1; 1 0];

temp = rot_matrix*[Xfilt(1, :); Xfilt(2, :)];
x = temp(1, :);
y = temp(2, :);
plot(x, y);

%% ELAS Circle
load elas_circle

temp = rot_matrix*[Xfilt(1, :); Xfilt(2, :)];
x = temp(1, :);
y = temp(2, :);
plot(x, y);

%% Reference
load reference_motion.mat

x = x;
y = y;

plot(x, y);

legend('GPS', 'Min Eigen (UKF)', 'ELAS inspired (UKF)', 'Reference (libviso)', ...
    'Location', 'SouthWest')