####################
# formats
####################
import json
import base64
####################
# helper start
####################

def custom_sort(n):
    return len(n)

####################
# helper end
####################


####################
# list
# => Lists are used to store multiple items in a single variable
####################
# my_list = ['coffee','tea','beer','wine']
# my_list.append('cola')
# my_list[1] = 'sprite'
# my_list.sort()
# #my_list.sort(key=custom_sort)

# print(my_list)
# print(my_list[::-1])
# print(' => '.join(my_list))


####################
# tupel
# => Tuple items are ordered, unchangeable, and allow duplicate values
####################

# my_tupel = ('coffee','tea','beer')
# print(my_tupel)

# (a, b, c) = my_tupel
# print(a)
# print(b)
# print(c)


####################
# dict
# => Dictionaries are used to store data values in key:value pairs
####################
# my_dict = {
#     'name': 'beer',
#     'size': 'medium',
#     'containsAlcohol': True,
#     'inventory': 42
# }

# print(my_dict['name'])
# for item in my_dict:
#     print("key: {} => value: {}".format(item, my_dict[item]))

####################
# set
# => Set items are unordered, unchangeable, and do not allow duplicate values.
####################
# my_set = {'cola','tea','coffee','tea'}
# my_set_two = {'sprite','milk'}
# my_set.update(my_set_two)
# my_set.add('tea')
# my_set.add('fanta')
# print(my_set)

####################
# json
# => https://docs.python.org/3/library/json.html
####################
# j_list = [1,2,3,4,5,6]
# j_tupel = ('coffee','milk')
# j_set = ('tea','beer')
# j_dict = {
#     'numbers': j_list,
#     'drinks_t': j_tupel,
#     'drinks_s': j_set,
#     'isOk': True,
#     'mean': 12.4,
#     'names': [
#         {
#             'age': 43,
#             'country': 'DE'
#         },
#         {
#             'age': 42,
#             'country': 'FR'
#         }
#     ]
# }

# with open('./data/02_formats.json','w+') as write_json_to_file:
#     json.dump(j_dict, write_json_to_file, indent=4, sort_keys=True)


####################
# base64
# b_arr = bytearray()
# [b_arr.append(b) for b in range(0,256)]

# b64 = base64.b64encode(b_arr)
# print(b64)

####################