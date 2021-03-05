import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
import seaborn as sns
from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import f_regression
from sklearn.cluster import KMeans
sns.set()

# Linear Regression showing through Mathplotlib, Seaborn, Statsmodels
data = pd.read_csv('C:/Users/cruel/Desktop/independent study/real_estate_price_size.csv')

data.head()

print(data.describe())

y = data['price']
x1 = data['size']

plt.scatter(x1,y)
plt.xlabel('Size',fontsize=20)
plt.ylabel('Price',fontsize=20)
plt.show()

x = sm.add_constant(x1)
results = sm.OLS(y,x).fit()
print(results.summary())

yhat = x1*223.1787+101900
plt.scatter(x1,y)
fig = plt.plot(x1, yhat, lw=4, c='orange', label ='regression line')
plt.xlabel('Size', fontsize = 20)
plt.ylabel('Price', fontsize = 20)
plt.show()


# Simple Linear Regression SK_Learn

data1 = pd.read_csv('C:/Users/cruel/Desktop/independent study/GPA_SAT.csv')

data1.head()

x_x = data1['SAT']

y_y = data1['GPA']

x_matrix = x_x.values.reshape(-1,1)
print(x_matrix)

print(x_matrix.shape)

reg = LinearRegression()
reg.fit(x_matrix,y_y)

print('score')
print(reg.score(x_matrix,y_y))

print('coefficient')
print(reg.coef_)

print('intercept')
print(reg.intercept_)


new_data1 = pd.DataFrame(data=[1740,1760],columns=['SAT'])

reg.predict(new_data1)

new_data1['Predicted_GPA'] = reg.predict(new_data1)

plt.scatter(x_x,y_y)

yhat1 = reg.coef_*x_matrix + reg.intercept_

fig1 = plt.plot(x_x, yhat1, lw=4, c='orange', label ='regression line')

plt.xlabel('SAT', fontsize = 20)
plt.ylabel('GPA', fontsize = 20)
plt.show()


# Multiple Linear regression 
data2 = pd.read_csv('C:/Users/cruel/Desktop/real_estate_info1.csv')

print(data2.head())

print(data2.describe())

x2 = data2[['legal_tract','Numstories']]

y2 = data2['land_use_code']

reg = LinearRegression()


reg.fit(x2,y2)

print(reg.score(x2,y2))
print(reg.coef_)
print(reg.intercept_)

f_regression(x2,y2)

p_values = f_regression(x2,y2)[1]
print(p_values)
print(p_values.round(3))

Logistic Regression
raw_data = pd.read_csv('C:/Users/cruel/Desktop/real_estate_info2.csv')
raw_data

data3 = raw_data.copy()
data3['ac_present'] = data3['ac_present'].map({'Y': 1, 'N': 0})

y3 = data3['ac_present']
x3 = data3['yearbltact']

x4 = sm.add_constant(x3)

reg_log = sm.Logit(y3,x4)
results_log = reg_log.fit()

def f(x4,b0,b1):
    return np.array(np.exp(b0+x4*b1) / (1 + np.exp(b0+x4*b1)))

f_sorted = np.sort(f(x3,results_log.params[0],results_log.params[1]))
x_sorted = np.sort(np.array(x3))

plt.scatter(x3,y3,color='C0')
plt.xlabel('yearbltact', fontsize = 20)
plt.ylabel('ac_present', fontsize = 20)
plt.plot(x_sorted,f_sorted,color='C8')
plt.show()

print(results_log.summary())

# SK-Clustering 

raw_data3 = pd.read_csv('C:/Users/cruel/Desktop/geo_data.csv')

data4 = raw_data3.copy()

plt.scatter(data4['Longitude'], data4['Latitude'])
plt.xlim(-180,180)
plt.ylim(-90, 90)
plt.show()

x6 = data4.iloc[:,1:3]

kmeans = KMeans(7)
kmeans.fit(x6)
identified_clusters = kmeans.fit_predict(x6)

data_with_clusters = data4.copy()
data_with_clusters['Cluster'] = identified_clusters

plt.scatter(data4['Longitude'], data4['Latitude'],c=data_with_clusters['Cluster'], cmap = 'rainbow')
plt.xlim(-180,180)
plt.ylim(-90, 90)
plt.show()

#seaborn heatmap

data = pd.read_csv('C:/Users/cruel/Desktop/geo_data2.csv', index_col='Country')
x_scaled = data.copy()
x_scaled = x_scaled.drop(['Language'],axis=1)
print(x_scaled)
sns.clustermap(x_scaled, cmap='mako')
plt.show()



