# read from excel with python

# 1. read excel file
# 2. filter rows with no value
# 3. sort dataframe (df) by lastname
# 4. print first 3 rows in a loop with label firstname, lastname, score and balance

import pandas as pd 
import datetime
import numpy as np
import matplotlib.pyplot as plt

print('Section 1')
print('*'*80)
# 1 & 2
ex_data = pd.read_excel('./data/persons.xlsx')
ex_data = ex_data.dropna(how='any')

# 3
sort_ex_data = ex_data.sort_values(by='Lastname')

# 4
for item in sort_ex_data.head(3).to_numpy():
    print('firstname: "{}", lastname: "{}", score: "{}", balance: "{}"'.format(item[1],item[2],item[4],item[6]))



# calculation

# 1. calc median for score
# 2. get max, min and mean score
# 3. mean of age
# 4. plot data
print('\nSection 2')
print('*'*80)

# 1 & 2
sc_median = ex_data['Score'].median()
print('median of all scores: "{}"'.format(sc_median))
print('min score: "{}" max score: "{}" mean score: "{}"'.format(ex_data['Score'].min(), ex_data['Score'].max(),round(ex_data['Score'].mean(),2)))



# 3
def get_age(date_of_birth):
    delta = datetime.datetime.today() - date_of_birth
    return int((delta.days / 365))

age_mean = np.array([get_age(d) for d in ex_data['Date of Birth']])
print('age average in group: {}'.format(round(age_mean.mean(),2)))

# 4
age_arr = np.array([get_age(d) for d in ex_data['Date of Birth']])
df_object = {
    'Ages': age_arr,
    'Balance': ex_data['Balance']
}

df = pd.DataFrame.from_dict(df_object)

# df.plot(kind='scatter',x='Balance',y='Ages',color='red')
# plt.grid()
# plt.show()


# write to excel

# 1. calc age for each person
# 2. append age column
# 3. write to excel
print('\nSection 3')
print('*'*80)

computed_ex_data = ex_data.copy()

computed_ex_data = computed_ex_data.join(df['Ages'])
computed_ex_data.to_excel('./data/computed_persons.xlsx', sheet_name='Computed')
