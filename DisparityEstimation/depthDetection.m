clc, clear

index = 1;

IL = imread(['../ImageData/LeftData/data/', indexToImageName(index)]);
IR = imread(['../ImageData/RightData/data/', indexToImageName(index)]);

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


figure(1);
clf
imshow(disparityMap, [0, 64]);
title('Disparity Map');
colormap jet
colorbar

h = fspecial('sobel');

% 'average'
% 'disk'
% 'gaussian'
% 'laplacian'
% 'log'
% 'motion'
% 'prewitt'
% 'sobel'

% disparityMap2 = conv2(disparityMap, h);

% figure(2);
% clf
% imshow(disparityMap2, [0, 64]);
% title('Disparity Map');
% colormap jet
% colorbar
