from scipy import stats
from numpy import random
from numpy import exp, sqrt, max, min, mean, std, prod, all, any
import numpy as np

def MCOptionPrices(S0, K, T, rateCurve, sigma, t, checkpoints, samples, integrator):

    means = []
    StdDevs = []
    StdErrs = []
    delta = T / len(samples[ 0, :])
    r = np.interp(T, tt, rateCurve)

    if integrator == 'standard':
        i = 0
        sample = samples
        while i < (len(checkpoints)):
            if i == 0:
                sm = samples
                std1 = exp(sigma * sqrt(delta) * np.sum(stats.norm.ppf(sm), axis = 1) )
                std2 = S0 * exp((r - 0.5 * sigma ** 2) * T)
                st = std1 * std2
                means.append( mean(st))
                StdDevs.append(std(st))
                StdErrs.append((std(st)) / sqrt(checkpoints[i]))
                i = i + 1

            else:
                sample = np.vstack((  (random.rand(checkpoints[i] - checkpoints[i - 1], len(samples[ 0, :]))), sample ))
                std3 = exp(sigma * sqrt(delta) * np.sum(stats.norm.ppf(sample), axis = 1) )
                std4 = S0 * exp((r - 0.5 * sigma ** 2) * T)
                st = std3 * std4
                means.append(mean(st))
                StdDevs.append(std(st))
                StdErrs.append( (std(st)) / sqrt(checkpoints[i]) )
                i = i + 1

        TV = max(means[-1] - K, 0) * exp(- T * r)
        data = {'TV': TV, 'Means': means, 'StdDevs': StdDevs, 'StdErrs': StdErrs}
        print data

    elif integrator == 'euler':
        i = 0
        sample = samples
        while i < (len(checkpoints)):
            if i == 0:
                sample = samples
                euler = S0 * np.prod(1 + r * delta + sigma * sqrt(delta) * stats.norm.ppf(sample), axis=1)
                means.append(mean(euler))
                StdDevs.append(std(euler))
                StdErrs.append((std(euler)) / sqrt(checkpoints[i ]))
                i = i + 1

            else:
                sample = np.vstack(((random.rand(checkpoints[i] - checkpoints[i - 1], len(samples[0, :]))), sample))
                euler = S0 * np.prod(1 + r * delta + sigma * sqrt(delta) * stats.norm.ppf(sample), axis=1)
                means.append(mean(euler))
                StdDevs.append(std(euler))
                StdErrs.append((std(euler)) / sqrt(checkpoints[i]))
                i = i + 1

        TV = max(means[-1] - K, 0) * exp(- T * r)
        data = {'TV': TV, 'Means': means, 'StdDevs': StdDevs, 'StdErrs': StdErrs}
        print data

    elif integrator == 'milstein':
        i = 0
        det = sigma
        sample = samples
        while i < len(checkpoints):
            if i == 0:
                sample = samples
                euler = np.row_stack ( S0 * np.prod(1 + r * delta + sigma * sqrt(delta) * stats.norm.ppf(sample) + 0.5 * sigma * det * delta * ((stats.norm.ppf(sample)) ** 2  - 1), axis=1)  )
                means.append(mean(euler))
                StdDevs.append(std(euler))
                StdErrs.append((std(euler)) / sqrt(checkpoints[i ]))
                i = i + 1

            else:
                sample = np.vstack(((random.rand(checkpoints[i] - checkpoints[i - 1], len(samples[0, :]))), sample))
                euler = np.row_stack( S0 * np.prod( (1 + r * delta + sigma * sqrt(delta) * stats.norm.ppf(sample) + 0.5 * sigma * det * delta * ((stats.norm.ppf(sample)) ** 2 - 1)), axis=1) )
                means.append(mean(euler))
                StdDevs.append(std(euler))
                StdErrs.append((std(euler)) / sqrt(checkpoints[i]))
                i = i + 1

        TV = max(means[-1] - K, 0) * exp(- T * r)
        data = {'TV': TV, 'Means': means, 'StdDevs': StdDevs, 'StdErrs': StdErrs}
        print data


tt = [1, 3, 6, 12, 24, 36, 60]
rateCurve = [0.27, 0.33, 0.47, 0.6, 0.78, 0.91, 1.18]
checkpoints = [1000, 2000, 5000, 10000, 20000, 50000, 100000]
t = np.arange(1./250, 1+1./250, 1./250)

samples = np.random.rand(1000, len(t))
if __name__=="__main__":
    MCOptionPrices(100., 100., 1., rateCurve, 0.2, t, checkpoints, samples, 'standard')
    MCOptionPrices(100., 100., 1., rateCurve, 0.2, t, checkpoints, samples, 'euler')
    MCOptionPrices(100., 100., 1., rateCurve, 0.2, t, checkpoints, samples, 'milstein')