import numpy as np            
import pandas as pd
from sklearn import tree      
from sklearn import ensemble  
from sklearn.model_selection import cross_val_score  



df = pd.read_csv('datanumbers.csv', header=0)   
df.head()                                 
df.info()                                 


X_all = df.iloc[:,0:64].values        
y_all = df[ '64' ].values      

indices = np.random.permutation(len(X_all)) 
X_data_full = X_all[indices]
y_data_full = y_all[indices] 

X_train = X_data_full
y_train = y_data_full


for max_depth in [4]:
   
    dtree = tree.DecisionTreeClassifier(max_depth=max_depth)

    dtree = dtree.fit(X_train, y_train) 

    filename = 'tree' + str(max_depth) + '.dot'
    tree.export_graphviz(dtree, out_file=filename, rotate=False, leaves_parallel=True )  

    scores = cross_val_score(dtree, X_train, y_train, cv=5)
    average_cv_score = scores.mean()
  


MAX_DEPTH = 4   


dtree = tree.DecisionTreeClassifier(max_depth=MAX_DEPTH)
dtree = dtree.fit(X_train, y_train) 

X_unlabeled = X_all[:21]
predicted_labels = dtree.predict(X_unlabeled)
answer_labels = answers

s = "{0:<11} | {1:<11}".format("Predicted","Answer")

print(s)
s = "{0:<11} | {1:<11}".format("-------","-------")
print(s)

for p, a in zip( predicted_labels, answer_labels ):
    s = "{0:<11} | {1:<11}".format(p,a)
    print(s)


print("important features\n      ", dtree.feature_importances_) 

# Random Forest
for m in range(2,6):
    for n in (50,300,100):
        rforest = ensemble.RandomForestClassifier(max_depth=m, n_estimators=n)

        scores = cross_val_score(rforest, X_train, y_train, cv=5)
        print(m)
        print(n)
        print("CV scores:", scores)
        print("Average of CV scores:", scores.mean())


MAX_DEPTH = 5
NUM_TREES = 300
print()
print("Using MAX_DEPTH=", MAX_DEPTH, "and NUM_TREES=", NUM_TREES)
rforest = ensemble.RandomForestClassifier(max_depth=MAX_DEPTH, n_estimators=NUM_TREES)
rforest = rforest.fit(X_train, y_train) 

X_unlabeled = X_all[:21]
print("Random-forest predictions:\n")
predicted_labels = rforest.predict(X_unlabeled)
answer_labels = answers 


s = "{0:<11} | {1:<11}".format("Predicted","Answer")

print(s)
s = "{0:<11} | {1:<11}".format("-------","-------")
print(s)

for p, a in zip( predicted_labels, answer_labels ):
    s = "{0:<11} | {1:<11}".format(p,a)
    print(s)


print("\nrandom forest important features\n      ", rforest.feature_importances_) 
