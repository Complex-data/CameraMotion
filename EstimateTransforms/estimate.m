clc; clear all; close all;

%% Data setup

% Blocks
M = 1;
N = 1;

% Camera parameters
param.f     = 645.2;
param.cu    = 635.9;
param.cv    = 194.1;
param.base  = 0.571;

I1p = imread(['..\ImageData\LeftData\', num2str(0, '%.6d'), '.png']);
I2p = imread(['..\ImageData\RightData\', num2str(0, '%.6d'), '.png']);
    
I1c = imread(['..\ImageData\LeftData\', num2str(1, '%.6d'), '.png']);
I2c = imread(['..\ImageData\RightData\', num2str(1, '%.6d'), '.png']);

%% Feature Matching - Setup
% I am trying to use "circular" feature matching as described in one of
% Geigers papers "StereoScan: Dense 3d Reconstruction in Real-time"

% General parameters for feature detection
% Find features in the left picture
minQ = 0.0001;      % MinQuality, def 0.01
filtS = 3;        % FilterSize, def 5

col_step = floor(size(I1p, 2) / M);
row_step = floor(size(I1p, 1) / N);

% These variables will store the coordinates of the features I find
% Left image previous
uv1p = [];
% Right image previous
uv2p = [];
% Left image current
uv1c = [];
% Right image current
uv2c = [];

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
        
        nfeat = f1c.NumFeatures;
        ncircfeat = 0;
        circfeat_ind = zeros(nfeat, 4);
        for k = 1:nfeat
            ind = matchFeatures(binaryFeatures(f1c.Features(k, :)), f1p, ...
                                'Method', 'Exhaustive', ... def 'Exhaustive'
                                'MatchThreshold', 10.0, ... def 10.0 binFeat, 1.0 nonbinFeat
                                'MaxRatio', 0.6, ... def 0.6
                                'Unique', true);% def false
                            
            if ~isempty(ind)
                % We found the feature also in the previous left picture
                % Now look in the previous right image
                ind2 = matchFeatures(binaryFeatures(f1p.Features(ind(2), :)), f2p, ...                       
                                'Method', 'Exhaustive', ... def 'Exhaustive'
                                'MatchThreshold', 10.0, ... def 10.0 binFeat, 1.0 nonbinFeat
                                'MaxRatio', 0.6, ... def 0.6
                                'Unique', true);% def false
                            
                if ~isempty(ind2)
                    % Whoohooo, it's even in the previous right image
                    % Check the current right image
                    ind3 = matchFeatures(binaryFeatures(f2p.Features(ind2(2), :)), f2c, ...                       
                                'Method', 'Exhaustive', ... def 'Exhaustive'
                                'MatchThreshold', 10.0, ... def 10.0 binFeat, 1.0 nonbinFeat
                                'MaxRatio', 0.6, ... def 0.6
                                'Unique', true);% def false
                            
                    if ~isempty(ind3)
                        % Perfect we also found the feature in the current
                        % right picture. Now see if we can find it again in
                        % the current left picture and hope that it is the
                        % same as before
                        ind4 = matchFeatures(binaryFeatures(f2c.Features(ind3(2), :)), f1c, ...                       
                                'Method', 'Exhaustive', ... def 'Exhaustive'
                                'MatchThreshold', 10.0, ... def 10.0 binFeat, 1.0 nonbinFeat
                                'MaxRatio', 0.6, ... def 0.6
                                'Unique', true);% def false
                            
                        if ~isempty(ind4) && ind4(2) == k
                            % Fuck yeah :) we found a circular feature!
                            ncircfeat = ncircfeat + 1;
                            circfeat_ind(ncircfeat, :) = ...
                                [k, ind(2), ind2(2), ind3(2)];
                        end
                    end
                end
            end            
        end
        
        uv1c = [ uv1c; vp1c.Location(circfeat_ind(1:ncircfeat, 1), :) ];
        uv1p = [ uv1p; vp1p.Location(circfeat_ind(1:ncircfeat, 2), :) ];
        uv2p = [ uv2p; vp2p.Location(circfeat_ind(1:ncircfeat, 3), :) ];
        uv2c = [ uv2c; vp2c.Location(circfeat_ind(1:ncircfeat, 4), :) ];
    end
end

%% Plot
nmatched = length(uv1p);

figure;
imshowpair(I1p, I1c, 'falsecolor');
hold on;
plot(uv1p(:, 1), uv1p(:, 2), 'og')
plot(uv1c(:, 1), uv1c(:, 2), '+r')
for k = 1:nmatched
    plot([uv1p(k, 1), uv1c(k, 1)], [uv1p(k, 2), uv1c(k, 2)], 'y')
end

figure;
imshowpair(I2p, I2c, 'falsecolor');
hold on;
plot(uv2p(:, 1), uv2p(:, 2), 'og')
plot(uv2c(:, 1), uv2c(:, 2), '+r')
for k = 1:nmatched
    plot([uv2p(k, 1), uv2c(k, 1)], [uv2p(k, 2), uv2c(k, 2)], 'y')
end

%% Process the matched features
% Convert the matched points to a 3D point cloud
X = zeros(nmatched - 1, 1);
Y = zeros(nmatched - 1, 1);
Z = zeros(nmatched - 1, 1);

for k = 1:(nmatched - 1)
    d = max(uv1p(k, 1) - uv2p(k, 1), 0.0001);
    X(k) = (uv1p(k, 1) - param.cu)*param.base / d;
    Y(k) = (uv1p(k, 2) - param.cv)*param.base / d;
    Z(k) = param.f*param.base / d;
end

%% Show the point cloud
figure;
scatter3(X, Y, Z)
    