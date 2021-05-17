import logging
import random
import time
from concurrent.futures import ProcessPoolExecutor
from functools import wraps


logging.basicConfig(level=logging.INFO, format="")

DIGITS = [random.randint(1, 100) for _ in range(10000000)]


def timer(func):
    """
    Evaluates time taken to complete the task
    """
    def wrapper():
        attempts = 10
        times = []
        for _ in range(attempts):
            start = time.time()
            func()
            end = time.time()
            times.append(end - start)
        average = sum(times) / attempts
        logging.info(f"{func.__name__} ({attempts} runs): {average:.2f} secs")
    return wrapper


def number_cruncher(n):
    return n * 1000 / 2


@timer
def sequential():
    for x in DIGITS:
        number_cruncher(x)


@timer
def multiple_processing():
    with ProcessPoolExecutor() as pool:
        pool.submit(number_cruncher, DIGITS)


if __name__ == "__main__":
    # warm up (warm up cache, start up costs etc.)
    number_cruncher(100)

    # evaluation
    sequential()
    multiple_processing()
