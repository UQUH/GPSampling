function [posterior_path, prior_path, update_path] = rff_pc_se_paths(x_query, xData, yData, ell, sigma_f, invC, Omega, b, W_prior, f_data, noise)
% Input
    % x_query (n_query x 1): query points
    % xData (n x d): matrix of input variables
    % yData (n x 1): vector of output variable
    % ell (d x 1): length scales
    % sigma_f>0: output scale
    % invC (n x n): inverse of covariance matrix
    % Omega (n_features x d): sample random spectral points
    % b (n_features x 1): random phase shift points
    % W_prior (n_features x 1) prior weigths for Bayesian linear model
    % f_data (n x 1): prior sample values at xData
    % noise (n x 1): random bits

% Output
    % posterior_path, prior_path, update_path (n_query x 1): posterior, prior, and update paths of PC 

% Prior path
n_features = size(W_prior,1);
Phi_query = rff_ard_se_features(x_query, sigma_f, n_features, Omega, b); % (n_query x n_features)
prior_path = Phi_query * W_prior; %(n_query x 1);

% Cross-covariance matrix between x_query and xData
kstar = ard_se_cov(x_query, xData, ell, sigma_f);  %(n_query x n);

% Update path
update_path = kstar * invC * (yData - f_data - noise);

% Posterior path
posterior_path =  prior_path + update_path;
end