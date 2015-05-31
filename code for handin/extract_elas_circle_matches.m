clc, clear all; close all;
% This function extracts all the features from our image sequence utilizing
% the ELAS inspired feature detection algorithm.

% Create cell containers to save the output data
circle_matches_elas.uv1p = cell(1033, 1);
circle_matches_elas.uv1c = cell(1033, 1);
circle_matches_elas.uv2p = cell(1033, 1);
circle_matches_elas.uv2c = cell(1033, 1);

for i = 1:1033
    I1p = imread(['..\ImageData\LeftData\', num2str(i - 1, '%.6d'), '.png']);
    I2p = imread(['..\ImageData\RightData\', num2str(i - 1, '%.6d'), '.png']);

    I1c = imread(['..\ImageData\LeftData\', num2str(i, '%.6d'), '.png']);
    I2c = imread(['..\ImageData\RightData\', num2str(i, '%.6d'), '.png']);

    %% Feature Matching - Setup
    % I am trying to use "circular" feature matching as described in one of
    % Geigers papers "StereoScan: Dense 3d Reconstruction in Real-time"

    %% Circle matching
    % Find and extract the features in all four images
    n = 7;
    thr = 50;

    [f1p, vp1p] = findAndExtractELASFeatures(I1p, n, thr);
    [f2p, vp2p] = findAndExtractELASFeatures(I2p, n, thr);
    [f1c, vp1c] = findAndExtractELASFeatures(I1c, n, thr);
    [f2c, vp2c] = findAndExtractELASFeatures(I2c, n, thr);

    % Do circular feature matching
    maxMatchDist = 100;      % Maximum match distance
    maxSADDiff = 500;        % Maximum difference in SAD
    uniq = true;             % Unique matches

    ind1cp = findMatches(f1c, f1p, vp1c, vp1p, ...
                            maxMatchDist, maxSADDiff, uniq);

    ind12p = findMatchesLeftRight(f1p(ind1cp(:, 2), :), f2p, ...
                            vp1p(ind1cp(:, 2), :), vp2p, ...
                            maxMatchDist, maxSADDiff, uniq);

    ind2pc = findMatches(f2p(ind12p(:, 2), :), f2c, ...
                            vp2p(ind12p(:, 2), :), vp2c, ...
                            maxMatchDist, maxSADDiff, uniq);

    ind21c = findMatchesLeftRight(f2c(ind2pc(:, 2), :), f1c, ...
                            vp2c(ind2pc(:, 2), :), vp1c, ...
                            maxMatchDist, maxSADDiff, uniq);

    % Check if we found any circular matches at all
    if isempty(ind21c)
        error('No circle features found!');
    end

    % Check for which features the circle matching actually succeeded
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

    % Extract the locations of the circle matched features
    circle_matches_elas.uv1c{i} = vp1c(indCircFeat(1:nCircFeat, 1), 1:2);
    circle_matches_elas.uv1p{i} = vp1p(indCircFeat(1:nCircFeat, 2), 1:2);
    circle_matches_elas.uv2p{i} = vp2p(indCircFeat(1:nCircFeat, 3), 1:2);
    circle_matches_elas.uv2c{i} = vp2c(indCircFeat(1:nCircFeat, 4), 1:2);
    display(['Images ', num2str(i - 1), ' and ', num2str(i), ' processed.']);
end

% Save the extracted data
save('circle_matches_elas.mat', 'circle_matches_elas')