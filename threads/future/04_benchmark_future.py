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
import sys
import time
import os

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



if __name__ == '__main__':
       
    start_time = time.perf_counter()

    T = (1000000,500000,2500000,31545165,21112451,342326435)

    if sys.argv[1] == 'threads':
        with futures.ThreadPoolExecutor(max_workers=5) as executor:
            res = executor.map(approximate_pi, T)

    elif sys.argv[1] == 'processes':
        with futures.ProcessPoolExecutor(max_workers=5) as executor:
              res = executor.map(approximate_pi, T)
    
    elif sys.argv[1] == 'map':
        res = map(approximate_pi, T)

    else:
        os._exit(1)

    print(list(res))
    print(time.perf_counter() - start_time)

############################################
# MY RESULTS
# map:          44.109786017999994
# threads:      41.590237754
# processes:    37.782142948
############################################