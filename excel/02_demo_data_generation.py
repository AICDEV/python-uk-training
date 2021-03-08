# read from excel with python

# 1. read excel file
# 2. filter rows with no value
# 3. sort dataframe (df) by lastname
# 4. print first 3 rows in a loop with label firstname, lastname, score and balance

import pandas as pd
import numpy as np
import random
import string


def get_country():
    return random.choice([
        'DE',
        'UK',
        'FR',
        'ES',
        'AT',
        'IT',
        'IR',
        'DK',
        'PT'
    ])


def get_uuid():
    uuid = ""
    for _ in range(10):
        uuid += random.choice(string.digits)

    return uuid


def get_age():
    return random.randrange(18, 70)


def get_label():
    return '{}-LBL-{}-{}'.format(random.randrange(1000, 5000), random.choice(string.ascii_uppercase), random.choice(string.ascii_uppercase))


test_data = []
for _ in range(1500):
    test_data.append([
        get_country(),
        get_uuid(),
        get_age(),
        get_label()
    ])


test_df = pd.DataFrame(np.array(test_data), columns=['Country','UUID','Age','Label'])
test_df.to_excel('./data/generated_test_data.xlsx',sheet_name='Testdata',index=False)
