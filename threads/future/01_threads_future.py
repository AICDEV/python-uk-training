############################################
# Preemptive Multitasking python interface 
# concurrent futures
############################################

############################################
# WHEN TO USE?
# A program must perform complex but 
# independent tasks.
############################################


from concurrent import futures
from time import sleep, time

def wait(t):
    sleep(t)
    print('i\'ve waited for: {} seconds! time: {}'.format(t, time()))


thread_executor = futures.ThreadPoolExecutor(max_workers=3)

print('start at: {}'.format(time()))

thread_executor.submit(wait, 4)
thread_executor.submit(wait, 2)
thread_executor.submit(wait, 5)
thread_executor.submit(wait, 7)

print('all threads started')
# blocking call!
thread_executor.shutdown()
print('done!')