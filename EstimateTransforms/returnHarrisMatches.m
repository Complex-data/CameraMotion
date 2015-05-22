% Return the matched corner points using the Harris algorithm
function [m1, m2] = returnHarrisMatches(I1, I2, minQ, filtS, roi)
    p1 = detectHarrisFeatures(I1, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);

    p2 = detectHarrisFeatures(I2, 'MinQuality', minQ, ...
                                    'FilterSize', filtS, ...
                                    'ROI', roi);

    [f1, vp1] = extractFeatures(I1, p1);
    [f2, vp2] = extractFeatures(I2, p2);

    ind = matchFeatures(f1, f2);

    m1 = vp1(ind(:, 1), :);
    m2 = vp2(ind(:, 2), :);
end