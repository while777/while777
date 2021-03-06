import numpy as np
import sys

from NI import FDCnEu

class FDCnAm (FDCnEu):
    def __init__(self,  S0, K, r, T, sigma, S_max, M, N, tol, callput=1):
        super(FDCnAm, self). __init__(S0, K, r, T, sigma, S_max, M, N, callput)
        self.tol = tol
        self.i_values = np.arange(self.M + 1)
        self.j_values = np.arange(self.N + 1)

    def  _setup_boundary_conditions_(self):
        if self.callput == 1:
            self.payoffs = np.maximum(self.boundary_conds[1: self.M] - self.K, 0)
            self.boundary_values = 0 * np.exp(-self.r * self.dt * (self.N - self.j_values))  # 0-N

        else:
            self. payoffs = np.maximum(self.K - self.boundary_conds[1: self.M], 0)       #0---M    changed to 1---M
            self.boundary_values = self.K * np.exp(-self.r * self.dt * (self.N - self.j_values))  # 0-N

        self.past_values = self.payoffs


    def _traverse_grid_(self):
        aux = np.zeros(self.M-1)
        new_values = np.zeros(self.M-1)

        for j in reversed(range( self.N)):
            aux[0] = self.alpha[1] * ( self.boundary_values[j] + self.boundary_values[j +1] )     #0---N

            rhs = np.dot(self.M2, self.past_values) + aux
            old_values = np.copy(self.past_values)

            error = sys. float_info.max
            while self.tol < error:
                new_values[0] = max(self.payoffs[0], old_values[0] + (1.0 / (1 - self.beta[1])) * (rhs[0] - (1 - self.beta[1]) * old_values[0] + (self.gamma[1] * old_values[1])))       # alpha 1---M

                for k in range(self.M - 2)[1:]:
                    new_values[k] = max(self.payoffs[k], old_values[k] + (1.0 / (1 - self.beta[k + 1])) * (rhs[k] + self.alpha[k + 1] * new_values[k - 1] - (1 - self.beta[1]) * old_values[k] + self.gamma[k + 1] * old_values[k + 1]))

                new_values[-1] = max(self.payoffs[-1], old_values[-1] + (1.0 / (1 - self.beta[-2])) * (rhs[-1] + self.alpha[-2] * new_values[-2] - (1 - self.beta[-2]) * old_values[-1]))      # M

                error = np.linalg.norm(new_values- old_values)
                old_values = np.copy(new_values)
            self.past_values = np.copy(new_values)
        self.values = np. concatenate(( [self.boundary_values[0]], new_values, [0]))

    def _interpolate_(self):
        return np.interp(self.S0, self.boundary_conds, self.values)


if __name__ == "__main__":
    from FDCnDo import FDCnDo
    option = FDCnAm(50, 50, 0.1, 5./12., 0.4, 100, 100, 100, 0.001, 1)
    print option.price()

    option = FDCnAm(50, 50, 0.1, 5./12., 0.4, 100, 100, 100, 0.001, -1)
    print option.price()

    