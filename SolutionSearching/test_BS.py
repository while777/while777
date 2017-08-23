import numpy as np
from win32com import client
from BS import bsformula
import unittest

def execute_matlab_command(command):
    matlab = client. Dispatch("matlab.Application")
    ret = matlab.Execute(command)
    print ret

execute_matlab_command(
    "[call0, put0] = blsprice(100, 105, 0.01, 1, 0.2, 0)")

execute_matlab_command(
    "[call1, put1] = blsdelta(100, 105, 0.01, 1, 0.2, 0)")

execute_matlab_command("vega = blsvega(100, 105, 0.01, 1, 0.2, 0)")



class Bsm_call_put_valueTestCase(unittest. TestCase):
    def testvalue(self):
        self.assertEqual(abs(bsformula(1, 100, 105, 0.01, 1, 0.2, 0)[1]) - 6.2973 < 0.001, True)
    def testdelta(self):
        self.assertEqual(abs(bsformula(1, 100, 105, 0.01, 1, 0.2, 0)[3]) - 0.4626 < 0.001, True)
    def testvega(self):
        self.assertEqual(abs(bsformula(1, 100, 105, 0.01, 1, 0.2, 0)[5]) - 39.7185 < 0.001,  True)
    def testvalue1(self):
        self.assertEqual(abs(bsformula(-1, 100, 105, 0.01, 1, 0.2, 0)[1]) - 10.2525 < 0.001, True)
    def testdelta1(self):
        self.assertEqual(abs(bsformula(-1, 100, 105, 0.01, 1, 0.2, 0)[3]) - 0.5374 < 0.001, True)
    def testvega1(self):
        self.assertEqual(abs(bsformula(-1, 100, 105, 0.01, 1, 0.2, 0)[5]) - 39.7185 < 0.001,  True)

if __name__== '__main__':
    unittest. main()


