clc; clear;
% training data
d = 1; % no. of dimension
xData = [0; 0.25; 0.5; 0.75; 1];
yData = [1.42; -0.45; -0.845; -0.788; 0.666];
n = size(xData,1);
% std of observation noise
sigma_n = 1e-3;
% lengthscale
ell = 0.05;
% output scale
sigma_f = 1;
% query points 
x_query = (0:5e-4:1)';

% number of RFFs
n_features = 2000;

% covariance matrix and its inverse
C = ard_se_cov(xData, xData, ell, sigma_f) + sigma_n^2*eye(size(xData,1)); % covariance matrix
invC= chol2invchol(C); % inverse of covariance matrix

% spectral points and b vector
rng(44); % for reproducibility
[Omega,b] = rff_ard_se_parameters(d,ell,n_features);
W_prior = randn(n_features, 1);  % (n_features x 1) prior weigths
Phi_data = rff_ard_se_features(xData, sigma_f, n_features, Omega, b); % (n x n_features)
% Prior sample values at xData
f_data = Phi_data * W_prior; % (n x 1)
% random bits
noise = randn(n, 1)*sigma_n; % (n x 1)
% posterior, prior, and update paths of PC 
[posterior_path, prior_path, update_path] = rff_pc_se_paths(x_query, xData, yData, ell, sigma_f, invC, Omega, b, W_prior, f_data, noise);

% plot
figure1 = figure('Color',[1 1 1]);
p(2) = plot(x_query,prior_path,'LineWidth',1.5,...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794],'DisplayName','Prior'); hold on; % prior path
p(3) = plot(x_query,update_path,'LineWidth',1.5,...
    'Color',[0.466666668653488 0.674509823322296 0.18823529779911],'DisplayName','Update'); % update (data adjustment) path
p(4) = plot(x_query,posterior_path,'LineWidth',2,...
    'Color',[0 0 0],'DisplayName','Posterior'); % posterior path
p(1) = plot(xData,yData,...
    'MarkerFaceColor',[0 0 0],...
    'MarkerSize',8,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 0],'DisplayName','Observations'); % data points
hl = legend(p(1:4));
set(hl,'NumColumns',4,'Location','northoutside','Interpreter','latex','Box','off','FontSize',20)
ax = gca;
ax.FontName = 'Roboto';
ax.FontSize = 30;
ax.TickLabelInterpreter = 'latex';
xlabel('$x$','Interpreter','latex','FontSize',33);
ylabel('Function value','Interpreter','latex','FontSize',33);

