############################################
# Preemptive Multitasking python interface
# threading
############################################

############################################
# WHEN TO USE?
# A program must perform complex but
# depending tasks. Working with OOP
############################################

import threading


class Wallis(threading.Thread):

    Lock = threading.Lock()

    def __init__(self, n):
        super().__init__()
        self.__n = n
        self.__pn = 1
        self.__numerator = 2.0
        self.__denominator = 1.0

    def run(self):
        for i in range(self.__n):
            self.__pn *= self.__numerator / self.__denominator
            if i % 2:
                self.__numerator += 2
            else:
                self.__denominator += 2
        print(2 * self.__pn)


thread_pool = []

print('hello I\'m a PI calculator. Please enter a number!')
user_limit = input('> ')

while user_limit != 'close':
    try:
        thread = Wallis(int(user_limit))
        thread_pool.append(thread)
        thread.start()
    except ValueError:
       with Wallis.Lock:
           print('wrong input')

    
    with Wallis.Lock:
        user_limit = input('> ')

for th in thread_pool:
    # block until thread is done
    th.join()