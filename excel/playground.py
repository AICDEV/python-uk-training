import pandas as pd
from datetime import datetime, timedelta

data = pd.read_excel("./data/persons.xlsx")
data = data.dropna(how="any").reset_index()
data = data.sort_values(by="Firstname")

# 1. score median 
# 2. max, min to mean balance
# 3. mean age 
# 4. plot data

print("+"*100)
median_score = data['Score'].median()

# 1
print(median_score)

# 2
print("min balance: {} ,max balance: {} and mean balance: {}".format(data['Balance'].min(),data['Balance'].max(),data['Balance'].mean()))

def calc_age(age):
    past = datetime.now() - timedelta(days=31*365)
    if age > past:
        delta = datetime.today() - age
        return int((delta.days / 365))
    return 1000


def calc_score(sc):
    return round(sc * 3, 1)
# 3
age_list = [calc_age(person) for person in data['Date of Birth']]
score_list = [calc_score(score) for score in data['Score']]

df_ages = {
    'Ages': age_list
}

df_scores = {
    'CalcScores': score_list
}

df = pd.DataFrame.from_dict(df_ages)
df2 = pd.DataFrame.from_dict(df_scores)
data = data.join(df['Ages'])
data = data.join(df2['CalcScores'])
data.to_excel('./data/person_with_age.xlsx', sheet_name='Person with Age')