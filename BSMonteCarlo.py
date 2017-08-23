from scipy import stats
from numpy import random
from numpy import exp, sqrt, max, min, mean, std
import numpy as np

def BSMonteCarlo(S0, K, T, sigma, checkpoints, rateCurve, samples = None):

    means = []
    StdDevs = []
    StdErrs = []

    r = np.interp(T, t, rateCurve)

    if samples == None:
        i = 0
        sample = random.rand(checkpoints[0], 1)
        while i < len(checkpoints):
            if i == 0:
                sample = random.rand(checkpoints[i], 1)
                ST = S0 * exp((r - 0.5 * sigma ** 2) * T + sigma * sqrt(T) * stats.norm.ppf(sample))
                means.append(mean(ST))
                StdDevs.append(std(ST))
                StdErrs.append(std(ST) / sqrt(checkpoints[i]))
                i = i + 1
            else:
                sample = np.vstack((  (random.rand(checkpoints[i] - checkpoints[i - 1], 1)), sample ))
                ST = S0 * exp((r - 0.5 * sigma ** 2) * T + sigma * sqrt(T) * stats.norm.ppf(sample))
                means.append(mean(ST))
                StdDevs.append(std(ST))
                StdErrs.append(std(ST) / sqrt(checkpoints[i]))
                i = i + 1

    elif samples != None:
        if len(samples) < checkpoints[-1]:
            raise Exception('Wrong')
        else:
            ST = S0 * exp((r - 0.5 * sigma ** 2) * T + sigma * sqrt(T) * stats.norm.ppf(samples))
            means.append(mean(ST))
            StdDevs.append(std(ST))
            StdErrs.append(std(ST) / sqrt(checkpoints[- 1]))

    TV = max(means[-1] - K, 0) * exp(- T * r)
    data = {'TV': TV, 'Means': means, 'StdDevs': StdDevs, 'StdErrs': StdErrs}
    print data

checkpoints = [1000, 2000, 5000, 10000, 20000, 50000, 1e5, 200000, 500000, 1e6]
t = [1, 3, 6, 12, 24, 36, 60]
rateCurve = [0.27, 0.33, 0.47, 0.6, 0.78, 0.91, 1.18]

if __name__=="__main__":
    BSMonteCarlo(100, 100, 1, 0.2, checkpoints, rateCurve, samples = None)

