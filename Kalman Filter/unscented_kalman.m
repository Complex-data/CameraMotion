function Xfilt = unscented_kalman(z, x, f, h, P, Pv, Pn)
    % A function for calculating the unscented Kalman filter
    %
    % z - measurements
    % x - initial state
    % f - system function
    % h - measurement function
    % P - initial system covariance
    % Pv - initial covariance for system noise
    % Pn - initial covariance for measurement noise
    
    % Parameters used in the algorithm - I do not understand
    % which influence they have exactly but it might be interesting
    % to play with these
    alpha = 1e-3;
    kappa = 0;
    beta = 2;
    
    [p, N] = size(z); % N = number of measurements, p = number of "sensors"
    ns = length(P); % ns = system size
    nv = length(Pv); % nv = system noise size
    nn = length(Pn); % nn = measurement noise size
    
    L = ns + nv + nn; % n = augmented system size
    lambda = alpha^2 * (L + kappa) - L; % lambda = composite parameter 
                                        % in the algorithm
                                        
    % A coefficient we need for calculating sigmas
	coeff = sqrt(L + lambda);
    
    % Create the weight vectors
    Wm = [lambda / (L + lambda), (0.5 / (L + lambda))*ones(1, 2*L)];
    Wc = Wm;
    Wc(1) = Wc(1) + (1 - alpha^2 + beta);
    
	% Kalman filtered state
	Xfilt = zeros(ns, N + 1);

	% Initialize
	Xfilt(:, 1) = x;
    % P is already set to the initial covariance
    
    % Build the augmented system vector...
	Xaug = [Xfilt(:, 1); zeros(nv + nn, 1)];
    % ...and the augmented covariance matrix
	Paug = [P zeros(ns, nv + nn); 
            zeros(nv, ns), Pv, zeros(nv, nn);
            zeros(nn, ns + nv), Pn];

    for i = 1:N
        % Get the right sigmas
        Chi = sigmas(Xaug, Paug, coeff);
        
        ChiTransState = zeros(ns, 2*L + 1);
        ChiTransMeas = zeros(p, 2*L + 1);
        
        % Time update
        for k = 1:(2*L + 1)
            % Cut out the interesting sections of the sigma
            % vectors
            ChiX = Chi(1:ns, k);
            ChiV = Chi((ns + 1):(ns + nv), k);
            ChiN = Chi((ns + nv + 1):L, k);
            
            % Unscented transform for the state mean
            ChiTransState(:, k) = f(ChiX, ChiV);
            
            % Unscented transform for the measurement mean
            ChiTransMeas(:, k) = h(ChiX, ChiN);
        end
        
        Xbar = ChiTransState*Wm';
        Ybar = ChiTransMeas*Wm';
        
        Ax = ChiTransState - repmat(Xbar, [1, 2*L + 1]);
        Pbar = Ax*diag(Wc)*Ax';
        
        Ay = ChiTransMeas - repmat(Ybar, [1, 2*L + 1]);
        Py = Ay*diag(Wc)*Ay';
        
        Pmix = Ax*diag(Wc)*Ay';
        
        K = Pmix / Py;
        Xfilt(:, i + 1) = Xbar + K*(z(:, i) - Ybar);
        P = Pbar - K*Py*K';
        
        % Reset
        
        % Build the augmented system vector...
        Xaug = [Xfilt(:, i + 1); zeros(nv + nn, 1)];
        % ...and the augmented covariance matrix
        Paug = [P zeros(ns, nv + nn); 
            zeros(nv, ns), Pv, zeros(nv, nn);
            zeros(nn, ns + nv), Pn];
    end
end

function Chi = sigmas(Xaug, Paug, coeff)
    % This function calculates the matrix of sigma vectors
    % needed for the unscented transform
    A = coeff*chol(Paug)';
    Y = repmat(Xaug, [1, numel(Xaug)]);
    Chi = [Xaug, Y + A, Y - A];
end