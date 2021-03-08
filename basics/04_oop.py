#############################
# Object oriented programming
#############################

import random

class Member:
    def __init__(self):
        self._id = random.randint(1,1000)

class Coder(Member):
    def __init__(self, name, language):
        super().__init__()
        
        self.__name = name
        self.__languages = [language]

    def add_programming_language(self, language):
        self.__languages.append(language)
    
    def get_programming_language(self):
        return 'I code in: "{}"'.format(', '.join(l for l in self.__languages))

    def get_id(self):
        return self._id


coder = Coder('jens','python')
coder.add_programming_language('javascript')
coder.add_programming_language('golang')

print(coder.get_programming_language())
print(coder.get_id())