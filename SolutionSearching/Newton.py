from math import log,exp,sqrt
from numpy import maximum,cumsum,mean
from scipy import stats

def newton(f, df, x, tol=0.0001, maxiter=1000):
    n = 1
    while n < maxiter:
        if df(x)!=0:
            x1 = x - f(x)/df(x)
        if abs(x1 - x)<tol:
            return x1, n
        else:
            x = x1
            n += 1
    return x, n
y=lambda x: x - x ** 2
dy=lambda x: 1 - 2 * x
root, iterations=newton(y, dy, 10, 0.0001, 1000)
print(root, iterations)


