import numpy as np
import pandas as pd
import pandas.io. data as web
import matplotlib.pyplot as plt

df = pd.DataFrame([10, 20, 30, 40], columns=['numbers'],
                  index=['a', 'b', 'c', 'd'])
df['names'] = pd.DataFrame(['Yves', 'Guido', 'Felix', 'Francesc'],
                           index=['d', 'a', 'b', 'c'])

df = df.append(pd.DataFrame({'numbers': 100, 'floats': 5.75,
                             'names': 'Henry'}, index=['z',]))

df = df.join(pd.DataFrame([1, 4, 9, 16, 25],
            index=['a', 'b', 'c', 'd', 'y'],
            columns=['squares',]))

prices = pd.DataFrame([])

symbols = ['AAPL', 'GOOG', 'MSFT','ZNGA','^VIX']
cols = ['r','b','g','y','c']
for symbol in symbols:
  prices[symbol] = web.DataReader(name=symbol, data_source='yahoo', start='2015-1-1')['Adj Close']
print prices.tail(10)

prices.plot(style=cols, lw=2., grid=True)
plt.xlabel('date')
plt.ylabel('Adj. Close Prices')




