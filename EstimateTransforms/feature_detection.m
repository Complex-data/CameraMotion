clc, clear all, close all;

I = imread(['../ImageData/LeftData/', num2str(0, '%.6d'), '.png']);  
width = size(I, 2);
height = size(I, 1);

% Filter for corner detection
blob_detector = (-1)*ones(5, 'int8');
blob_detector(2:4, 2:4) = 1;
blob_detector(3, 3) = 8;

% Filter for corner detection
corner_detector = [1, 1, 0, -1, -1];

% Sobel 5x5
sobel1 = [1, 2, 0, 2, 1];
sobel2 = [1, 4, 6, 4, 1];

% Filter the images
I_du = int16(conv2(sobel1, sobel2, I, 'same')); 
I_dv = int16(conv2(sobel2, sobel1, I, 'same'));

I_blob = int16(filter2(blob_detector, I));
I_corner = int16(filter2(corner_detector, I));

[ext, num] = nonMaximumSuppression(I_blob, I_corner, 2, 200);

features = zeros(num, 32, 'uint8');
for i = 1:num
    u = ext(i, 1);
    v = ext(i, 2);
    
    % Extract feature vectors
    features(i, :) = [I_du(v - 1, u - 3), I_dv(v - 1, u - 3), ...
                      I_du(v - 1, u - 1), I_dv(v - 1, u - 1), ...
                      I_du(v - 1, u + 1), I_dv(v - 1, u + 1), ...
                      I_du(v - 1, u + 3), I_dv(v - 1, u + 3), ...
                      I_du(v + 1, u - 3), I_dv(v + 1, u - 3), ...
                      I_du(v + 1, u - 1), I_dv(v + 1, u - 1), ...
                      I_du(v + 1, u + 1), I_dv(v + 1, u + 1), ...
                      I_du(v + 1, u + 3), I_dv(v + 1, u + 3), ...
                      I_du(v - 3, u - 5), I_dv(v - 3, u - 5), ...
                      I_du(v - 3, u + 5), I_dv(v - 3, u + 5), ...
                      I_du(v + 3, u - 5), I_dv(v + 3, u - 5), ...
                      I_du(v + 3, u + 5), I_dv(v + 3, u + 5), ...
                      I_du(v - 5, u - 1), I_dv(v - 5, u - 1), ...
                      I_du(v - 5, u + 1), I_dv(v - 5, u + 1), ...
                      I_du(v + 5, u - 1), I_dv(v + 5, u - 1), ...
                      I_du(v + 5, u + 1), I_dv(v + 5, u + 1)];
end

%%
figure(1);
imshow(I);
hold on;
plot(ext(:, 1), ext(:, 2), 'or');
plot(20, 20, '+y')