from numpy import exp, sqrt, max, mean, std, log, cumsum, min
import Bisect
from Bisect import bisect
import BS
from BS import bsformula
import matplotlib.pyplot as plt
import numpy as np
from numpy import __version__
from matplotlib import __version__

def newton(f, df, x, tol=0.0001, maxiter=1000):
    n = 1
    BS.c = 0
    series = []
    while n < maxiter:
        if df(x)!=0:
            x1 = x - f(x) / df(x)
            series.append(x1)
        if abs(x1 - x) < tol:
            return series
        else:
            x = x1
            n += 1
    return series

def bsimpvol(callput, S0, K, r, T, price, method, q=0.,
      priceTolerance=0.01, reportCalls=True):
    root = []
    if method == 'bisect':
        value = lambda x: bsformula(callput, S0, K, r, T, x, 0)[1]
        root = bisect(target=price, targetfunction=value, start=0.05, bounds=None, tols=priceTolerance,
                                  maxiter=1000)
        if value(root[-1]) <= callput * (S0 - K) or S0 == 'NaN' or K == 'NaN' or r == 'NaN' or T == 'NaN' or price == 'NaN' or callput == 'NaN' or method == 'NaN' or q == 'NaN' or priceTolerance == 'NaN' :
            raise ValueError("NaN")
        if reportCalls == True:
            return root, BS.c
        elif reportCalls == False:
            return root[-1]


    elif method == 'newton':
        value = lambda x: bsformula(callput, S0, K, r, T, x, 0)[1] - price
        dvalue = lambda x: bsformula(callput, S0, K, r, T, x, 0)[5]
        root = newton(f=value, df=dvalue, x=0.05, tol=0.01, maxiter=1000)

        if value(root[-1]) <= callput * (
            S0 - K) or S0 == 'NaN' or K == 'NaN' or r == 'NaN' or T == 'NaN' or price == 'NaN' or callput == 'NaN' or method == 'NaN' or q == 'NaN' or priceTolerance == 'NaN':
            raise ValueError("NaN")
        if reportCalls == True:
            return root, BS.c
        elif reportCalls == False:
            return root[-1]


print(bsimpvol(1, 100, 105, 0.01, 1, 6.297254, q=0, priceTolerance=0.0001, method='bisect', reportCalls = True))

print(bsimpvol(1, 100, 105, 0.01, 1, 6.297254, q=0, priceTolerance=0.0001, method='newton', reportCalls = True))







