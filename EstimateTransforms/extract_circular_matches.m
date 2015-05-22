clc; clear; close all;
% Dedicated function for feature extraction. These will be saved in a cell
% array and finally put down on the hard drive.

%% Data setup

% Blocks
M = 1;
N = 1;

% General parameters for feature detection
% Find features in the left picture
minQ = 0.0001;      % MinQuality, def 0.01
filtS = 3;        % FilterSize, def 5

% Preallocate cell arrays to store the output of this script
% These will hold the preallocated matches.
circular_matches.m1c = cell(1034, 1);
circular_matches.m1p = cell(1034, 1);
circular_matches.m2p = cell(1034, 1);
circular_matches.m2c = cell(1034, 1);

tic 
for i = 1:1033
    I1p = imread(['..\ImageData\LeftData\', num2str(i - 1, '%.6d'), '.png']);
    I2p = imread(['..\ImageData\RightData\', num2str(i - 1, '%.6d'), '.png']);

    I1c = imread(['..\ImageData\LeftData\', num2str(i, '%.6d'), '.png']);
    I2c = imread(['..\ImageData\RightData\', num2str(i, '%.6d'), '.png']);

    %% Feature Matching - Setup
    % I am trying to use "circular" feature matching as described in one of
    % Geigers papers "StereoScan: Dense 3d Reconstruction in Real-time"

    col_step = floor(size(I1p, 2) / M);
    row_step = floor(size(I1p, 1) / N);

    % These variables will store the corner points of the matched features
    % Left image current
    m1c = cornerPoints(zeros(0, 2));

    % Left image previous
    m1p = cornerPoints(zeros(0, 2));

    % Right image previous
    m2p = cornerPoints(zeros(0, 2));

    % Right image current
    m2c = cornerPoints(zeros(0, 2));

    %% Gritty fucking details...
    % Since we know that the camera does not move too sudden it is enough to
    % check the image block wise. This should make the matching more accurate
    % and hopefully even faster.
    for m = 1:M
        for n = 1:N
            % Blockwise means that the region of interest changes each turn
            roi = [1 + (m - 1)*col_step, ...    x
                1 + (n - 1)*row_step, ...       y
                col_step, ...                   width
                row_step];                    % height

            % Find features in all four images
            p1p = detectMinEigenFeatures(I1p, 'MinQuality', minQ, ...
                                              'FilterSize', filtS, ...
                                              'ROI', roi);
            p2p = detectMinEigenFeatures(I2p, 'MinQuality', minQ, ...
                                              'FilterSize', filtS, ...
                                              'ROI', roi);
            p1c = detectMinEigenFeatures(I1c, 'MinQuality', minQ, ...
                                              'FilterSize', filtS, ...
                                              'ROI', roi);
            p2c = detectMinEigenFeatures(I2c, 'MinQuality', minQ, ...
                                              'FilterSize', filtS, ...
                                              'ROI', roi);

            % Extract them
            [f1p, vp1p] = extractFeatures(I1p, p1p);
            [f2p, vp2p] = extractFeatures(I2p, p2p);
            [f1c, vp1c] = extractFeatures(I1c, p1c);
            [f2c, vp2c] = extractFeatures(I2c, p2c);

            thr = 50; % def 10

            % Do circular feature matching
            ind1cp = matchFeatures(f1c, f1p, 'MatchThreshold', thr, 'Unique', true);
            ind12p = ...
                matchFeatures(binaryFeatures(f1p.Features(ind1cp(:, 2), :)), ...
                                    f2p, 'MatchThreshold', thr, 'Unique', true);
            ind2pc = ...
                matchFeatures(binaryFeatures(f2p.Features(ind12p(:, 2), :)), ...
                                    f2c, 'MatchThreshold', thr, 'Unique', true);
            ind21c = ...
                matchFeatures(binaryFeatures(f2c.Features(ind2pc(:, 2), :)), ...
                                    f1c, 'MatchThreshold', thr, 'Unique', true);

            % Check if we found any circular matches at all
            if isempty(ind21c)
                continue;
            end

            indCircFeat = zeros(length(ind21c), 4);
            nCircFeat = 0;

            for k = 1:length(ind21c)
                indEnd = ind21c(k, 2);
                indStart = ind1cp(ind12p(ind2pc(ind21c(k, 1), 1), 1), 1);

                if indEnd == indStart
                    ind1c = indStart;
                    ind1p = ind1cp(ind12p(ind2pc(ind21c(k, 1), 1), 1), 2);
                    ind2p = ind12p(ind2pc(ind21c(k, 1), 1), 2);
                    ind2c = ind2pc(ind21c(k, 1), 2);

                    nCircFeat = nCircFeat + 1;
                    indCircFeat(nCircFeat, :) = [ind1c, ind1p, ind2p, ind2c];
                end                
            end

            m1c = [ m1c; vp1c(indCircFeat(1:nCircFeat, 1)) ];
            m1p = [ m1p; vp1p(indCircFeat(1:nCircFeat, 2)) ];
            m2p = [ m2p; vp2p(indCircFeat(1:nCircFeat, 3)) ];
            m2c = [ m2c; vp2c(indCircFeat(1:nCircFeat, 4)) ];
        end
    end
    
    circular_matches.m1c{i} = m1c;
    circular_matches.m1p{i} = m1p;
    circular_matches.m2p{i} = m2p;
    circular_matches.m2c{i} = m2c;
end
toc

save circular_matches