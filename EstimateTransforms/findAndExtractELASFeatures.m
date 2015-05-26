function [features, ext] = findAndExtractELASFeatures(I, n, thr)
    % Filter for corner detection
    blob_detector = (-1)*ones(5, 'int8');
    blob_detector(2:4, 2:4) = 1;
    blob_detector(3, 3) = 8;

    % Filter for corner detection
    corner_detector = int8([1, 1, 0, -1, -1]);

    % Sobel 5x5
    sobel1 = [1, 2, 0, 2, 1];
    sobel2 = [1, 4, 6, 4, 1];

    % Filter the images
    I_du = conv2(sobel1, sobel2, I, 'same'); 
    I_dv = conv2(sobel2, sobel1, I, 'same');

    % Quantize sobel filters down to uint8
    sobel_max = max(max(max(I_du)), max(max(I_dv)));
    I_du = uint8(I_du * (255 / sobel_max));
    I_dv = uint8(I_dv * (255 / sobel_max));
%     I_du = uint8(I_du * (255 / max(max(I_du))));
%     I_dv = uint8(I_dv * (255 / max(max(I_dv))));

    I_blob = int16(filter2(blob_detector, I));
    I_corner = int16(filter2(corner_detector, I));
    
    ext = nonMaximumSuppression(I_blob, I_corner, n, thr);

    features = zeros(size(ext, 1), 32, 'int16');
    for i = 1:size(ext, 1)
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
end