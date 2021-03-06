clc, clear

index = 1;

IL = imread(['../ImageData/LeftData/', indexToImageName(index)]);
IR = imread(['../ImageData/RightData/', indexToImageName(index)]);

frameLeftGray = IL;
frameRightGray = IR;

method = 'SemiGlobal';  % 'SemiGlobal' (default) | 'BlockMatching'
dispRange = [0, 128];       % [0, 64] (default) | two element vector
blockSize = 5;            % 15 (default) | odd integer
contrastThresh = 0.5;      % 0.5 (default) | scalar
uniqueThresh = 11;         % 15 (default) | non-negative integer
distThresh = [];           % [] (disabled)(default) | non-negative integer
textThresh = 0.0002;       % 0.0002 (default) | scalar value

disparityMap = disparity(frameLeftGray, frameRightGray, ...
                         'Method', method, ...
                         'DisparityRange', dispRange, ...
                         'BlockSize', blockSize, ...
                         'ContrastThreshold', contrastThresh, ...
                         'UniquenessThreshold', uniqueThresh, ...
                         'DistanceThreshold', distThresh, ...
                         'TextureThreshold', textThresh);




disparityMap(:, 1:128) = [];

figure(1);
clf
imshow(disparityMap, [0, 64]);
title('Disparity Map');
colormap jet
colorbar

dispMap = disparityMap;

dispMap(dispMap < 0) = 0;


figure(4)
se = strel('disk', 10);
closed = imclose(dispMap, se);

h = fspecial('disk', 5);

closedF = conv2(closed, h, 'same');

imshow(closedF, [0, 64]);
colormap jet

