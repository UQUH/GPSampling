function Phi = rff_ard_se_features(X, sigma_f, n_features, Omega, b)
 % Input
    % X: (n x d) matrix (n datapoints, d dimensions)
    % ell: (d x 1) length scales
    % sigma_f>0: output scale
    % n_features: number of random Fourier features
    % Omega (n_features x d): random spectral points 
    % b (n_features x 1): random phase shift points 
 
 % Output
    % Phi (n x n_features): Random Fourier feature values for evaluated at X
 
 Z = X * Omega'; % (n x n_features)
 Phi = sqrt(2 * sigma_f^2 / n_features) * cos(Z + b'); % (n x n_features)
end