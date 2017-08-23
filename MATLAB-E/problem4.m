price = fminunc ( @(x) blstheta(x, 50, 0.02, 1/12, 0.15, 0), 50)
theta = blstheta(price, 50, 0.02,1/12,0.15,0)
