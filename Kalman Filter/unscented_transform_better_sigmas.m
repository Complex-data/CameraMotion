function [Zmean, Zcov] = ...
    unscented_transform_better_sigmas(Xmean, Xcov, h)
    % Calculates the unscented transform with a simple choice of
    % sigma points
    % Xmean - mean vector of the measurements
    % Xcov - covariance matrix of the measurements
    % h - function used to transform the measurements
    
    w0 = 1/5.3;

    Nx = length(Xcov); % Dimension of the measurements
    
    % Calculate sigma points
    A = sqrt(Nx/(1 - w0))*chol(Xcov)'; % Matrix root used for sigma points
    Y = repmat(Xmean, [1, Nx]);
    Xsig = [Xmean, Y + A, Y - A];
    
    % Weights
    w = [w0, (1 - w0) / (2*Nx)*ones(1, 2*Nx)];
    
    % Transform the sigma points and calculate the transformed mean
    Zmean = zeros(Nx, 1);
    Zsig = zeros(Nx, 2*Nx + 1);
    
    for i = 1:(2*Nx + 1)
        Zsig(:, i) = h(Xsig(:, i));
        
        Zmean = Zmean + w(i)*Zsig(:, i);
    end
    
    % Calculate the transformed covariance matrix
    B = Zsig - repmat(Zmean, [1, 2*Nx + 1]);
    Zcov = B*diag(w)*B';
end