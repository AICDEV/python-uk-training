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

############################################
# Approximate PI using the Wallis Product
# https://en.wikipedia.org/wiki/Wallis_product
############################################

def approximate_pi(n):
    p_n = 1
    numerator = 2.0
    denominator = 1.0
    for i in range(n):
        p_n *= numerator / denominator
        if i % 2:
            numerator += 2
        else:
            denominator += 2
    return 2 * p_n


targets = (100000000,5000000,250000,150,50000)

with futures.ThreadPoolExecutor(max_workers=5) as thread_executor:

    # dictionary iterator
    fp = {thread_executor.submit(approximate_pi, t): t for t in targets}

    # thread iterator
    for f in futures.as_completed(fp):
        print('pi({}) => pi: {}'.format(fp[f], f.result()))