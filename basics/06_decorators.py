#############################
# decorators or syntactical
# sugar
#############################


def twice(func):
    def inner_wrap(*args,**kwargs):
        func(*args,**kwargs)
        func(*args,**kwargs)
    return inner_wrap


@twice
def log(m):
    print(m)


log('test message')