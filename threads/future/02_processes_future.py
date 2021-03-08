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


# important: only the main process can start sub processes!
if __name__ == '__main__':
    
    print('start at: {}'.format(time()))
    with futures.ProcessPoolExecutor(max_workers=3) as thread_executor:
        thread_executor.submit(wait, 4)
        thread_executor.submit(wait, 2)
        thread_executor.submit(wait, 5)
        thread_executor.submit(wait, 7)

        print('all processes started')
    
    print('done!')