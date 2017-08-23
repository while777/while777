S0=50; K = 52; r = 0.01; T = 1/12; sigma = 0.25; Nsteps = 30; alpha = 0.01; relTol = 0.025/1.025;
delta = T / Nsteps;
Niterations = 1000;
rng(777);  
%%
path = S0 * exp(delta * (r-sigma.^2./2) * cumsum(ones(Niterations, Nsteps),2) + sigma * sqrt(delta) * cumsum(randn(Niterations, Nsteps),2));
payoff = exp(-r * T) * max( mean(path, 2) - K, 0);
std = std(payoff);
mean = mean(payoff);
%%
N = floor((-norminv(alpha/2) * std/(relTol * mean)).^2);
Path = S0 * exp(delta * (r-sigma.^2./2) * cumsum(ones(N, Nsteps),2) + sigma * sqrt(delta) * cumsum(randn(N, Nsteps),2));

Payoff = exp(-r * T) * max( mean(Path, 2) - K, 0);
price = mean(Payoff)
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(Payoff);
CI = MUCI(2)-MUCI(1)

%%
Sums = S0 + sum(path, 2);
coeff = - cov(Sums, payoff)/ var(Sums);
EX = S0 * (exp(r.* delta * (Nsteps + 1)) - 1)./(exp(r * delta)-1);
pay = exp(-r * T) .* max(mean(path, 2) - K, 0) + coeff .* (Sums - EX);
call = mean(pay);
stdcall = std(pay);
N1 = floor((-norminv(alpha/2) * stdcall/(relTol * call)).^2);
%%
Path1 = S0 * exp(delta *(r-sigma.^2./2)* cumsum(ones(N1, Nsteps),2) + sigma * sqrt(delta) .* cumsum(randn(N1, Nsteps),2));
Pay = exp(-r * T) .* max( mean(Path1, 2) - K, 0);
X = S0 + sum(Path1, 2);
coeff1 = -cov(Pay, X)./ var(X);
ccc =  exp(-r * T) .* max(mean(path1, 2) - K, 0) + coeff1 .* (X - EX);
mm = mean(ccc)
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(ccc);
CI2 = MUCI(2)-MUCI(1)
%%
Price = exp(-r * T) * max( path(:, end) - K, 0);
coe = -cov(Price, payoff)/var(Price);
Y = exp(-r * T) .* max(mean(path, 2) - K, 0) + coe .* (Price - mean(Price));
Call = mean(Y);
stdCall = std(Y);
N2 = floor((-norminv(alpha/2) * stdCall/(relTol * Call)).^2);
%%
Path2 = S0 * exp(delta * cumsum(ones(N2, Nsteps),2) + sigma * sqrt(delta) * cumsum(randn(N2, Nsteps),2));
price2 = exp(-r * T) * max( mean(path2, 2) - K, 0);
Price1 = exp(-r * T) * max( path2(:, end) - K, 0);
coe1 = -cov(Price1, Price2)/var(Price1);
Y1 = exp(-r * T) .* max(mean(path2, 2) - K, 0) + coe1 .* (Price1 - blsprice(50, 52, 0.01, T, 0.25));
mmm = mean(Y1) 
[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(Y1);
CI1 = MUCI(2)-MUCI(1)

