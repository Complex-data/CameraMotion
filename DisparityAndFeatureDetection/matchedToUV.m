function [u, v, r] = matchedToUV(mp1, mp2, tol)


u = mp2.Location(:, 1)-mp1.Location(:, 1);
v = mp2.Location(:, 2)-mp1.Location(:, 2);


r = sqrt(u.^2+v.^2);
mr = mean(r);

outliers = r > mr+tol;

u(outliers) = [];
v(outliers) = [];
r(outliers) = [];