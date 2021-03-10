number_list = list(range(51))

def gen_list():
    for n in number_list:
        print("compute n")
        yield n 

for n in gen_list():
    print(n)