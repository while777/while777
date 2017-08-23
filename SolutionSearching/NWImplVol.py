from numpy import exp, sqrt, max, mean, std, log, cumsum, min
from Newton import newton
from scipy import stats
def Bsimpvol(v, S0, K, r, T, q=0):
      value = lambda x: v - (S0 * stats.norm.cdf((log(S0)-log(K) + (r + 0.5 * x ** 2) * T) / (x * sqrt(T))) - K * exp(-r * T) * stats.norm.cdf((log(S0)-log(K) + (r - 0.5 * x ** 2) * T) / (x * sqrt(T))))
      dvalue = lambda x: - (S0 * stats.norm.pdf(log(S0) - log(K) + (r + 0.5 * x ** 2) * T)/(x * sqrt(T)) * ((-1/(T * x ** 2) * (log(S0)-log(K))-r * sqrt(T) / x ** 2) + 0.5 * sqrt(T)) - K * exp(-r * T) * (-1 / (T * x ** 2) * (log(S0)-log(K))-r * sqrt(T)/x ** 2-0.5 * sqrt(T)) * stats.norm.pdf((log(S0)-log(K) + (r - 0.5 * x ** 2) * T)/(x * sqrt(T))))
      root, iterations = newton(value, dvalue, 1, 0.0001, 1000)
      tuple = ('root', root, 'iterations', iterations)
      return tuple

print(Bsimpvol(3, 100, 105, 0.01, 1, 0))

