# calc celsius into fahrenheit
from sklearn.linear_model import LinearRegression

# celsius
x = [
    [-10],
    [0],
    [20]
]

# fahrenheit
y = [
    14,
    32,
    68
]

# bias
model = LinearRegression(fit_intercept=True)
model.fit(x, y)

# print weight
print("model weight: ", model.coef_, "model intercept: ", model.intercept_, "\n")
z = [
    [20],
    [120],
    [240]
]

print(model.predict(z))
