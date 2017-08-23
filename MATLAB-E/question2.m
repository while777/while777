u = 1;
sigma=1.5;
f = @(x) (1 / sqrt(2 * pi * 1.5.^2)) * exp( - (x - 1).^2/(1.5.^2)) ;
Q = integral( @(x)  f(x), -Inf, 1)

price = fminunc ( @(x) blstheta(x, 50, 0.02, 1/12, 0.15, 0), 50)
theta = blstheta(price, 50, 0.02,1/12,0.15,0)

blstheta(51, 50, 0.02, 1/12, 0.15, 0)
blstheta(49, 50, 0.02, 1/12, 0.15, 0)