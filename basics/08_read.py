# read data from a file

# with open('./data/info.txt', 'r') as out:
#     line = out.readline()

#     while line:
#         print(line.strip())
#         line = out.readline()

# read chunks in byte mode

# chunck_size_in_bytes = 11

# with open('./data/info.txt', 'rb') as out:
#     chunk = out.read(chunck_size_in_bytes)

#     while chunk:
#         print(bytearray(chunk))
#         chunk = out.read(chunck_size_in_bytes)