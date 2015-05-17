clc, clear

f = 0.0025;  % Camera focal length in meters
b = 0.54;    % Distance between cameras in meters

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


%% Feature detection


I1 = imread(['../ImageData/LeftData/', indexToImageName(index)]);
I2 = imread(['../ImageData/LeftData/', indexToImageName(index+1)]);


mQ = 0.0001;
filt = 3;
ROI = [1 200 750 176];
% ROI = [1 1 size(I1,2) size(I1,1)];
% ROI = [1 round(size(I1,2)/2) size(I1,2) size(I1,1)];
tic
[x, y, u, v, mp1, mp2] = returnHarrisVectors(I1, I2, mQ, filt, ROI);
toc
% quiver(x,y, -u, -v);

figure(1);
showMatchedFeatures(I1, I2, mp1, mp2);

%%  Scale matched vectors with disparity

for k = 1:length(u)
    
   u2(k) = u(k)*dispMap(round(y(k)), round(x(k))); 
   v2(k) = v(k)*dispMap(round(y(k)), round(x(k))); 
end

clf
hold on
quiver(x,y, -u2', -v2');
quiver(x,y, -u, -v);

m2 = mp2;

% x1 = mp1.Location(:, 1);
% y1 = mp1.Location(:, 2);
% 
% x2 = mp2.Location(:, 1);
% y2 = mp2.Location(:, 2);
%%

m2.Location(:,1) = m2.Location(:,1); %x+u2';
m2.Location(:,2) = m2.Location(:,1); %y+v2';

showMatchedFeatures(I1, I2, mp1, m2);


