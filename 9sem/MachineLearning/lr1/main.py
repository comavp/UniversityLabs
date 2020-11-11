import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

testDataFileName = r'data\data.txt'
fakeDataFileName = r'data\data_fake.txt'
trueDataFileName = r'data\data_true.txt'

data = pd.read_csv(testDataFileName, sep=':', header=None)
data.columns = ['user_names', 'user_actions']

#print(np.array(data['user_actions'][4].split(';'), dtype=np.uintc))
data['user_actions'] = data['user_actions'].apply(lambda x: np.array(x.split(';'), dtype=np.uintc))

new_data = pd.DataFrame({"user_actions": data['user_actions'][4]})
new_data['user_actions'].plot(figsize=[20, 5])
print(new_data['user_actions'])