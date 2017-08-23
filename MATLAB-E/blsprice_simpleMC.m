function  [price1, price2, CI, ci] = blsprice_simpleMC (S, K , r, T, sigma, N, seed)

rng(seed);
mu = r - sigma.^2/2;
muT = mu.* T;
sigmasqrt = sigma.* sqrt(T);
Z0 = randn(1, N);
Z1 = -1 .* Z0;
Z2 = cat(2, Z0, Z1);

ST1 = S * exp(muT + sigmasqrt.* Z0);
ST2 = S * exp(muT + sigmasqrt.* Z2);

payoff1 =  exp(-r * T).* max(K - ST1, 0);
payoff2 =  exp(-r * T).* max(K - ST2, 0);

price1 = mean(payoff1);
price2 = mean(payoff2);

[MUHAT, SIGMAHAT, MUCI, SIGMACI ] = normfit(payoff1);
[muhat, sigmahat, muci, sigmaci ] = normfit(payoff2);
CI = MUCI(2)-MUCI(1) ;
ci = muci(2)-muci(1);

end
