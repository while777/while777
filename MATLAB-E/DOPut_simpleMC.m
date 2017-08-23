function [put, CI ] = DOPut_simpleMC(S0, K, r, T, sigma, Sb, N, M, seed)
rng(seed);
dt = T./N;
nudt = (r - sigma ^2/2) * dt;
sigmasqrt = sigma * sqrt(dt);

path = S0 * exp(nudt * cumsum(ones(N, M)) + sigmasqrt* cumsum(randn(N, M)));
crossed = any(path <= Sb);
payoff = exp(- r .* T) .* max(K - path(end, :), 0).*(1- crossed);
put = mean(payoff)

[MUHAT, SIGMAHAT, MUCI, SIGMACI] = normfit(payoff);
CI = MUCI

end
