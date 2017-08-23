function [mm, CI] = AsianCall_CVSum (S0, K, r, T, sigma, N, M, seed)
rng(seed)
dt = T./N;
relTol = 0.025/1.025;
alpha = 0.01;
nudt = (r - sigma ^2/2) * dt;
sigmasqrt = sigma * sqrt(dt);

path = S0 * exp(nudt * cumsum(ones(N, M)) + sigmasqrt* cumsum(randn(N, M)));
payoff = exp(-r * T) * max( mean(path) - K, 0);
Sums =  S0 +  sum(path);
Varcov = cov(Sums, payoff);
coeff = - Varcov(1, 2)/ var(Sums);
EX = S0 * (exp(r * dt * (N + 1)) - 1) /(exp(r * dt)-1);

pay = exp(-r * T) * max(mean(path) - K, 0) + coeff .* (Sums - EX);
call = mean(pay);
stdcall = std(pay);
N2 = floor((-norminv(alpha/2) * stdcall/(relTol * call)).^2)

Path1 = S0 * exp(nudt* cumsum(ones(N, N2)) + sigmasqrt* cumsum(randn(N, N2)));
Pay = exp(-r * T) * max( mean(Path1) - K, 0);
X = S0 + sum(Path1);
Covvar = cov(Pay, X);
coeff1 = -Covvar(1, 2)./ var(X);
ccc =  exp(-r * T) * max(mean(Path1) - K, 0) + coeff1 .* (X - EX);
mm = mean(ccc)
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(ccc);
CI = MUCI
(MUCI(2)-MUCI(1))/(2 *mm)
end
