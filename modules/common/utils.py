import os

def get_env(name):
    try:
        return os.environ[name]
    except:
        return None