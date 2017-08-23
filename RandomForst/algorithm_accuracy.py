from random import randint
from math import sqrt


def algorithm_accuracy(data, algorithm, n_bags, bag_size, *args):
    #implement bagging, choosing n_bags sets for n tree and for each bag choosing bag_size data without replacement
    def bagging_choose(data, n_bags, bag_size):
       bags = list()
       lefts = list()

       for i in range(0,n_bags): #n_bags = 5
           bag = list()
           data_replica = list(data)
           while len(bag) <bag_size: #0.8*178
               j = randint(1,len(data_replica)) #random 1-178
               bag.append(data_replica[j-1])
               data_replica.pop(j-1)
           left  = data_replica
           lefts.append(left)
           bags.append(bag)

       return bags, lefts # 5 bags, each bag has 0.8*178 data


    # Calculate accuracy percentage
    def accuracy_metric(actual, predicted):
       correct = 0
       for i in range(len(actual)):
           if actual[i] == predicted[i]:
               correct += 1
       return correct / float(len(actual)) * 100.0

    # Evaluate an algorithm using bagging
    def evaluate_bagging(data, algorithm, n_bags,bag_size, *args):
        bags = bagging_choose(data, n_bags, bag_size)[0]
        lefts = bagging_choose(data, n_bags, bag_size)[1]
        scores = list()
        scores = list()
        for index in range(0,n_bags):
            train_set = bags[index]

            test_set = lefts[index]

            predicted = algorithm(train_set, test_set, *args)
            actual = [row[-1] for row in test_set]
            accuracy = accuracy_metric(actual, predicted)
            scores.append(accuracy)
        return scores

    return evaluate_bagging(data, algorithm, n_bags,bag_size, *args)