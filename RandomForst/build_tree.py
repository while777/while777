from random import randrange

def build_tree(data, train, n_nodes, min_pattern, n_features):
    def test_split(index, value, data): #test_split(index, row[index], data) ,index in features
       left, right = list(), list()
       for row in data:
           if row[index] < value:
               left.append(row)
           else:
               right.append(row)
       return left, right


    def splitcost(groups, outputs):
       gini = 0.0
       for output in outputs:
           for group in groups:
               size = len(group)
               if size == 0:
                   continue
               proportion = [row[-1] for row in group].count(output) / float(size)
               gini += (proportion * (1.0 - proportion))
       return gini

    # Select the best split point for a data
    def best_split(data, n_features):
       outputs = list(set(row[-1] for row in data)) # 1,2,3
       b_index, b_value, b_score, b_groups = 999, 999, 999, None
       features = list()
       # choose 3 features from 13 features
       while len(features) < n_features:
           index = randrange(1,len(data[0])-1)
           if index not in features:
               features.append(index) # features are No. value of feature like 1,4,...
       for index in features:
           for row in data:
               groups = test_split(index, row[index], data) #left and right
               gini = splitcost(groups, outputs)
               if gini < b_score:
                   b_index, b_value, b_score, b_groups = index, row[index], gini, groups
       return {'index':b_index, 'value':b_value, 'groups':b_groups}



    # Create a terminal node value
    def to_terminal(group):
       outcomes = [row[-1] for row in group]
       return max(set(outcomes), key=outcomes.count)

    # Create child splits for a node or make terminal
    def split(node, n_nodes, min_pattern, n_features, depth):
       left, right = node['groups']
       del(node['groups'])
       # check for a no split
       if not left or not right:
           node['left'] = node['right'] = to_terminal(left + right)
           return
       # check for max depth
       if depth >= n_nodes:
           node['left'], node['right'] = to_terminal(left), to_terminal(right)
           return
       # process left child
       if len(left) <= min_pattern:
           node['left'] = to_terminal(left)
       else:
           node['left'] = best_split(left, n_features)
           split(node['left'], n_nodes, min_pattern, n_features, depth+1)
       # process right child
       if len(right) <= min_pattern:
           node['right'] = to_terminal(right)
       else:
           node['right'] = best_split(right, n_features)
           split(node['right'], n_nodes, min_pattern, n_features, depth+1)

    root = best_split(data, n_features)
    split(root, n_nodes, min_pattern, n_features, 1)
    return root



