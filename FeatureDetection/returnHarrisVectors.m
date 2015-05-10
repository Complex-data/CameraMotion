function [x, y, u, v, mp1, mp2] = returnHarrisVectors(im1, im2, mQ, filt, ROI)


% minQ = 0.0001;
% filtS = 3;
% roi = [1 1 size(I1,2) size(I1,1)];

minQ = mQ;     %   MinQuality, default 0.01
filtS = filt;  %   FilterSize, default 5
roi = ROI;     %   ROI, default [1 1 size(I1,2) size(I1,1)]


points1 = detectHarrisFeatures(im1, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);
                                
points2 = detectHarrisFeatures(im2, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);



[features1, valid_points1] = extractFeatures(im1, points1);
[features2, valid_points2] = extractFeatures(im2, points2);

indexPairs = matchFeatures(features1, features2);

mp1 = valid_points1(indexPairs(:, 1), :);
mp2 = valid_points2(indexPairs(:, 2), :);

x1 = mp1.Location(:, 1);
y1 = mp1.Location(:, 2);

x2 = mp2.Location(:, 1);
y2 = mp2.Location(:, 2);

u = x2-x1;
v = y2-y1;

x = x1;
y = y1;

end