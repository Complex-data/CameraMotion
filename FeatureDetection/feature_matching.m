clc, clear



I1 = imread('0000000010.png');
I2 = imread('0000000011.png');

minQ = 0.0001;                        %   MinQuality, default 0.01
filtS = 3;                          %   FilterSize, default 5
roi = [1 1 size(I1,2) size(I1,1)];  %   ROI, default [1 1 size(I1,2) size(I1,1)]


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