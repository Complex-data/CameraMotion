clc, clear

index = 1;

I1 = imread(['../ImageData/LeftData/', indexToImageName(index)]);
I2 = imread(['../ImageData/LeftData/', indexToImageName(index+1)]);

bsz = 51;

hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port', 'MaximumDisplacement', [200 200], 'BlockSize', [bsz, bsz]);
hbm.OutputValue = 'Horizontal and vertical components in complex form';

motion = step(hbm, I1, I2);

[X, Y] = meshgrid(1:bsz:size(I1, 2), 1:bsz:size(I1, 1));
imshow(I1);
hold on;
quiver(X(:), Y(:), real(motion(:)), imag(motion(:)), 0);

%%
mQ = 0.0001;
filt = 3;
ROI = [1 1 round(size(I1,2)) size(I1,1)];

[x, y, u, v, mp1, mp2] = returnHarrisVectors(I1, I2, mQ, filt, ROI);

% u2 = (u-1241/2)*10;
% v2 = (v-376/2)*10;

hold on
% quiver(x,y, -u*10, -v*10);
% quiver(x,y, -u2, -v2);

figure; showMatchedFeatures(I1, I2, mp1, mp2);