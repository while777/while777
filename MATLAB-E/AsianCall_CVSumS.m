function [call, CI] = AsianCall_CVSumS (S0, K, r, T, sigma, N, M, seed)
rng(seed)
dt = T./N;
relTol = 0.025/1.025;
alpha = 0.01;
nudt = (r - sigma ^2/2) * dt;
sigmasqrt = sigma * sqrt(dt);

path = S0 * exp(nudt * cumsum(ones(N, M)) + sigmasqrt* cumsum(randn(N, M)));
payoff = exp(-r .* T) .* max( mean(path) - K, 0);

call = mean(payoff);
stdcall = std(payoff);

N1 = floor( (stdcall * -norminv(alpha/2))^2/(relTol * call)^2)

Path = S0 * exp(nudt * cumsum(ones(N, N1)) + sigmasqrt * cumsum(randn(N, N1)));
Payoff = exp(-r * T) * max( mean(Path) - K, 0);
price = mean(Payoff)
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(Payoff);
CI = MUCI
(MUCI(2)-MUCI(1))/(2 * price)

end



