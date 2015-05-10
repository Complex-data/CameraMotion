clc, clear

I1 = imread('../ImageData/LeftData/data/0000000000.png');
I2 = imread('../ImageData/LeftData/data/0000000001.png');

mQ = 0.0001;
filt = 3;
ROI = [1 1 size(I1,2) size(I1,1)];

[x, y, u, v, mp1, mp2] = returnHarrisVectors(I1, I2, mQ, filt, ROI);

quiver(x,y, -u, -v);

figure; showMatchedFeatures(I1, I2, mp1, mp2);