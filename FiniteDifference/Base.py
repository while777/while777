import numpy as np
from scipy import stats
from numpy import random
class FiniteDifferences(object):

    def __init__(self, S0, K, r, T, sigma, S_max, M, N, callput):
        self.S0 = S0
        self.K = K
        self.r = self.T = T
        self.sigma = sigma
        self.S_max = S_max
        self.M, self.N = int(M), int(N)
        self.callput = callput
        self.dS = S_max / float(self.M)
        self.dt = T / float(self.N)
        self.i_values = np.arange(self.M)
        self.j_values = np.arange(self.N)
        self.grid = np.zeros(shape=(self.M + 1, self.N + 1))
        self.boundary_conds = np.linspace(0, S_max, self.M + 1)


    def _setup_boundary_conditions_(self):
        if self.callput == 1:
            self.grid[:, -1] = np.maximum(self.boundary_conds + (-self.K), 0)
            self.grid[-1, :-1] = np.maximum(self.S_max - self.K, 0) * \
                                 np.exp(-self.r * self. dt * self. N - self.j_values )
        else:
            self.grid[:, -1] = np.maximum(self.K - self.boundary_conds, 0)
            self.grid[0, :-1] = self.K * \
                                 np.exp(-self.r * self.dt * self.N - self.j_values)

    def _setup_coefficients_(self):
        pass
    def _traverse_grid_(self):
        pass
    def _interpolate_(self):
        return np.interp(self.S0, self.boundary_conds, self.grid[:, 0])
    def price(self):
        self._setup_boundary_conditions_()
        self._setup_coefficients_()
        self._traverse_grid_()
        return self._interpolate_()
    