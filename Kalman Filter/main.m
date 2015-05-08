clc, clear variables, clf

T = 0.01;   % Sampling time

x = 0:0.01:9.99;
y = [ones(1,499) 1:-0.002:0];

Y = [x;y];
Z = Y + 0.1*randn(size(Y));

% A = [1, T, 0, 0;
%      0, 1, 0, 0;
%      0, 0, 1, T;
%      0, 0, 0, 1];
% 
% C = [1, 0, 0, 0;
%      0, 0, 1, 0];
% 
% Q = [0, 0, 0, 0;
%      0, 0.0001, 0, 0;
%      0, 0, 0, 0;
%      0, 0, 0, 0.0001];

% R = cov(v(1,:), v(2,:));
% R = eye(2);
% 
% x0 = [0; 0; 0; 0];

% P0 = 100*eye(4);
% 
% [Xfilt,P] = kalmfilt(Z,A,C,Q,R, x0, P0);

Xfilt = unscented_kalman(Z, zeros(4, 1), @f, @h, ...
    100*eye(4), 0.0001*eye(2), eye(2));

% --------- Plotting ----------

Zfilt = zeros(2, 1001);
for k = 1:1001
    Zfilt(:, k) = h(Xfilt(:, k), zeros(2, 1));
end

figure(1)
clf
hold on
plot(Y(1,:), Y(2,:))
plot(Z(1,:), Z(2,:), 'rx');
figure(2)
clf
hold on
plot(Y(1,:), Y(2,:))
plot(Zfilt(1,:), Zfilt(2,:), 'r');

