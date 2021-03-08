############################################
# Preemptive Multitasking python interface
# threading
############################################

############################################
# WHEN TO USE?
# A program must perform complex but
# depending tasks. Working with OOP
############################################


# CRITICAL CODE! BE CAREFUL
# import threading

# class Demo(threading.Thread):

#     counter = 0

#     def __init__(self):
#         super().__init__()

#     def run(self):
#         for _ in range(2500000):
#             Demo.counter += 1


# demo_a = Demo()
# demo_b = Demo()

# demo_a.start()
# demo_b.start()

# demo_a.join()
# demo_b.join()

# # why have we always different results?
# print(demo_a.counter)
# print(demo_b.counter)

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


# SAVE CODE (Race Condition)
# import threading

# class Demo(threading.Thread):
#     lock = threading.Lock()

#     counter = 0

#     def __init__(self):
#         super().__init__()

#     def run(self):
#         for _ in range(2500000):
#             with Demo.lock:
#                 Demo.counter += 1


# demo_a = Demo()
# demo_b = Demo()

# demo_a.start()
# demo_b.start()

# demo_a.join()
# demo_b.join()

# # why have we always different results?
# print(demo_a.counter)
# print(demo_b.counter)