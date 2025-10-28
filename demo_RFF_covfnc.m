clc; clear 
n_features = [50 100 500 1000 2000];
X = linspace(0, 10, 2000)';
X_prime = 0;
d = 1; % no. of dimension
ell = sqrt(5); % length scale
sigma_f = 1;   % output scale
% compute true covariance function values
K_true = ard_se_cov(X, X_prime, ell, sigma_f);

for k = 1:length(n_features)
        rng(600*k); % for reproducibility
        [Omega,b] = rff_ard_se_parameters(d,ell,n_features(k));
        Phi_X = rff_ard_se_features(X, sigma_f, n_features(k), Omega, b);
        Phi_X_prime = rff_ard_se_features(X_prime, sigma_f, n_features(k), Omega, b);
        K_RFF(:,k) = Phi_X*Phi_X_prime'; % compute approximate covariance function values
end 
% plot
figure1 = figure('Color',[1 1 1]);
p(1) = plot(X, K_true,'LineWidth',6,...
    'Color',[0.800000011920929 0.800000011920929 0.800000011920929],'DisplayName','True');
hold on
p(2) = plot(X, K_RFF(:,1),'LineWidth',1.5,...
    'Color',[0 0.447058826684952 0.74117648601532],'LineStyle','-','DisplayName','$N_\phi=50$');
p(3) = plot(X, K_RFF(:,2),'LineWidth',1.5,...
    'Color',[1 0 0],'LineStyle','-','DisplayName','$N_\phi=100$');
p(4) = plot(X, K_RFF(:,3),'LineWidth',2.0,...
    'Color',[0 0 1],'LineStyle','-','DisplayName','$N_\phi=500$');
p(5) = plot(X, K_RFF(:,4),'LineWidth',2.0,...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794],'LineStyle','-','DisplayName','$N_\phi=1000$');
p(6) = plot(X, K_RFF(:,5),'LineWidth',2.5,...
    'Color',[0 0 0],'LineStyle','-','DisplayName','$N_\phi=2000$');
hl = legend(p(1:6));
set(hl,'NumColumns',2,'Interpreter','latex','Box','off','FontSize',20,'Location','northeast')
ax = gca;
ax.FontName = 'Roboto';
ax.FontSize = 30;
ax.TickLabelInterpreter = 'latex';
xlabel('$x$','Interpreter','latex','FontSize',33);
ylabel('$\kappa(x-0)$','Interpreter','latex','FontSize',33);