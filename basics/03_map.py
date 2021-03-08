####################
# map
# => https://docs.python.org/3/library/functions.html#map
####################


def square(n):
    return n**2

numbers = list(range(1,50))
square_numbers = list(map(square, numbers))

print(square_numbers)