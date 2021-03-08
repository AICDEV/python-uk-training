import pandas as pd
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense
from sklearn.model_selection import train_test_split

def word2n(w):
    n = 0
    for c in w:
        n += ord(c)
    return n 

def map_time(e):
    e = str(e).replace(":",".")
    return float(e)

def map_duration(e):
    return float(e)


csv_data = pd.read_csv('./data/page_data.csv')

x_data = csv_data
x_data['visit_time'] = x_data['visit_time'].apply(map_time)
x_data['page_duration'] = x_data['page_duration'].apply(map_duration)
x_data['device'] = x_data['device'].apply(word2n)
x_data['region'] = x_data['region'].apply(word2n)
x_data['browser'] = x_data['browser'].apply(word2n)
x_data['gender'] = x_data['gender'].apply(word2n)
x_data['product'] = x_data['product'].apply(word2n)
x_data['bought'] = x_data['bought'].apply(lambda x: float(x))

y_data = csv_data[['bought']]
y_data = y_data == 1



x_train, x_test, y_train, y_test = train_test_split(x_data, y_data)

print(x_train[:5])
print(y_train[:5])
#print(x_train.shape)

# #network definition

model = Sequential()
model.add(Dense(35, activation="sigmoid", input_shape=(9,)))
model.add(Dense(160, activation="sigmoid"))
model.add(Dense(160, activation="relu"))
model.add(Dense(1, activation="sigmoid"))

model.compile(optimizer="adam", loss="binary_crossentropy", metrics=["accuracy"])
model.fit(x_train, y_train, epochs=10, batch_size=512)



# get data accuranccy
acc = model.evaluate(x_test, y_test)
print(acc)


test_data = x_test.to_numpy()[12]
test_label = y_test.to_numpy()[12]

print(test_label)
print(test_data)

pre = model.predict(test_data.reshape(1,9))
print(pre)