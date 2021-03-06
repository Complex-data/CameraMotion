function [X, Y, Z] = getXYZ(dispMap, x, y, u, v)

% d = match(i).uLeftCurrent - matcFeatures(i).uRightCurrent, (disparity)

f = 0.0025;  % Camera focal length in meters
b = 0.54;    % Distance between cameras in meters

s = length(x);

Y = zeros(s, 1);
Z = zeros(s, 1);
X = zeros(s, 1);
dispMap = dispMap/50;

for k = 1:s
    
    u1p = u(k); % u1p, u-coordinate left image previous
    v1p = v(k); % v1p, v-coordinate left image previous
    d = dispMap(round(y(k)), round(x(k)));
    if d < 1.5
        d = 1.5;
    end
    
    X(k) = (u1p - 1240/2)*f/d;
    Y(k) = (v1p - 370/2)*f/d;
    Z(k) = f*b/d;

end
% double d = max(p_matched[i].u1p - p_matched[i].u2p,0.0001f);
% X[i] = (p_matched[i].u1p - param.calib.cu)*param.base/d;
% Y[i] = (p_matched[i].v1p - param.calib.cv)*param.base/d;
% Z[i] = param.calib.f*param.base/d;

% u1p,v1p; // u,v-coordinates in previous left  image
% i1p;     // feature index (for tracking)
% u2p,v2p; // u,v-coordinates in previous right image
% i2p;     // feature index (for tracking)
% u1c,v1c; // u,v-coordinates in current  left  image
% i1c;     // feature index (for tracking)
% u2c,v2c; // u,v-coordinates in current  right image
% i2c;     // feature index (for tracking)