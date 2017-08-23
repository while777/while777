""" Price a callable zero coupon bond by the Vasicek model """
import math
import numpy as np
import scipy.stats as st


class VasicekCZCB:
    def __init__(self):
        self.norminv = st.distributions.norm.ppf
        self.norm = st.distributions.norm.cdf

    def vasicek_czcb_values(self, r0, R, ratio, T, sigma, kappa,
                            theta, M, prob=1e-5,
                            max_policy_iter=20,
                            grid_struct_const=0.2, rs = None):
        r_min, dr, N, dtau = self.vasicek_params(r0, M, sigma, kappa, theta, T, prob, grid_struct_const, rs)

        r = np.r_[0:N] * dr + r_min
        v_mplus1 = np.ones(N)

        for i in range(1, M + 1):
            K = self.exercise_call_price(R, ratio, i * dtau)
            eex = np.ones(N) * K

            # Get diagonals of M1
            subdiagonal_M1, diagonal_M1, superdiagonal_M1 = self.vasicek_diagonals_M1(sigma, kappa, theta,
                                          r_min, dr, N, dtau)
            # Get diagonals of M2
            subdiagonal_M2, diagonal_M2, superdiagonal_M2= self.vasicek_diagonals_M2(sigma, kappa, theta,
                                          r_min, dr, N, dtau)
            v_mplus1 = self.iterate(subdiagonal_M1, diagonal_M1, superdiagonal_M1, subdiagonal_M2, diagonal_M2, superdiagonal_M2,  v_mplus1, eex, max_policy_iter)

        return r, v_mplus1

    def vasicek_params(self, r0, M, sigma, kappa, theta, T,
                       prob, grid_struct_const = 0.2, rs = None):
        (r_min, r_max) = (rs[0], rs[-1]) if not rs is None \
            else self.vasicek_limits(r0, sigma, kappa,
                                     theta, T, prob)
        dt = T / float(M)
        N = self.calculate_N(grid_struct_const, dt,
                             sigma, r_max, r_min)
        dr = (r_max - r_min) / (N -1)
        return r_min, dr, N, dt

    def calculate_N(self, max_structure_const, dt,
                    sigma, r_max, r_min):
        N = 0
        while True:
            N += 1
            grid_structure_interval = dt * (sigma ** 2) / (
                ((r_max - r_min) / float(N)) ** 2)
            if grid_structure_interval > max_structure_const:
                break

        return N

    def vasicek_limits(self, r0, sigma, kappa,
                       theta, T, prob=1e-5):
        er = theta + (r0 - theta) * math.exp(-kappa * T)
        variance = (sigma ** 2) * T if kappa == 0 else \
            (sigma ** 2) / (2 * kappa) * (1 - math.exp(-2 * kappa * T))
        stdev = math.sqrt(variance)
        r_min = self.norminv(prob, er, stdev)
        r_max = self.norminv(1 - prob, er, stdev)
        return r_min, r_max


    def vasicek_diagonals_M1(self, sigma, kappa, theta,
                          r_min, dr, N, dtau):
        rn = np.r_[0:N] * dr + r_min
        subdiagonals_M1 = kappa * (theta - rn) * dtau / (2 * dr) - 0.5 * (sigma ** 2) * dtau / (dr ** 2)
        diagonals_M1 = 2 + rn * dtau + (sigma ** 2) * dtau / (dr ** 2)
        superdiagonals_M1 = -kappa * (theta - rn) * dtau / (2 * dr) - 0.5 * (sigma ** 2) * dtau / (dr ** 2)

        # Implement boundary conditions.
        if N > 0:
            v_subd0 = subdiagonals_M1[0]
            superdiagonals_M1[0] = superdiagonals_M1[0] - subdiagonals_M1[0]
            diagonals_M1[0] += 2 * v_subd0
            subdiagonals_M1[0] = 0

        if N > 1:
            v_superd_last = superdiagonals_M1[-1]
            superdiagonals_M1[-1] = superdiagonals_M1[-1] - subdiagonals_M1[-1]
            diagonals_M1[-1] += 2 * v_superd_last
            subdiagonals_M1[-1] = 0

        return subdiagonals_M1, diagonals_M1, superdiagonals_M1

    def vasicek_diagonals_M2(self, sigma, kappa, theta,
                             r_min, dr, N, dtau):
        rn = np.r_[0:N] * dr + r_min                        #0----N-1   cause   R 1-----N
        subdiagonals_M2 = - kappa * (theta - rn) * dtau / (2 * dr) + 0.5 * (sigma ** 2) * dtau / (dr ** 2)
        diagonals_M2 = 2 - rn * dtau - (sigma ** 2) * dtau / (dr ** 2)
        superdiagonals_M2 = kappa * (theta - rn) * dtau / (2 * dr) + 0.5 * (sigma ** 2) * dtau / ( dr ** 2)


        # Implement boundary conditions.
        if N > 0:
            v_subd0 = subdiagonals_M2[0]
            superdiagonals_M2[0] = superdiagonals_M2[0] - subdiagonals_M2[0]
            diagonals_M2[0] += 2 * v_subd0
            subdiagonals_M2[0] = 0

        if N > 1:
            v_superd_last = superdiagonals_M2[-1]
            superdiagonals_M2[-1] = superdiagonals_M2[-1] - subdiagonals_M2[-1]
            diagonals_M2[-1] += 2 * v_superd_last
            subdiagonals_M2[-1] = 0


        return subdiagonals_M2, diagonals_M2, superdiagonals_M2

    def check_exercise(self, V, eex):
        return V > eex

    def exercise_call_price(self, R, ratio, tau):
        K = ratio * np.exp(-R * tau)
        return K

    def vasicek_policy_diagonals(self, subdiagonal, diagonal,
                                 superdiagonal, v_old, v_new,
                                 eex):
        has_early_exercise = self.check_exercise(v_new, eex)
        subdiagonal[has_early_exercise] = 0
        superdiagonal[has_early_exercise] = 0
        policy = v_old / eex
        policy_values = policy[has_early_exercise]
        diagonal[has_early_exercise] = policy_values
        return subdiagonal, diagonal, superdiagonal

    # modify iterate to accept six diagonals, three for M1 and three for M2
    def iterate(self, subdiagonal_M1, diagonal_M1, superdiagonal_M1, subdiagonal_M2, diagonal_M2, superdiagonal_M2,
                v_old, eex, max_policy_iter=20):
        v_mplus1 = v_old
        v_m = v_old
        change = np.zeros(len(v_old))
        prev_changes = np.zeros(len(v_old))

        iterations = 0
        while iterations <= max_policy_iter:
            iterations += 1
            M2 = np.diag(subdiagonal_M2[1 : np.size(diagonal_M2)], -1) + np.diag(diagonal_M2, 0) + np.diag(superdiagonal_M2[0 : -1], 1)
            v_mplus1 = self.tridiagonal_solve(subdiagonal_M1,
                                              diagonal_M1,
                                              superdiagonal_M1,
                                              np.sum(M2 * v_old, 1))

            subdiagonal_M1, diagonal_M1, superdiagonal_M1 = self.vasicek_policy_diagonals(subdiagonal_M1, diagonal_M1, superdiagonal_M1, v_old, v_mplus1, eex)

            is_eex = self.check_exercise(v_mplus1, eex)
            change[is_eex] = 1

            if iterations > 1:
                change[v_mplus1 != v_m] = 1

            is_no_more_eex = False if True in is_eex else True
            if is_no_more_eex:
                break

            v_mplus1[is_eex] = eex[is_eex]
            changes = (change == prev_changes)

            is_no_further_changes = all((x == 1) for x in changes)
            if is_no_further_changes:
                break

            prev_changes = change
            v_m = v_mplus1

        return v_mplus1

    def tridiagonal_solve(self, a, b, c, d):
        nf = len(a)
        ac, bc, cc, dc = \
            map(np.array, (a, b, c, d))  # Copy the array
        for it in xrange(1, nf):
            mc = ac[it] / bc[it - 1]
            bc[it] = bc[it] - mc * cc[it - 1]
            dc[it] = dc[it] - mc * dc[it - 1]

        xc = ac
        xc[-1] = dc[-1] / bc[-1]

        for il in xrange(nf - 2, -1, -1):
            xc[il] = (dc[il] - cc[il] * xc[il + 1]) / bc[il]

        del bc, cc, dc  # Delete variables from memory

        return xc


if __name__ == "__main__":

    import matplotlib.pyplot as plt

    r0 = 0.05
    R = 0.01
    ratio = 0.95
    sigma = 0.03
    kappa = 0.15
    theta = 0.05

    prob = 1e-6
    M = 250
    max_policy_iter = 20
    grid_struct_const = 0.2
    rs = np.r_[0.0: 2 : 0.1]

    Vasicek = VasicekCZCB()

    plt.title("Callable Zero Coupon Bond Values against r")

    for T in [1., 5., 7., 10., 20.]:
        r, vals = Vasicek.vasicek_czcb_values(r0, R, ratio, T, sigma, kappa,
                                              theta, M, prob,
                                              max_policy_iter,
                                              grid_struct_const,
                                              rs)

        plt.plot(r, vals, label=str(T) + ' yr',
                 linestyle="--", marker=".")

    plt.ylabel("Value ($)")
    plt.xlabel("r")
    plt.legend()
    plt.grid(True)
    plt.show()


