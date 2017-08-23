
from math import log, exp, sqrt
from numpy import maximum, cumsum, mean
from scipy import stats
c = 0
def bsformula(callput, S0, K, r, T, sigma, q=0):

  global c
  c = c + 1

  d1 = (log(S0) - log(K) + (r + 0.5 * sigma ** 2) * T) / (sigma * sqrt(T))
  d2 = (log(S0) - log(K) + (r - 0.5 * sigma ** 2) * T) / (sigma * sqrt(T))
  if callput == 1:
    value =  (S0 * exp( - q * T ) * stats.norm.cdf(d1, 0.0, 1.0) - K * exp( - r * T ) * stats.norm.cdf(d2,0.0,1.0))
    delta = stats.norm.cdf(d1)
    vega =  (S0 * exp( - q * T) * stats.norm.pdf(d1) * (( - 1 / (sqrt(T) * sigma ** 2) * (log(S0) - log(K)) - r * sqrt(T)/sigma ** 2) + 0.5 * sqrt(T)) - K * exp(-r * T) * (-1/(sqrt(T) * sigma ** 2) * (log(S0) - log(K)) - r * sqrt(T) / sigma ** 2 - 0.5 * sqrt(T)) * stats.norm.pdf(d2))

  elif callput == -1:
    value =   K * exp(- r * T) * stats.norm.cdf(-d2, 0.0, 1.0) - S0 * exp(- q * T) * stats.norm.cdf(-d1, 0.0, 1.0)
    delta = -stats.norm.cdf(-d1)
    vega = (- S0 * exp( - q * T) * stats.norm.pdf( - d1) * ((1 / (sqrt(T) * sigma ** 2) * (log(S0) - log(K)) + r * sqrt(T) / sigma ** 2) - 0.5 * sqrt(T)) +  K * exp(-r * T) * (1 / (sqrt(T) * sigma ** 2) * (log(S0) - log(K)) + r * sqrt(T) / sigma ** 2 + 0.5 * sqrt(T)) * stats.norm.pdf(-d2))

  tuple = ('value', value, 'delta', delta, 'vega', vega)
  return tuple

print(bsformula(1, 100, 105, 0.01, 1, 0.2, 0))
print(bsformula(-1, 100, 105, 0.01, 1, 0.2, 0))
