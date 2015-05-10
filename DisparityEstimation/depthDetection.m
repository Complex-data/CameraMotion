clc, clear

index = 1;

IL = imread(['../ImageData/LeftData/data/', indexToImageName(index)]);
IR = imread(['../ImageData/RightData/data/', indexToImageName(index)]);

frameLeftGray = IL;
frameRightGray = IR;

disparityMap = disparity(frameLeftGray, frameRightGray);

figure(2);
clf
imshow(disparityMap, [0, 64]);
title('Disparity Map');
colormap jet
colorbar
