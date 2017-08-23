n = 1e5;
alpha = 0.01;
p = 0.75;
extremeVal = [0,9];
Y1 = 3 * rand(n,3);
Y2 = sum(Y1, 2);
[exactCI, CLTCI] = binomialCI(n, sum( Y2 >= 7),alpha)
quantci = quantileCI(p, Y2, extremeVal, alpha) 


