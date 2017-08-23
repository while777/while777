rng(888);
n = 1e4;
sigmax2 = 0.4;
sigmay2 = 0.3;
Z1 = randn(n,1);
Z2 = randn(n,1);
X = sqrt(sigmax2) * Z1;
Y = sqrt(sigmay2) * (0.7 * Z1 + sqrt(1 - 0.7^2) * Z2);
