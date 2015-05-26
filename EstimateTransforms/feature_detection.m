clear all, close all;

I1c = imread(['../ImageData/LeftData/', num2str(0, '%.6d'), '.png']); 
I2c = imread(['../ImageData/RightData/', num2str(0, '%.6d'), '.png']);

width = size(I1c, 2);

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
ind = matchLeftRight(f1c, f2c, vp1c, vp2c, 40, 100000);
display(['Features matched with my own implementation in ', ...
    num2str(toc, '%3.2f'), ' s.']);

%%
figure(1);
% subplot(2, 1, 1);
imshowpair(I1c, I2c, 'montage');
hold on;
% plot(vp1c(:, 1), vp1c(:, 2), 'or')
% plot(vp2c(:, 1), vp2c(:, 2), '+g')
for k = 1:200:length(ind)
    plot([vp1c(ind(k, 1), 1), width + vp2c(ind(k, 2), 1)], ...
         [vp1c(ind(k, 1), 2), vp2c(ind(k, 2), 2)], '-y');
    plot(vp1c(ind(k, 1), 1), vp1c(ind(k, 1), 2), 'or');
    plot(width + vp2c(ind(k, 2), 1), vp2c(ind(k, 2), 2), 'xg');
end

% subplot(2, 1, 2);
% imshow(I2c);
% hold on;
% 
% for k = 1:length(ind)
%     plot(vp2c(ind(k, 2), 1), vp2c(ind(k, 2), 2), 'xg');
% end