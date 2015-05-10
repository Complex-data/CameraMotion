% For test reasons setup the random seed
rng(18)

% The set of data we want to use in our test
x = 0:0.1:199.9;
y = [ones(1, 999), 1:-0.001:0];

z = y + 0.1*randn(1, 2000);

% Inital covariances - should be relatively precise
Xcov = (1e-6)*eye(4);
sn_cov = 0.0001*eye(2);
mn_cov = eye(2);

% Output vectors and starting vector
Xfilt = zeros(4, 2001);
Xfilt(:, 1) = [0;1;0;0];

% Run filter program
for i = 1:2000
    [Xfilt(:, i + 1), Xcov] = unscented_kalman_filter([x(i);z(i)], ...
        Xfilt(:, i), Xcov, sn_cov, mn_cov, ...
        @simple_vehicle_system_v3, @simple_measurement_v3);
end

figure;
plot(x, z, '+', 'Color', 0.9*[1 1 1])
hold on;
plot(x, y)
plot(Xfilt(1, :), Xfilt(2, :), 'b')