def bagging_predict(trees, row):
# predict bagged trees

    # predict a tree
    def predict_tree(node, row):
       if row[node['index']] < node['value']:
           if isinstance(node['left'], dict):
               return predict_tree(node['left'], row)
           else:
               return node['left']
       else:
           if isinstance(node['right'], dict):
               return predict_tree(node['right'], row)
           else:
               return node['right']

    predictions = [predict_tree(tree, row) for tree in trees]
    return max(set(predictions), key=predictions.count)