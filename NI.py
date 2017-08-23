import numpy as np
from explicit import FDExplicitEU
from scipy import linalg

class FDCnEu(FDExplicitEU):

    def _setup_coefficients_(self):
        self.alpha = 0.25 * self.dt * (
            (self.sigma ** 2) * (self.i_values ** 2) -
            self.r * self.i_values)
        self.beta = -self.dt * 0.5 * (
            (self.sigma ** 2) * (self.i_values ** 2) +
            self.r)
        self.gamma = 0.25 * self.dt * (
            (self.sigma ** 2) * (self.i_values ** 2) +
            self.r * self.i_values)
                   #0---M

        self.M1 = -np.diag(self.alpha[2:self.M], -1) + np.diag(1-self.beta[1:self.M], 0) - np.diag(self.gamma[1:self.M-1], 1)

        self.M2 =  np.diag(self.alpha[2:self.M], -1) + np.diag(1+self.beta[1:self.M], 0) + np.diag(self.gamma[1:self.M-1], 1)

    def _traverse_grid_(self):
        """ Solve using linear systems of equations """
        P, L, U = linalg.lu(self.M1)

        for j in reversed(range(self.N)):
            y = linalg.solve(L,
                              np.dot(self.M2,
                                     self.grid[1:self.M-1, j+1]))     # 1---N
            x = linalg.solve(U, y)
            self.grid[1:self.M, j] = x
