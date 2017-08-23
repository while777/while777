function [spreadopt, S] = spreadopt_simpleMC(S1, S2, K, r, T, sigma1, sigma2, rho, N, seed)

rng(seed);
nu1 = r - sigma1.^2/2;
nu2 = r - sigma2.^2/2;
nu1T = nu1.* T;
nu2T = nu2.* T;
sigma1sqrt = sigma1.* sqrt(T);
sigma2sqrt = sigma2.* sqrt(T);
Z1 = randn(1, N);
Z2 = randn(1, N);
S1T = S1 * exp(nu1T + sigma1sqrt.* Z1);
S2T = S2 * exp(nu2T + sigma2sqrt.* (rho.* Z1 + sqrt(1 - rho.^2) .* Z2));
c = exp(-r * T).* max(S1T - S2T - K, 0);
spreadopt = mean(c)
S = std(c)
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(c);
CI = MUCI
end
