####################
# basics
####################
import random

some_words = 'Hello, I\'m a normal sentence. Nothing more, nothing less!'
print(some_words)

# get range from a string
str_range = some_words[5:15]
print(str_range)

# convert a string into it's hex values
str_hex = ''.join([hex(ord(c)) for c in some_words]).replace('0x','').upper()
print(str_hex)

# split string into bits and bytes
byte_arr = bytearray(some_words, 'utf-8')
bin_arr = [bin(b) for b in byte_arr]
print(bin_arr)

# get random value
rand_n = random.randrange(10)
print(rand_n)
