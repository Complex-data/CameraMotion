clc, clear

I1 = imread('../ImageData/LeftData/data/0000000000.png');
I2 = imread('../ImageData/LeftData/data/0000000001.png');

[im_cols, im_rows] = size(I1);

mQ = 0.001;
filt = 3;

width = im_rows;
height = floor(0.5*im_cols);

[x, y, u, v, mp1, mp2] = returnHarrisVectors(I1, I2, mQ, filt, ...
    [1, im_cols - height, im_rows, height]);

figure;
hold on;

% The whole image is flipped. Need to flip the y-axis
x1 = mp1.Location(:, 1);
y1 = im_cols - mp1.Location(:, 2);

x2 = mp2.Location(:, 1);
y2 = im_cols - mp2.Location(:, 2);

conn = [x2, y2] - [x1, y1];

[r, c] = size(conn);

% Calculate in which quadrant the connection vectors are
quad = zeros(r, 1);
angles = atan2(conn(:, 2), conn(:, 1));

% Octants
quad(-pi / 12 <= angles & angles <= pi / 12) = 1;
quad(pi / 12 < angles & angles < 5/12 * pi) = 2;
quad(5/12 * pi <= angles & angles <= 7/12 *pi) = 3;
quad(7/12 * pi < angles & angles < 11/12 * pi) = 4;
quad((11/12*pi <= angles & angles <= pi) | ...
    (-pi <= angles & angles <= -11/12 * pi)) = 5;
quad(-11/12 * pi < angles & angles < -7/12 * pi) = 6;
quad( -7/12 * pi <= angles & angles <= -5/12 * pi) = 7;
quad( -5/12 * pi < angles & angles < -pi / 12) = 8;

% % Quadrants
% quad(0 < angles & angles < pi/2) = 1;
% quad(pi / 2 < angles & angles < pi) = 2;
% quad(-pi < angles & angles < -pi / 2) = 3;
% quad(-pi / 2 < angles & angles < 0) = 4;

for i = 1:mp1.Count
    col = 'b';
%     if quad(i) == 1
%         col = 'r';
%     elseif quad(i) == 2
%         col = 'g';
%     elseif quad(i) == 3
%         col = 'k';
%     elseif quad(i) == 4
%         col = 'y';
%     end
    
    if quad(i) == 1
        col = '-r';
    elseif quad(i) == 2
        col = '-.r';
    elseif quad(i) == 3
        col = '-g';
    elseif quad(i) == 4
        col = '-.g';
    elseif quad(i) == 5
        col = '-k';
    elseif quad(i) == 6
        col = '-.k';
    elseif quad(i) == 7
        col = '-b';
    elseif quad(i) == 8
        col = '-.y';
    end
    
    plot([x1(i), x2(i)], [y1(i), y2(i)], col);
end

% Calculate bounding boxes
% We need boxes round around each group of quadrant vectors
pos = [x1, y1; x2, y2];
for i = 1:8
    vecs = pos([quad == i, quad == i], :);
    xl = min(vecs(:, 1));
    xr = max(vecs(:, 1));
    yb = min(vecs(:, 2));
    yt = max(vecs(:, 2));
    
    col = '';
%     if i == 1
%         col = 'r';
%     elseif i == 2
%         col = 'g';
%     elseif i == 3
%         col = 'k';
%     elseif i == 4
%         col = 'y';
%     end
    
    if i == 1
        col = '-r';
    elseif i == 2
        col = '-.r';
    elseif i == 3
        col = '-g';
    elseif i == 4
        col = '-.g';
    elseif i == 5
        col = '-k';
    elseif i == 6
        col = '-.k';
    elseif i == 7
        col = '-b';
    elseif i == 8
        col = '-.y';
    end
    
    plot([xl, xr, xr, xl, xl], [yt, yt, yb, yb, yt], col);
end