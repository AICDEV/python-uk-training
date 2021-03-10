# write data to a file
import random
import string

with open('./data/info.txt', 'w+') as out:
    for _ in range(5000):
        out.write(''.join([c for c in random.choices(string.digits,k=10)]) + '\n')