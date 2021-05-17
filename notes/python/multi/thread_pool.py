"""
Demonstrates that using a thread pool can be faster when thread start up takes longer than the actual task.
"""

import time
import logging
import threading
from concurrent.futures import ThreadPoolExecutor
from multiprocessing.pool import ThreadPool

logging.basicConfig(level=logging.INFO, format="")


COUNTS = 0


def timer(func):
    def wrapper():
        start = time.time()
        func()
        end = time.time()
        logging.info(f"{func.__name__}: {end - start:.2f} secs")
    return wrapper


def increment_count(identifier):
    global COUNTS
    # do something with arg (only here to demo that we can parse values to threadpool)
    # logging.info(threading.current_thread().getName())
    COUNTS += 1


@timer
def main_thread():
    for num in range(1, 10000):
        threading.Thread(target=increment_count, args=(num,)).start()


@timer
def thread_pool_futures():
    """
    Faster as thread start up time is the bottle neck here.
    """
    # number of threads to create and reuse
    pool = ThreadPoolExecutor(max_workers=7)
    for num in range(1, 10000):
        pool.submit(increment_count, num)
    # free up any resources after pending tasks finishes
    pool.shutdown()


@timer
def thread_pool():
    # I prefer this implementation of the thread pool (the syntax is better)
    # and its faster (for some reason)
    with ThreadPool(processes=7) as pool:
        pool.map(increment_count, range(1, 10000))
    pool.close()
    pool.join()


if __name__ == "__main__":
    main_thread()
    thread_pool_futures()
    thread_pool()
