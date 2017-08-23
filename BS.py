""" Simulate interest rate path by the Brennan Schwartz model """
import numpy as np
import scipy.linalg as spl


def brennan_schwartz(r0, theta0, a, b, sigma, rho, y, T=0.25, N=1, seed=777):
    np.random.seed(seed)
    dt = T / float(N)
    rates = [r0]
    thetas = [theta0]
    # Sigma = np.ones([2,2])*dt
    # Sigma[0,1] = rho*dt
    # Sigma[1,0] = rho*dt
    # L = spl.cholesky(Sigma, lower=True)

    for i in range(N):
        # y = np.dot(L, np.random.randn(2,1))
        dr = (a[0] + a[1] * (thetas[-1] - rates[-1]) * dt) + sigma[0] * rates[-1] * y[0]
        dtheta = thetas[-1] * (b[0] + b[1] * rates[-1] + b[2] * thetas[-1]) * dt + sigma[1] * thetas[-1] * y[1]  # dt * ( rho * sigma1 * Z1 + sqrt(1-rho**2) * sigma(0) * Z2)

        rates.append(rates[-1] + dr)
        thetas.append(thetas[-1] + dtheta)

    return  rates


from math import *
dt = 0.25
Sigma = np.ones([2,2])
rho = 0.3
Sigma[0,0] = dt
Sigma[0,1] = rho * dt
Sigma[1,0] = rho * dt
Sigma[1,1] = dt
L = spl.cholesky(Sigma, lower=True)
print L
# Check that the factors multiply to Sigma
# print np.dot(L, L.T) #transpose

r = np.array([[-0.16861717,  0.4072987, -1.82467762,  0.07777817,   2.50286929],
             [ 1.32958849,  0.20024067, -1.04039457,  0.10351275, 1.24437217]])

y = np.dot(L, r)
z = brennan_schwartz(0.02, 0.05, [0, 0.5], [0, 0.01, 0.1], [0.1, 0.05], 0.3, y, T=0.25, N=1, seed=777)
x = z[1]

mean = np.mean(x)
std = np.std(x)
error = float(std)/len(x)
print z
print mean, std, error
