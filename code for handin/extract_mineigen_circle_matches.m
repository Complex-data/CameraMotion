clc; clear; close all;
% Dedicated function for feature extraction. These will be saved in a cell
% array and finally put down on the hard drive.

%% Data setup

% General parameters for feature detection
% Find features in the left picture
minQ = 0.0001;      % MinQuality, def 0.01
filtS = 3;          % FilterSize, def 5

% Preallocate cell arrays to store the output of this script
% These will hold the preallocated matches.
circle_matches_mineigen.uv1c = cell(1033, 1);
circle_matches_mineigen.uv1p = cell(1033, 1);
circle_matches_mineigen.uv2p = cell(1033, 1);
circle_matches_mineigen.uv2c = cell(1033, 1);

for i = 1:1033
    I1p = imread(['..\ImageData\LeftData\', num2str(i - 1, '%.6d'), '.png']);
    I2p = imread(['..\ImageData\RightData\', num2str(i - 1, '%.6d'), '.png']);

    I1c = imread(['..\ImageData\LeftData\', num2str(i, '%.6d'), '.png']);
    I2c = imread(['..\ImageData\RightData\', num2str(i, '%.6d'), '.png']);

    %% Feature Matching - Setup
    % I am trying to use "circular" feature matching as described in one of
    % Geigers papers "StereoScan: Dense 3d Reconstruction in Real-time"

    % Find features in all four images
    p1p = detectMinEigenFeatures(I1p, 'MinQuality', minQ, ...
                                      'FilterSize', filtS);

    p2p = detectMinEigenFeatures(I2p, 'MinQuality', minQ, ...
                                      'FilterSize', filtS);

    p1c = detectMinEigenFeatures(I1c, 'MinQuality', minQ, ...
                                      'FilterSize', filtS);

    p2c = detectMinEigenFeatures(I2c, 'MinQuality', minQ, ...
                                      'FilterSize', filtS);

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

    % Check if we come out at the same features as the ones we start at
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

    % Now extract all the positions of the features we found in each of
    % four images    
    circle_matches_mineigen.uv1c{i} = ...
        vp1c(indCircFeat(1:nCircFeat, 1), 1:2);
    circle_matches_mineigen.uv1p{i} = ...
        vp1p(indCircFeat(1:nCircFeat, 2), 1:2);
    circle_matches_mineigen.uv2p{i} = ...
        vp2p(indCircFeat(1:nCircFeat, 3), 1:2);
    circle_matches_mineigen.uv2c{i} = ...
        vp2c(indCircFeat(1:nCircFeat, 4), 1:2);
end

% Save the extracted data
save('circle_matches_mineigen.mat', 'circle_matches_mineigen')