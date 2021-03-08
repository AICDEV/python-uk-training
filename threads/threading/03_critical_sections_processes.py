############################################
# Preemptive Multitasking python interface
# threading
############################################

############################################
# WHEN TO USE?
# A program must perform complex but
# depending tasks. Working with OOP
############################################

#########################################################
# Race Condition
#
# Remember the how concurrency work. It's
# 'artifical' concurrency, realized by 
# timeslot where a program is running or on
# hold. Before jumping to next, the os gonna
# save the thread state.
#
# Thread demo_a stop before increase Demo.counter
# Thread demo_b wakes up and increase Demo.counter 
# demo_a is not finished with his calculation of
# Demo.counter and therefore has no new saved state,
# demo_b is gonna read the "old" value from Demo.counter
# demo_b stops. Then demo_a wakes up again and load the
# old value from Demo.counter and increase this value. 
# The result is a increase of 1 instead of 2. Let's see
# how we can prevend this.
##########################################################

import multiprocessing

class Demo(multiprocessing.Process):
    def __init__(self, n, lock):
        super().__init__()
        self._n = n
        self.__lock = lock

    def run(self):
        for _ in range(self._n):
            with self.__lock:
                self._n += 1
        with self.__lock:
            print('result => {}'.format(self._n))


if __name__ == '__main__':
    demo_a = Demo(500000, multiprocessing.Lock())
    demo_b = Demo(700000, multiprocessing.Lock())

    demo_a.start()
    demo_b.start()

    demo_a.join()
    demo_b.join()