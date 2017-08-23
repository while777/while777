x = np.linspace(1, 1, len(root))
        y = np.arange[bsformula(callput, 100, 105, 0.01, 1, root[0], 0)[1] - price, bsformula(callput, 100, 105, 0.01, 1, root[0], 0)[1] - price, root.index(root[0]) ]
        plt.plot(x, y, 'or')
        plt.xlabel('diff')
        plt.ylabel('iterations')
        plt.xlim(0.0, 25.0)
        plt.ylim(0.0, 0.05)
        plt.show()



#using matlab to test the results for function bsformula

from numpy import exp, sqrt, max, mean, std, log, cumsum, min
from numpy.random import randn, rand
import numpy as np
import BS
from BS import bsformula

def bisect(target, targetfunction, start=None, bounds=None, tols = 0.001, maxiter=1000):
    BS.amount = 0

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
                series=[]
                medium = (bound[1] + bound[0]) * 0.5
                while n < maxiter:
                    medium = (bound[1] + bound[0]) * 0.5
                    series.append(medium)
                    if targetfunction(medium) == target or abs(bound[1] - bound[0]) * 0.5 < tols:
                        return series, n
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
                return series, n
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
                    series=[]
                    medium = (bound[1] + bound[0]) * 0.5
                    while n < maxiter:
                        medium = (bound[1] + bound[0]) * 0.5
                        series.append(medium)
                        if targetfunction(medium) == target or abs(bound[1] - bound[0]) * 0.5 < tols:
                            return series, n
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
            series = []
            medium = (bounds[1] + bounds[0]) * 0.5
            while n < maxiter:
                medium = (bounds[1] + bounds[0]) * 0.5
                series.append(medium)
                if targetfunction(medium) == target or abs(bounds[1] - bounds[0]) * 0.5 < tols:
                    return series, n
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
            return series, n
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
                series=[]
                medium = (bounds[1] + bounds[0]) * 0.5
                while n < maxiter:
                    medium = (bounds[1] + bounds[0]) * 0.5
                    series.append(medium)
                    if targetfunction(medium) == target or abs(bounds[1] - bounds[0]) * 0.5 < tols:
                        return series, n
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
                return series, n

            else:
                print("no solution for this bounds")

if __name__=="__main__":
    f= lambda x: x ** 2 + x * 4 - 5
    print(bisect(target = 0, targetfunction= f, start = -6, bounds = None, tols = 0.001, maxiter = 1000))





from numpy import exp, sqrt, max, mean, std, log, cumsum, min
from Bisect import bisect
from scipy import stats
from BS import bsformula
import matplotlib.pyplot as plt
import numpy as np
from numpy import __version__
from matplotlib import __version__
import BS
from BS import bsformula

def newton(f, df, x, tol=0.0001, maxiter=1000):
    n = 1
    series = []
    while n < maxiter:
        if df(x)!=0:
            x1 = x - f(x) / df(x)
            series.append(x1)
        if abs(x1 - x) < tol:
            return series, n
        else:
            x = x1
            n += 1
    return series, n

def bsimpvol(callput, S0, K, r, T, price, method, q=0.,
      priceTolerance=0.01, reportCalls=True):
    root = []
    if method == 'bisect':
        value = lambda x: bsformula(callput, S0, K, r, T, x, 0)[1]
        root, iterations = bisect(target=price, targetfunction=value, start=0.05, bounds=None, tols=priceTolerance,
                                  maxiter=1000)
        tuple = ('root', root, 'iterations', iterations)
        if value(root[-1]) <= S0 - K or S0 == 'NaN' or K == 'NaN' or r == 'NaN' or T == 'NaN' or price == 'NaN':
            raise ValueError("NaN")
        if reportCalls == True:
            return tuple
        elif reportCalls == False:
            return root[-1]


    elif method == 'newton':
        value = lambda x: bsformula(callput, S0, K, r, T, x, 0)[1] - price
        dvalue = lambda x: bsformula(callput, S0, K, r, T, x, 0)[5]
        root, iterations = newton(f=value, df=dvalue, x=0.05, tol=0.01, maxiter=1000)
        tuple = ('root', root, 'iterations', iterations)
        if value(root[-1]) <= S0 - K or S0 == 'NaN' or K == 'NaN' or r == 'NaN' or T == 'NaN' or price == 'NaN':
            raise ValueError("NaN")
        if reportCalls == True:
            return tuple
        elif reportCalls == False:
            return root[-1]


print(bsimpvol(1, 100, 105, 0.01, 1, 6.297254, q=0, priceTolerance=0.0001, method='bisect', reportCalls = True))

print(bsimpvol(1, 100, 105, 0.01, 1, 6.297254, q=0, priceTolerance=0.0001, method='newton', reportCalls = True))














