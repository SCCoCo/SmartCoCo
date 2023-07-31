import os
import shutil

def check_or_mkdir(path):
    if os.path.exists(path):
        pass
    else:
        os.mkdir(path)

def check_and_deletedir(path):
    if os.path.exists(path):
        shutil.rmtree(path)
    else:
        pass
