import os
import random
import string

# read data from a file

# with open('./data/info.txt', 'r') as out:
#     line = out.readline()

#     while line:
#         print(line.strip())
#         line = out.readline()



# create huge demo file
# with open('./data/huge.txt', 'w+') as huge_file:
#     huge_file.write("header \n")

#     current_size = os.stat('./data/huge.txt').st_size
#     while current_size < 18253611008:
#         huge_file.write('foobar lol \n' * 10000)
#         current_size = os.stat('./data/huge.txt').st_size
#         print("current size: ", current_size)

# print("huge file generated")



# 17 GB ~ 18253611008 bytes
#chunck_size_in_bytes = 11

#read chunks in byte mode
# with open('./data/info.txt', 'rb') as out:
#     chunk = out.read(chunck_size_in_bytes)

#     while chunk:
#         byte_list = bytearray(chunk)
#         print(byte_list)
#         chunk = out.read(chunck_size_in_bytes)