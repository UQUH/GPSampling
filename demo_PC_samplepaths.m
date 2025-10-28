clc; clear
% Training data
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

% number of paths for plotting
no_paths = 10;

% number of RFFs
n_features = 2000;

% covariance matrix and its inverse
C = ard_se_cov(xData, xData, ell, sigma_f) + sigma_n^2*eye(size(xData,1)); % covariance matrix
invC= chol2invchol(C); % inverse of covariance matrix

for j = 1:no_paths
    rng(44*j); % for reproducibility
    [Omega,b] = rff_ard_se_parameters(d,ell,n_features);
    W_prior = randn(n_features, 1);  % (n_features x 1) prior weigths
    Phi_data = rff_ard_se_features(xData, sigma_f, n_features, Omega, b); % (n x n_features)
    % Prior sample values at xData
    f_data = Phi_data * W_prior; % (n x 1)
    % random bits
    noise = randn(n, 1)*sigma_n; % (n x 1)
    % posterior path
    f_query(:,j) = rff_pc_se_paths(x_query, xData, yData, ell, sigma_f, invC, Omega, b, W_prior, f_data, noise);
end

% plot
figure1 = figure('Color',[1 1 1]);
p(2) = plot(x_query,f_query(:,1),'LineWidth',1,...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176],'DisplayName','Posterior samples'); % posterior path
hold on
for j = 2:no_paths
    plot(x_query,f_query(:,j),'LineWidth',1,...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]); % posterior path
end

p(1) = plot(xData,yData,...
    'MarkerFaceColor',[0 0 0],...
    'MarkerSize',8,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 0],...
    'DisplayName','Observations'); % data points

hl = legend(p(1:2));
set(hl,'NumColumns',2,'Location','north','Interpreter','latex','Box','off','FontSize',20)
ax = gca;
ax.FontName = 'Roboto';
ax.FontSize = 30;
ax.TickLabelInterpreter = 'latex';
xlabel('$x$','Interpreter','latex','FontSize',33);
ylabel('Function value','Interpreter','latex','FontSize',33);