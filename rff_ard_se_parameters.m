function [Omega,b] = rff_ard_se_parameters(d,ell,n_features)
% Input
    % d: no. of dimensions
    % ell: (d x 1) length scales
    % n_features: number of random Fourier features

% Output
    % Omega (n_features x d): random spectral points
    % b (n_features x 1): random phase shift points
    
% Sample random spectral points
Omega = randn(n_features, d) ./ ell'; % (n_features x d)
% Sample random phase shift b ~ U(0, 2*pi)
b = 2 * pi * rand(n_features, 1); % (n_features x 1)

end