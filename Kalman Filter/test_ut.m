% Setup data
r = 1 + sqrt(0.02)*randn(1, 10000);
phi = pi / 2 + sqrt(pi / 6)*randn(1, 10000);

% Get the mean and set the covariance matrix
Xmean = mean([r;phi], 2);
% Xcov = [0.02, 0;0, pi / 6];
Xcov = cov([r;phi]');

% Unscented transform with simple sigma points
[Zmean, Zcov] = ...
    unscented_transform_simple_sigmas(Xmean, Xcov, @polar_to_cart);

[ut_eig_vec, ut_eig] = eig(Zcov);

% Unscented transform with better sigma points
[Zmean2, Zcov2] = ...
    unscented_transform_better_sigmas(Xmean, Xcov, @polar_to_cart);

[ut2_eig_vec, ut2_eig] = eig(Zcov2);

% Direct comparison
cart = polar_to_cart([r; phi]);
x = cart(1, :);
y = cart(2, :);

[trans_eig_vec, trans_eig] = eig(cov([x;y]'));
trans_mean = mean([x;y], 2);

figure;
% plot(x, y, '+')
hold on;
axis equal;
% Draw means and variance ellipses
ang = 0:0.01:2*pi;
% Unit circle which we are going to transform
xp = cos(ang);
yp = sin(ang);

% Transform the direct comparison
trans_ell = trans_eig_vec*sqrt(trans_eig)*[xp;yp] ...
    + repmat(trans_mean, [1, length(ang)]);
plot(trans_mean(1), trans_mean(2), 'xr')
plot(trans_ell(1, :), trans_ell(2, :), '-r')

% Transform the UT (simple) results
ut_ell = ut_eig_vec*sqrt(ut_eig)*[xp;yp] ...
    + repmat(Zmean, [1, length(ang)]);
plot(Zmean(1), Zmean(2), 'og')
plot(ut_ell(1, :), ut_ell(2, :), '--g')

% Transform the UT (better) results
ut2_ell = ut2_eig_vec*sqrt(ut2_eig)*[xp;yp] ...
    + repmat(Zmean2, [1, length(ang)]);
plot(Zmean2(1), Zmean2(2), 'dk')
plot(ut2_ell(1, :), ut2_ell(2, :), ':k')
