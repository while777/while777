function [mm, CI] = AsianCall_CV (S0, K, r, T, sigma, N, M, seed)
rng(seed)
dt = T./N;
relTol = 0.025/1.025;
alpha = 0.01;
nudt = (r - sigma ^2/2) * dt;
sigmasqrt = sigma * sqrt(dt);

path = S0 * exp(nudt * cumsum(ones(N, M)) + sigmasqrt* cumsum(randn(N, M)));
payoff = exp(-r * T) * max( mean(path) - K, 0);

euro = exp(-r * T) * max( path(end, :) - K, 0);
Varcov = cov(euro, payoff); 
coe = - Varcov(1, 2)./var(euro);
Y = exp(-r .* T) .* max(mean(path) - K, 0) + coe .* (euro - mean(euro));
Call = mean(Y);
stdCall = std(Y);
N3 = floor((-norminv(alpha/2) * stdCall/(relTol * Call)).^2)

Path2 = S0 * exp(nudt * cumsum(ones(N, N3)) + sigmasqrt * cumsum(randn(N, N3)));
Price2 = exp(-r * T) * max( mean(Path2) - K, 0);
Price1 = exp(-r * T) * max( Path2(end,:) - K, 0);
Covvar = cov(Price1, Price2);
coe1 = -Covvar(1 , 2)./var(Price1);
Y1 = exp(-r .* T) .* max(mean(Path2) - K, 0) + coe1 .* (Price1 - mean(Price1));

mm = mean(Y1) 
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(Y1);
CI = MUCI
(MUCI(2)-MUCI(1))/(2 *mm)

end
