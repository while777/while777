function [price1, price2]= Anttitheticvariat(S0, M, N, r, sigma, T)
alpha = 0.01;
delta = T/N;
mudt = (r - sigma.^2/2) .* delta;
sigmasqrt = sigma.* sqrt(delta);
relTol = 0.01;

Z1 = randn(N, M);
Z2 = - Z1;
Z3 = cat(2, Z1, Z2);

tic
Sval = S0 .* exp(mudt .* cumsum(ones(N, M)  + sigmasqrt .* cumsum(Z1)));
Yval = max( (max(S0 .* ones(1, M),max(Sval,[],1)) - Sval(end,:)),0) .* exp(-r .* T);
price0 = mean(Yval); 
std1 = std(Yval);
N1 = floor((-norminv(alpha/2) * 1.2 * std1/(relTol * price0))^2 );
Sv = S0 .* exp(mudt .* cumsum(ones(N, N1)  + sigmasqrt .* cumsum(randn(N, N1))));
Yv = max((max(S0 .* ones(1, N1),max(Sv,[],1)) - Sv(end,:)),0) .* exp(-r .* T);
price1 = mean(Yv);

toc

tic
S = S0 .* exp(mudt .* cumsum(ones(N, 2 * M)  + sigmasqrt .* cumsum(Z3)));
Y = max((max(S0 .* ones(1, 2 * M),max(S,[],1)) - S(end, :)),0)  .* exp(-r .* T);
price2 = mean(Y);
%std2 = std(Y);
%N2 = floor((-norminv(alpha/2) * std2/(relTol * price2)).^2);
%s = S0 .* exp(mudt .* cumsum(ones(N, N2)  + sigmasqrt .* cumsum(randn(N, N2))));
%y = (max(S0 .* ones(1, N2),max(s,[],1)) - s(end,:)) .* exp(-r .* T);
%price3 = mean(y);
toc

end
