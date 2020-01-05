# csilly.pyx
def csilly():
    cdef int n = 0
    cdef int m = 0
    for n in range(1, 10000):
        for m in range(1000, 9000):
            yield(m/n)

# setup.py
from distutils.core import setup
from Cython.Build import cythonize

# python setup.py build_ext --inplace
setup(
    ext_modules=cythonize("cython_tutorial.pyx")
)

# silly.py
import time
import pyximport; pyximport.install()
from cython_tutorial import csilly


def silly():
    for n in range(1, 10000):
        for m in range(1000, 9000):
            yield(m/n)

# pure python
start = time.time()
print(sum(silly()))
print(f'Time: {round(time.time() - start, 1)} seconds\n')

# cpyton (3x faster)
start = time.time()
print(sum(csilly()))
print(f'Time: {round(time.time() - start, 1)} seconds')
