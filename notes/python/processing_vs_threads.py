"""
Process; an instance of program (e.g. Jupyter notebook, Python interpreter).

Threads (subprocesses); processes spawn threads to handle subtasks like
                        reading keystrokes, loading HTML pages, saving files.

Threads live inside processes and share the same memory space.

Only one thread is running at any given time in Python, because of the GIL.

Threads in Python do not execute code simultaneously, instead they run concurrently.


Concurrency; when two or more tasks can start, run, and complete in overlapping
             time periods.

It doesn't necessarily mean they'll ever both be running at the same instant.
    e.g., example, multitasking on a single-core machine.

Parallelism; when tasks literally run at the same time.
    e.g., on a multicore processor.

Use multithreading for IO tasks (API calls, querying DBs & subprocessing).

"""
import subprocess
import time
from multiprocessing.pool import Pool, ThreadPool

import requests


def test_it(func, ranges):
    """
    Tests a func and a range against a
    map, thread pool and multiprocessing
    pool.
    """
    a_list = [x for x in ranges]
    to_iterate = [
        (map, f"serial_{func.__name__}"),
        (ThreadPool().map, f"threading_{func.__name__}"),
        (Pool().map, f"processing_{func.__name__}"),
    ]
    for pool, name in to_iterate:
        start = time.time()
        # map needs list as its a generator
        list(pool(func, a_list))
        runtime = round(time.time() - start, 1)
        print(f"{name}: {runtime} Sec")
    print()


# SUBPROCESSING
def grep_it(l):
    subprocess.call("grep menu ~/menu.py", shell=True)


# serial - 42.9 Sec
# threading - 11.2 Sec
# processing - 9.6 Sec
# test_it(grep_it, range(10000))


# SUBPROCESSING
def pointless_subprocess(number):
    number *= 3
    subprocess.call(f"sleep {number} ; echo {number} sec >> f.txt", shell=True)
    return number


# serial - 27 sec
# threading - 12 sec
# processing - 12 sec
# test_it(pointless_subprocess, range(2, 5))

"""
Multiprocessing is just as good as multithreading, however, it just has more
overhead because popping processes is more expensive than popping threads.
"""


# API CALLS
def get_api(num):
    url = f"https://jsonplaceholder.typicode.com/apis/{num}"
    return requests.get(url).text


# serial - 6 sec
# threading - 1.3 sec
# processing - 1.3 sec
# test_it(get_api, range(50))

"""
Multiprocessing is just as good as multithreading, however, it just has more
overhead because popping processes is more expensive than popping threads.
"""

# IO FILES
def io_heavy(text):
    f = open("output.txt", "wt", encoding="utf-8")
    f.write(str(text))
    f.close()


# serial - 7.2 Sec
# threading - 5.2 Sec
# processing - 1.8 Sec
# test_it(io_heavy, range(100000))

""" No idea why threading slower."""


# CPU TASK
def division(num):
    return 100 / num


# serial - 2.4 Sec
# threading - 5.4 Sec
# processing - 4.0 Sec
# test_it(division, range(1, 20000000))

"""
MULTIPROCESSING
multiprocessing takes longer here because it takes
time to create processes and distribute data chunks to
them via the pickle and unpickling process

multiprocessing therefore doesn't make sense for very short_duration processing.

THREADING
when multithreading CPU heavy tasks, since only one thread is executed at any given
time, it will be like serial execution PLUS the time spent to switch between the
threads.
"""


# CPU HEAVY
def mega_algo(n):
    x = (n * 100 * 2000000000) / 200
    return (x / 10000) * 2090 - 90


# serial - 8.1 Sec
# threading - 12.9 Sec
# processing - 6.0 Sec
# test_it(mega_algo, range(1, 21000000))

"""
Multiprocessing works well with heavy CPU task.


Threading, as above.
"""
