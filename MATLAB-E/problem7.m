%%random walk number
n = 1e5;
alpha = 0.01;
p = 0.75;
extremeVal = [0,9];
Y1 = sum(3 * rand(n,3),2);
[exactCI, CLTCI] = binomialCI(n, sum( Y1 >= 7),alpha)
quantci = quantileCI(p, Y1, extremeVal, alpha) 






