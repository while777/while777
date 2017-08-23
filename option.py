from numpy import *

global r0
class Option:
    def __init__(self, strike, maturity, bid, ask, underlying, typ, vol=0):
        self.bid = bid
        self.ask = ask
        self.maturity = maturity
        self.underlying = underlying
        self.strike = strike
        self.vol = vol
        self.typ = typ

    def getMidPrice(self):
        return 0.5 * (self.bid + self.ask)

    def dump(self):
        return str(self.bid) + "," + str(self.ask) + "," + str(self.strike) + "," + str(self.maturity) + "," + str(
            self.underlying) + "," + str(self.typ) + "," + str(self.vol)