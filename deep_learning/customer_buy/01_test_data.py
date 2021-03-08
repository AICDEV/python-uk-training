import pandas as pd
import numpy as np
import datetime
from random import randrange, choice

########################################################
# CUSTOMER
# visit_time (homepage)
# duration (who long was the user on the page)
# device (smartphone, tablet, notebook)
# region (North, South, West, East)
# browser (chrome, safari, firefox, edge)
# age 
# gender (male, female)
# product (gas, energy)
# bought?
########################################################

def get_visit_time():
    start = datetime.datetime(2021,3,10,8,00)
    t = start + datetime.timedelta(minutes=randrange(720))
    return t.strftime("%H:%M")

def get_device():
    return choice(["smartphone", "tablet", "notebook"])

def get_region():
    return choice(["north", "south", "west", "east"])

def get_browser():
    return choice(["chrome", "safari", "firefox", "edge"])

def get_age():
    return randrange(18,99)

def get_gender():
    return choice(["male", "female"])

def get_duration():
    return randrange(1,60)

def get_random_product():
    return choice(["gas", "energy"])

def has_bought():
    return randrange(0,2)
test_data = []

for _ in range(1000000):
    test_data.append([
        get_visit_time(),
        get_duration(),
        get_device(),
        get_region(),
        get_browser(),
        get_age(),
        get_gender(),
        get_random_product(),
        has_bought()
    ])


test_df = pd.DataFrame(
    np.array(test_data), 
    columns=["visit_time","page_duration","device","region","browser","age","gender","product","bought"])

test_df.to_csv("./data/page_data.csv", index=False)