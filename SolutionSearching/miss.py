

value = lambda x: K * exp(-r * T) * stats.norm.cdf(-(log(S0) - log(K) + (r - 0.5 * x ** 2) * T) / (x * sqrt(T))) - S0 * exp(-q * T) * stats.norm.cdf(-(log(S0) - log(K) + (r + 0.5 * x ** 2) * T) / (x * sqrt(T)))



exp(-q * T) * S0 * stats.norm.cdf((log(S0)- log(K) + (r + 0.5 * x ** 2) * T) / (x * sqrt(T))) - K * exp(-r * T) * stats.norm.cdf((log(S0)- log(K) + (r - 0.5 * x ** 2) * T) / (x * sqrt(T)))


#using matlab to test the results for function bsformula

from numpy import exp, sqrt, max, mean, std, log, cumsum, min
from numpy.random import randn, rand
import numpy as np

def bisect(target, targetfunction, start=None, bounds=None, tols = 0.001, maxiter=1000):
    cps = 0.01
    eps = 6
    if bounds is None and start is None:
        raise ValueError("NoneError")

    elif not start is None and bounds is None:
        i = 1
        while i < maxiter:
            bound=[]
            bound.append(start - i * eps)
            bound.append(start + i * eps)
            if (targetfunction(bound[0]) - target) * (targetfunction(bound[1]) - target) <= 0:
                n = 1
                medium = (bound[1] + bound[0]) * 0.5
                while n < maxiter:
                    medium = (bound[1] + bound[0]) * 0.5
                    if targetfunction(medium) == target or abs(bound[1] - bound[0]) * 0.5 < tols:
                        return medium, n
                    else:
                        n = n + 1
                        if targetfunction(bound[1]) > target:
                            if (targetfunction(medium)) < target:
                                bound[0] = medium
                            else:
                                bound[1] = medium
                        elif targetfunction(bound[1]) < target:
                            if (targetfunction(medium)) < target:
                                bound[1] = medium
                            else:
                                bound[0] = medium
                return medium, n
            elif (targetfunction(bound[0]) - target) * (targetfunction(bound[1]) - target) > 0:
                grid = np.arange(bound[0], bound[1], cps)
                num = (bound[1] - bound[0]) / cps
                Max = max(targetfunction(grid))
                Min = min(targetfunction(grid))
                if (Max-target) * (Min-target) < 0:
                    count = 1
                    while count < num:
                        if (targetfunction(bound[0] + count * cps) - target) * (targetfunction(bound[0] - target) < 0):
                            bound[0] = bound[0] + count * cps
                            return bound[0]
                        else:
                            count += 1
                    n = 1
                    medium = (bound[1] + bound[0]) * 0.5
                    while n < maxiter:
                        medium = (bound[1] + bound[0]) * 0.5
                        if targetfunction(medium) == target or abs(bound[1] - bound[0]) * 0.5 < tols:
                            return medium, n
                        else:
                            n = n + 1
                            if targetfunction(bound[1]) > target:
                                if (targetfunction(medium)) < target:
                                    bound[0] = medium
                                else:
                                    bound[1] = medium
                            elif targetfunction(bound[1]) < target:
                                if (targetfunction(medium)) < target:
                                    bound[1] = medium
                                else:
                                    bound[0] = medium
                else:
                    i = i + 1
        if i == maxiter + 1:
            raise StopIteration("can not find solutions")

    elif start is None and not bounds is None:
        if (targetfunction(bounds[0]) - target) * (targetfunction(bounds[1]) - target) <= 0:
            n = 1
            medium = (bounds[1] + bounds[0]) * 0.5
            while n < maxiter:
                medium = (bounds[1] + bounds[0]) * 0.5
                if targetfunction(medium) == target or abs(bounds[1] - bounds[0]) * 0.5 < tols:
                    return medium, n
                else:
                    n = n + 1
                    if targetfunction(bounds[1]) > target:
                        if (targetfunction(medium)) < target:
                            bounds[0] = medium
                        else:
                            bounds[1] = medium
                    elif targetfunction(bounds[1]) < target:
                        if (targetfunction(medium)) < target:
                            bounds[1] = medium
                        else:
                            bounds[0] = medium
            return medium, n
        elif (targetfunction(bounds[0]) - target) * (targetfunction(bounds[1]) - target) > 0:
            grid = np.arange(bounds[0], bounds[1], cps)
            num = (bounds[1] - bounds[0]) / cps
            Max = max(targetfunction(grid))
            Min = min(targetfunction(grid))
            if Max * Min < 0:
                count = 1
                while count < num:
                    if (targetfunction(bounds[0] + count * cps) - target) * (targetfunction(bounds[0] - target) < 0):
                        bounds[0] = bounds[0] + count * cps
                        return bounds[0]
                    else:
                        count += 1
                n = 1
                medium = (bounds[1] + bounds[0]) * 0.5
                while n < maxiter:
                    medium = (bounds[1] + bounds[0]) * 0.5
                    if targetfunction(medium) == target or abs(bounds[1] - bounds[0]) * 0.5 < tols:
                        return medium, n
                    else:
                        n = n + 1
                        if targetfunction(bounds[1]) > target:
                            if (targetfunction(medium)) < target:
                                bounds[0] = medium
                            else:
                                bounds[1] = medium
                        elif targetfunction(bounds[1]) < target:
                            if (targetfunction(medium)) < target:
                                bounds[1] = medium
                            else:
                                bounds[0] = medium
                return medium, n

            else:
                print("no solution for this bounds")

if __name__=="__main__":
    f= lambda x: x ** 2 + x * 4 - 5
    print(bisect(target = 0, targetfunction= f, start = -6, bounds = None, tols = 0.001, maxiter = 1000))



from numpy import exp, sqrt, max, mean, std, log, cumsum, min
from Bisect import bisect
from scipy import stats
from BS import bsm_call_put_value
def bsimpvol_call(call, S0, K, r, T, price, q=0.,
      priceTolerance=0.01, method='bisect', reportCalls=False):
    value = lambda x:  bsm_call_put_value(100, 105, 0.01, 1, x, -1, 0, 0 )[1]
    root, iterations = bisect(target=price, targetfunction=value, start = 0.05, bounds = None, tols=priceTolerance, maxiter = 1000)
    tuple = ('root', root, 'iterations', iterations)
    reportCalls = True
    if value(root) <= S0 - K or S0 == 'NaN' or K == 'NaN' or r == 'NaN' or T == 'NaN':
        raise ValueError("NaN")
    if reportCalls== True:
        return tuple
    elif reportCalls==False:
        return root

def bsimpvol_put(put, S0, K, r, T, price, q=0.,
      priceTolerance=0.01, method='bisect', reportCalls=False):
    value = lambda x:  bsm_call_put_value(105, 100, 0.01, 1, x, 0, -1, 0 )[1]
    root, iterations = bisect(target=price, targetfunction=value, start = 0.05, bounds = None, tols=priceTolerance, maxiter = 1000)
    tuple = ('root', root, 'iterations', iterations)
    reportCalls = True
    if value(root) <= K - S0 or S0 == 'NaN' or K == 'NaN' or r == 'NaN' or T == 'NaN':
        raise ValueError("NaN")
    if reportCalls== True:
        return tuple
    elif reportCalls==False:
        return root

print(bsimpvol_call(1, 100, 105, 0.01, 1, 3.5, q=0, priceTolerance=0.0001, method='bisect', reportCalls=False))

print(bsimpvol_put(-1, 105, 100, 0.01, 1, 3 , q=0, priceTolerance=0.0001, method='bisect', reportCalls=False))














