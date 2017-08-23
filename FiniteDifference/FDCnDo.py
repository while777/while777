import numpy as np
from NI import FDCnEu

class FDCnDo (FDCnEu):
    def __init__(self, callput, S0, K, r, T, sigma, Sbarrier, S_max, M, N):

        super(FDCnDo, self).__init__(callput, S0, K, r, T, sigma, S_max, M, N)

        self. dS = (S_max - Sbarrier) / float (self. M)
        self. boundary_conds = np.linspace(Sbarrier, S_max, self.M + 1)
        self. i_values = float(self.boundary_conds)/self. dS
