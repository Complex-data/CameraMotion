clc, clear



I1 = imread('image_00/data/0000000032.png');
I2 = imread('image_00/data/0000000033.png');

minQ = 0.0001;                        %   MinQuality, default 0.01
filtS = 3;                            %   FilterSize, default 5
roi = [1 1 size(I1,2) size(I1,1)];    %   ROI, default [1 1 size(I1,2) size(I1,1)]
% roi = [1 1 100 100];  %   ROI, default [1 1 size(I1,2) size(I1,1)]


points1 = detectHarrisFeatures(I1, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);
                                
points2 = detectHarrisFeatures(I2, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);

[features1, valid_points1] = extractFeatures(I1, points1);
[features2, valid_points2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(features1, features2);

matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);

figure; showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);

%%

x1 = matchedPoints1.Location(:, 1);
y1 = matchedPoints1.Location(:, 2);

x2 = matchedPoints2.Location(:, 1);
y2 = matchedPoints2.Location(:, 2);

clf
hold on
% scatter(x1, y1, 'b')
% scatter(x2, y2, 'r')

u = x2-x1;
v = y2-y1;

quiver(x1, y1, -u, -v)

estimateYaw(matchedPoints1, matchedPoints2)

