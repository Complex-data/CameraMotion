function [Xfilt, Xcov] = unscented_kalman_filter(Xmeas, X0, Xcov, sn_cov, ...
    mn_cov, system_func, meas_func)
    % This function is supposed to calculate the filtered mean values
    % using the algorithm for the unscented Kalman filter.
    %
    % Xmean - the mean of a new measurement
    % X0 - starting vector
    % Xcov - assumed starting covariance matrix of the measurements
    % sn_cov - assumed covariance matrix of the system noise
    % mn_cov - assumed covariance matrix of the measurement noise
    % system_func - the function describing the system transformation
    % meas_func - the function describing the relationship between the
    % system and the 
    %
    % Xfilt - the filtered mean
    w0 = 1/5.3; % Scaling parameter for first sigma vector
    
    Nx = length(Xcov); % size of the system
    Nd = length(sn_cov); % size of the system noise
    Nv = length(mn_cov); % size of the measurement noise
    
    p = length(Xmeas); % number of sensors
    
    N = Nx + Nd + Nv; % total system size
    
    Xaug = [X0; zeros(Nd + Nv, 1)]; % augmented system state vector
    Paug = [Xcov, zeros(Nx, Nd + Nv);
            zeros(Nd, Nx), sn_cov, zeros(Nd, Nv);
            zeros(Nv, Nx + Nd), mn_cov]; % augmented covariance matrix
        
    % Calculate sigma points
    A = sqrt(N/(1 - w0))*chol(Paug)'; % Matrix root used for sigma points
    Y = repmat(Xaug, [1, N]);
    Xsig = [Xaug, Y + A, Y - A];
    
    % Weights
    w = [w0, (1 - w0) / (2*N)*ones(1, 2*N)];
    
    % Transform the sigma points and calculate the predicted mean
    Xpred_mean = zeros(Nx, 1);
    Xpred = zeros(Nx, 2*N + 1);
    
    for i = 1:(2*N + 1)
        Xpred(:, i) = system_func(Xsig(1:Nx, i), ...
            Xsig((Nx + 1):(Nx + Nd), i));
        
        Xpred_mean = Xpred_mean + w(i)*Xpred(:, i);
    end
    
    % Calculate the predicted covariance matrix
    B = Xpred - repmat(Xpred_mean, [1, 2*N + 1]);
    Kpred = B*diag(w)*B';
    
    % Recalculate the sigma points
    Xaug = [Xpred_mean; zeros(Nd + Nv, 1)]; % augmented system state vector
    Paug = [Kpred, zeros(Nx, Nd + Nv);
            zeros(Nd, Nx), sn_cov, zeros(Nd, Nv);
            zeros(Nv, Nx + Nd), mn_cov]; % augmented covariance matrix
        
    % Calculate sigma points
    A = sqrt(N/(1 - w0))*chol(Paug)'; % Matrix root used for sigma points
    Y = repmat(Xaug, [1, N]);
    Xsig = [Xaug, Y + A, Y - A];
    
    % Calculate the measurement predictions and the predicted measurement
    Ypred_mean = zeros(p, 1);
    Ypred = zeros(p, 2*N + 1);
    
    for i = 1:(2*N + 1)
        Ypred(:, i) = meas_func(Xsig(1:Nx, i), Xsig((Nx + Nd + 1):end, i));
        
        Ypred_mean = Ypred_mean + w(i)*Ypred(:, i);
    end
    
    % Innovation covariance
    C = Ypred - repmat(Ypred_mean, [1, 2*N + 1]);
    S = C*diag(w)*C';
    
    % Cross covariance
    Kxy = B*diag(w)*C';
    
    % Execute the Kalman filter steps
    W = Kxy / S;
    Xfilt = Xpred_mean + W*(Xmeas - Ypred_mean);
    Xcov = Kpred - W*S*W';
end