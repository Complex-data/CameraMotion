function [m1, m2] = returnMinEigenMatches(I1, I2, minQ, filtS, roi)
    p1 = detectMinEigenFeatures(I1, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);

    p2 = detectMinEigenFeatures(I2, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);

    [f1, vp1] = extractFeatures(I1, p1);
    [f2, vp2] = extractFeatures(I2, p2);

    ind = matchFeatures(f1, f2);

    m1 = vp1(ind(:, 1), :);
    m2 = vp2(ind(:, 2), :);
end