# dataset https://www.kaggle.com/jsphyg/weather-dataset-rattle-package
import pandas as pd
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense
from sklearn.model_selection import train_test_split

csv_data = pd.read_csv('./data/weatherAUS.csv')
# print(csv_data.head(5))
# print(csv_data.shape)


def prepareRainToday(a):
    if str(a).lower() == "no":
        return 0
    return 1


def strToFloat(wd):
    d = str(wd)[0]
    return float(ord(d))


def cleanNan(v):
    if str(v).lower() == "nan":
        return 1.0
    return v


train_data = csv_data[["MinTemp", "MaxTemp", "Rainfall", "WindGustSpeed", "WindDir9am", "WindDir3pm",
                       "Humidity9am", "Humidity3pm", "Pressure9am", "Pressure3pm", "Cloud9am", "Cloud3pm", "Temp9am", "Temp3pm"]]

train_labels = csv_data[["RainToday"]]

train_labels["RainToday"] = train_labels["RainToday"].apply(prepareRainToday)
train_labels = train_labels.to_numpy()
train_labels = train_labels == 1

train_data["WindDir9am"] = train_data["WindDir9am"].apply(strToFloat)
train_data["WindDir3pm"] = train_data["WindDir3pm"].apply(strToFloat)
train_data["Cloud9am"] = train_data["Cloud9am"].apply(cleanNan)
train_data["Cloud3pm"] = train_data["Cloud3pm"].apply(cleanNan)
train_data = train_data.to_numpy()

x_train, x_test, y_train, y_test = train_test_split(train_data, train_labels)

# print(train_data.head(4))
# print(train_labels.head(4))

#network definition

model = Sequential()
model.add(Dense(35, activation="sigmoid", input_shape=(14,)))
model.add(Dense(60, activation="relu"))
model.add(Dense(260, activation="sigmoid"))
model.add(Dense(1, activation="sigmoid"))

model.compile(optimizer="sgd", loss="binary_crossentropy", metrics=["accuracy"])

model.fit(x_train, y_train, epochs=15, batch_size=256)


# test neuronal network
#print(train_labels[18])
#print(train_data[0].shape)
#print(train_data[0].reshape(1, 14).shape)


# print(train_labels[0])
# p = model.predict(train_data[0].reshape(1, 14))
# print(p)

# get data accuranccy
acc = model.evaluate(x_test, y_test)
#
print(acc)