r = 0.03;
S0 = 5000;
sigma = 0.08;
q = 0.02;
T=1;
ST = 4000:100:9000;
%% Get St-S0 at the end of this note.
P1 =  - max(S0, ST);
%% Call option combined with lending.
lending = S0 * exp(-r * T);
call = max(ST-S0, 0);
P2 = lending * exp(r * T) + call;
%% plot
plot(ST, P1, '-r');
hold on
plot(ST, P2, '-b');
%% profit at time 0
a = blsprice(S0, S0, r, T, sigma, q);
profit = S0  - a;
b = fsolve(@(r)S0-blsprice(5000, 5000, r, 1, 0.08, 0.02), 0.0001)
