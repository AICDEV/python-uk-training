# calc kilometers into miles
from sklearn.linear_model import LinearRegression

# kilo meters
x = [
    [10],
    [15],
    [60]
]

# miles
y = [
    6.2,
    9.3,
    37.3
]

model = LinearRegression(fit_intercept=False)
model.fit(x, y)

# print weight
print("model weight: ", model.coef_, "\n")

z = [
    [20],
    [120],
    [240]
]

print(model.predict(z))
