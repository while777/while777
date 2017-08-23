

S0=50;
K = 52;  
r = 0.01;
T = 1/12;
sigma = 0.25;
N = 5; 
seed = 777;
rng(seed);
alpha = 0.01;
relTol = 0.025;
delta = T / N;
M = 10;

path = S0 * exp(delta * cumsum(ones(M, N),2) + sigma * sqrt(delta) * cumsum(randn(M, N),2))
c = mean(path, 2)