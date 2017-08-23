import csv
from random import seed
from random import randrange
from math import sqrt
from algorithm_accuracy import algorithm_accuracy
from build_tree import build_tree
from bagging_predict import bagging_predict
import numpy as np

def load_csv(filename):

    file = open(filename)
    reader = csv.reader(file)
    data = list(reader)
    return data



filename = 'wine.csv'
data = load_csv(filename)
seed(1000)


def subsample(data, ratio): #ratio = sample_size = 1
   sample = list()
   n_sample = round(len(data) * ratio) #len(data)=178
   while len(sample) < n_sample:
       index = randrange(len(data)) # random number 0-178
       sample.append(data[index])
   return sample #178 data with replacement,   # Create a random subsample from the dataset with replacement



# Random Forest Algorithm
def random_forest(data, test, n_nodes, min_pattern, sample_size, n_trees, n_features):
   trees = list()
   for i in range(n_trees):
       sample = subsample(data, sample_size)
       tree = build_tree(data,sample, n_nodes, min_pattern, n_features)
       trees.append(tree)
   predictions = [bagging_predict(trees, row) for row in test]
   return(predictions)


# evaluate algorithm
n_bags = 5
bag_size = int(0.7*len(data))
n_nodes = 6
min_pattern = 1
sample_size = 1
n_features = int(sqrt(len(data[0])-1)) #len(data[0])-1 = 13, n_features = 3
n_accuracy = []
for n_trees in [1,2,3,4,5,6,7,8,9,10]:
   accuracy = algorithm_accuracy(data, random_forest, n_bags, bag_size, n_nodes, min_pattern, sample_size, n_trees, n_features)
   mean_accuracy = (sum(accuracy)/float(len(accuracy)))
   print('Trees: %d' % n_trees)
   print('Scores: %s' % accuracy)
   print('Mean Accuracy: %.3f%%' % mean_accuracy)
   n_accuracy .append(mean_accuracy)
   






