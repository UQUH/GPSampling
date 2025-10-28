function [W_sample] = rff_ard_se_posWeights_standard(X, Y, sigma_f, sigma_n, Omega,b)
% Input
    % X (n x d): matrix of input variables
    % Y (n x 1): vector of output variable
    % sigma_f>0: output scale
    % sigma_n>0: noise standard deviation
    % Omega (n_features x d): sample random spectral points
    % b (n_features x 1): random phase shift points
    
% Output
    % W_sample (n_features x 1): posterior weight samples for Bayesian linear model

n = size(X,1);
n_features = size(Omega,1);

noise = randn(n_features, 1);
Z = X * Omega'; % (n x n_features)
% Phi matrix
Phi = sqrt(2 * sigma_f^2 / n_features) * cos(Z + b'); % (n x n_features)
% We use SMW formula and an eigendecomposition technique to accelerate weight sampling
if (n < n_features)
    Woodbury = Phi * Phi' + (sigma_n^2) * eye(size(X, 1)); % Woodbury matrix (n x n) 
    inverseWoodbury = chol2invchol(Woodbury); % Applying the matrix inversion Woodbury identity
    Sigma_w = eye(n_features) - Phi' * inverseWoodbury * Phi; % (n_features x n_features) covariance matrix
    mean_w = Sigma_w * Phi' * Y / sigma_n^2; % (n_features x 1) covariance matrix
    W_sample = mean_w + chol(Sigma_w, 'lower')*noise; % (n_features x 1) 
else
    Sigma_w = chol2invchol(Phi'*Phi / sigma_n^2 + eye(n_features)); % (n_features x n_features) covariance matrix
	mean_w = Sigma_w * Phi' * Y / sigma_n^2; % (n_features x 1) covariance matrix
	W_sample = mean_w + chol(Sigma_w, 'lower')*noise; % (n_features x 1) 
end

end