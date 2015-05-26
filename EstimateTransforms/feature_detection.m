clear all, close all;

I1c = imread(['../ImageData/LeftData/', num2str(0, '%.6d'), '.png']); 
I2c = imread(['../ImageData/RightData/', num2str(0, '%.6d'), '.png']);

width = size(I1c, 2);

%% Find and extract the ELAS (Efficient Large Scale Stereo) features

tic
[f1c, vp1c] = findAndExtractELASFeatures(I1c, 5, 50);
display(['Left image: ELAS features found and extracted in ', ...
            num2str(toc, '%3.2f'), ' s.']);

tic
[f2c, vp2c] = findAndExtractELASFeatures(I2c, 5, 50);
display(['Right image: ELAS features found and extracted in ', ...
            num2str(toc, '%3.2f'), ' s.']); 

%% Feature matching

% Try out my own algorithm for left right matching
tic
ind = matchLeftRight(f1c, f2c, vp1c, vp2c, 30, 50);
display(['Features matched with my own implementation in ', ...
    num2str(toc, '%3.2f'), ' s.']);

% Do a sanity check. For all matched features the u position in the right
% image should be less or equal to the u position in the left image
ind2 = zeros(size(ind), 'uint16');
num = 0;
for k = 1:length(ind)
    if vp1c(ind(k, 1), 1) >= vp2c(ind(k, 2), 1)
        num = num + 1;
        ind2(num, :) = ind(k, :);
    end
end
ind2 = ind2(1:num, :);

%% Plotting
figure(1);
imshowpair(I1c, I2c, 'montage');
hold on;
for k = 1:length(ind2)
    plot([vp1c(ind2(k, 1), 1), width + vp2c(ind2(k, 2), 1)], ...
         [vp1c(ind2(k, 1), 2), vp2c(ind2(k, 2), 2)], '-y');
    plot(vp1c(ind2(k, 1), 1), vp1c(ind2(k, 1), 2), 'or');
    plot(width + vp2c(ind2(k, 2), 1), vp2c(ind2(k, 2), 2), 'xg');
end