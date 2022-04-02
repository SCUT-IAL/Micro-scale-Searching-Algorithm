function [xmin,Overave,BWave] = purecmaes(dim, Initial, Area)
% CMA-ES: Evolution Strategy with Covariance Matrix Adaptation
% for nonlinear function minimization.
format long;
format compact;
% --------------------  Initialization --------------------------------
N = dim;               % number of objective variables/problem dimension
xmean = Initial; % objective variables initial point

sigma = 0.05; %0.01~0.1          % coordinate wise standard deviation (step size)
stopfitness = 1e-4;  % stop if fitness < stopfitness (minimization)
%stopeval = 40000;   % stop after stopeval number of function evaluations
stopeval = 200000;
%Max_iter = 1000;   % stop after stopeval number of iteration

% Strategy parameter setting: Selection
lambda = 50;  % population size, offspring number
mu = lambda/2;               % number of parents/points for recombination
weights = log(mu+1/2)-log(1:mu)'; % muXone array for weighted recombination
mu = floor(mu);
weights = weights/sum(weights);     % normalize recombination weights array
mueff=sum(weights)^2/sum(weights.^2); % variance-effectiveness of sum w_i x_i

% Strategy parameter setting: Adaptation
cc = (4 + mueff/N) / (N+4 + 2*mueff/N); % time constant for cumulation for C
cs = (mueff+2) / (N+mueff+5);  % t-const for cumulation for sigma control
c1 = 2 / ((N+1.3)^2+mueff);    % learning rate for rank-one update of C
cmu = min(1-c1, 2 * (mueff-2+1/mueff) / ((N+2)^2+mueff));  % and for rank-mu update
%damps = 1 + 2*max(0, sqrt((mueff-1)/(N+1))-1) + cs; % damping for sigma

% Initialize dynamic (internal) strategy parameters and constants
pc = zeros(N,1); ps = zeros(N,1);   % evolution paths for C and sigma
B = eye(N,N);                       % B defines the coordinate system
D = ones(N,1);                      % diagonal D defines the scaling
C = B * diag(D.^2) * B';            % covariance matrix C
invsqrtC = B * diag(D.^-1) * B';    % C^-1/2
eigeneval = 0;                      % track update of B and D
%chiN=N^0.5*(1-1/(4*N)+1/(21*N^2));  % expectation of

% -------------------- Generation Loop --------------------------------
counteval = 0;  
iter = 1;
arx = zeros(N, lambda);
arfitness = zeros(1, lambda);

xmin = xmean;
xmin_val = Evaluation(xmin, Area);

History_Xmin = zeros(N, 2000);
History_Xmin(:, iter) = xmin;
while counteval <= stopeval - lambda
    % Generate and evaluate lambda offspring
    parfor k=1:lambda
        arx(:,k) = xmean + sigma * B * (D .* randn(N,1)); % m + sig * Normal(0,C)
        arfitness(k) = Evaluation(arx(:,k), Area); % objective function call
        counteval = counteval+1;
    end
    
    % Sort by fitness and compute weighted mean into xmean
    [arfitness, arindex] = sort(arfitness);  % minimization
    if arfitness(1) < xmin_val
        xmin = arx(:, arindex(1));
        xmin_val = arfitness(1);
    end
    
    xold = xmean;
    xmean = arx(:,arindex(1:mu)) * weights;  % recombination, new mean value
    xmean_val = Evaluation(xmean, Area);
    if xmean_val < xmin_val
        xmin = xmean;
        xmin_val = xmean_val;
    end
    iter = iter + 1;
    History_Xmin(:, iter) = xmin;
    
    % Prevent the rang of every dimension over the [-1.5, 1.5]
    if mod(iter, 200) == 0
        for i = 1:N
            if abs(xmean(i)) > 1.5
                xmean(i) = mean(History_Xmin(i, (iter-150):(iter-50) ) );
            end
        end
    end
    
    % Cumulation: Update evolution paths
    ps = (1-cs) * ps ...
        + sqrt(cs*(2-cs)*mueff) * invsqrtC * (xmean-xold) / sigma;
    hsig = sum(ps.^2)/(1-(1-cs)^(2*counteval/lambda))/N < 2 + 4/(N+1);
    pc = (1-cc) * pc ...
        + hsig * sqrt(cc*(2-cc)*mueff) * (xmean-xold) / sigma;
    
    % Adapt covariance matrix C
    artmp = (1/sigma) * (arx(:,arindex(1:mu)) - repmat(xold,1,mu));  % mu difference vectors
    C = (1-c1-cmu) * C ...                   % regard old matrix
        + c1 * (pc * pc' ...                % plus rank one update
        + (1-hsig) * cc*(2-cc) * C) ... % minor correction if hsig==0
        + cmu * artmp * diag(weights) * artmp'; % plus rank mu update
    
    % Adapt step size sigma
    % sigma = sigma * exp((cs/damps)*(norm(ps)/chiN - 1));
    
    % Update B and D from C
    if counteval - eigeneval > lambda/(c1+cmu)/N/10  % to achieve O(N^2)
        eigeneval = counteval;
        C = triu(C) + triu(C,1)'; % enforce symmetry
        [B,D] = eig(C);           % eigen decomposition, B==normalized eigenvectors
        D = sqrt(diag(D));        % D contains standard deviations now
        invsqrtC = B * diag(D.^-1) * B';
    end
    
    % Break, if fitness is good enough or condition exceeds 1e14, better termination methods are advisable
    if arfitness(1) <= stopfitness || max(D) > 1e7 * min(D)
        break;
    end
    
    % Output
    disp([num2str(iter) ': ' num2str(xmin_val) ' ' num2str(xmean_val) ' ' ...
        num2str(sigma*sqrt(max(diag(C)))) ' ' ...
        num2str(max(D) / min(D))]);
end

% ------------- Final Message and Plotting Figures --------------------
disp([num2str(iter) ': ' num2str(xmin_val)]);