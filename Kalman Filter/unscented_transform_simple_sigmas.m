function [Zmean, Zcov] = ...
    unscented_transform_simple_sigmas(Xmean, Xcov, h)
    % Calculates the unscented transform with a simple choice of
    % sigma points
    % Xmean - mean vector of the measurements
    % Xcov - covariance matrix of the measurements
    % h - function used to transform the measurements

    Nx = length(Xcov); % Dimension of the measurements
    
    % Calculate sigma points
    A = sqrt(Nx)*chol(Xcov)'; % Matrix root used for sigma points
    Y = repmat(Xmean, [1, Nx]);
    Xsig = [Y + A, Y - A];
    
    % Weights
    w = 1 / (2*Nx)*ones(1, 2*Nx);
    
    % Transform the sigma points and calculate the transformed mean
    Zmean = zeros(Nx, 1);
    Zsig = zeros(Nx, 2*Nx);
    
    for i = 1:(2*Nx)
        Zsig(:, i) = h(Xsig(:, i));
        
        Zmean = Zmean + w(i)*Zsig(:, i);
    end
    
    % Calculate the transformed covariance matrix
    B = Zsig - repmat(Zmean, [1, 2*Nx]);
    Zcov = B*diag(w)*B';
end