####################
# with context
# => https://docs.python.org/3/whatsnew/2.6.html#pep-343-the-with-statement
####################

from contextlib import contextmanager


# implementation of the context manager protocol
with open('01_basics.py') as bpy:
    print(bpy)



@contextmanager
def stuff(n):
    value = n / 1
    try:
        yield value
    except:
        print('rollback')
        raise
    else:
        print('done')
        return 1

with stuff(100) as st:
    print(st)
