clc, clear

I1 = imread('../ImageData/LeftData/data/0000000000.png');
I2 = imread('../ImageData/LeftData/data/0000000001.png');

mQ = 0.01;
filt = 3;
ROI = [1 1 size(I1,2) size(I1,1)];

[x, y, u, v, mp1, mp2] = returnHarrisVectors(I1, I2, mQ, filt, ROI);

figure;
% imshow(I1);
hold on;
% plot(mp1.Location(:, 1), mp1.Location(:, 2), 'or');
% plot(mp2.Location(:, 1), mp2.Location(:, 2), '+g');

% The whole image is flipped. Need to flip the y-axis
x1 = mp1.Location(:, 1);
y1 = size(I1, 1) - mp1.Location(:, 2);

x2 = mp2.Location(:, 1);
y2 = size(I1, 1) - mp2.Location(:, 2);

conn = [x2, y2] - [x1, y1];

[r, c] = size(conn);

% Calculate in which quadrant the connection vectors are
quad = zeros(r, 1);
angles = atan2(conn(:, 2), conn(:, 1));
quad(0 < angles & angles < pi/2) = 1;
quad(pi / 2 < angles & angles < pi) = 2;
quad(-pi < angles & angles < -pi / 2) = 3;
quad(-pi / 2 < angles & angles < 0) = 4;

for i = 1:mp1.Count
    col = 'b';
    if quad(i) == 1
        col = 'r';
    elseif quad(i) == 2
        col = 'g';
    elseif quad(i) == 3
        col = 'k';
    elseif quad(i) == 4
        col = 'y';
    end
    plot([x1(i), x2(i)], [y1(i), y2(i)], col);
end


% % Normalize arrows
% uv_norm = sqrt(u.^2 + v.^2);
% u = u ./ uv_norm;
% v = v ./ uv_norm;
% quiver(x, y, -u, v);

% figure; showMatchedFeatures(I1, I2, mp1, mp2);