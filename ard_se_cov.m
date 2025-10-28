function K = ard_se_cov(X1, X2, ell, sigma_f)
% Input
    % X1: (n x d) matrix (n points, d dimensions)
    % X2: (m x d) matrix (m points, d dimensions)
    % ell: (d x 1) vector of length scales
    % sigma_f > 0: output scale

% Output
    % K (n x m): ARD SE covariance maxtrix 
    
% Ensure ell is a column vector
    ell = ell(:);
% Normalize input by lengthscales
    X1_scaled = X1 ./ ell';
    X2_scaled = X2 ./ ell';
% Compute squared Euclidean distance matrix
    d2 = pdist2(X1_scaled, X2_scaled, 'euclidean').^2;
 % Compute covariance matrix
    K = sigma_f^2 * exp(-0.5 * d2);
end