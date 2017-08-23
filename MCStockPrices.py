from scipy import stats
from numpy import random
from numpy import exp, sqrt, max, min, mean, std, prod, cumprod
import numpy as np

def MCStockPrices(S0, sigma, rateCurve, t, samples, integrator):

    r = np.interp(t[-1], tt, rateCurve)
    delta = t[-1]/len(samples[ 0, :])

    if integrator == 'standard':
       std1 = exp(np.cumsum(sigma * sqrt(delta) * stats.norm.ppf(samples), axis = 1))
       i = 1
       std2 = np.zeros([len(samples), len(samples[ 0, :])])
       while i <= len(samples[ 0, :]):
          std2[:, i-1 : i] = S0 * exp((r - 0.5 * sigma ** 2)  * delta * i)
          i = i + 1
          if i == len(samples[ 0, :]) + 1:
              std = std1 * std2
              return std

    if integrator == "euler":
       i = 1
       result = np.zeros([len(samples), len(samples[ 0, :])])
       while i <= len(samples[ 0, :]):
           result[:, i-1 : i] = np.row_stack(S0 * np.prod(1 + r * delta + sigma * sqrt(delta) * stats.norm.ppf(samples[:, 0 : i]), axis=1))
           i = i + 1
           if i == len(samples[ 0, :]) + 1:
               return result

    if integrator == 'milstein':
       det = sigma
       i = 1
       result = np.zeros([len(samples), len(samples[ 0, :])])
       while i <= len(samples[ 0, :]):
           result [:, i-1 : i] = np.row_stack(S0 * np.prod(1 + r * delta  + sigma * sqrt(delta) * stats.norm.ppf(samples[:, 0 : i]) + 0.5 * sigma * det * delta * ((stats.norm.ppf(samples[:, 0 : i])) ** 2 - 1), axis=1))
           i = i + 1
           if i == len(samples[ 0, :]) + 1:
               return result


tt = [1, 3, 6, 12, 24, 36, 60]
rateCurve = [0.27, 0.33, 0.47, 0.6, 0.78, 0.91, 1.18]
t = np.arange(1./250, 1+1./250, 1./250)
samples = random.rand(1000, len(t))


stockprice0 = MCStockPrices(100., 0.2, rateCurve, t , samples, integrator = 'standard')
stockprice1 = MCStockPrices(100., 0.2, rateCurve, t, samples, integrator='euler')
stockprice2 = MCStockPrices(100., 0.2, rateCurve, t, samples, integrator='milstein')

print stockprice0
print stockprice1
print stockprice2
