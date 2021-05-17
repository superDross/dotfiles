"""
Demo how Futures work
"""

import time
import logging
from concurrent.futures import ThreadPoolExecutor

logging.basicConfig(level=logging.INFO, format="")


COUNTS = 0


def api_call():
    logging.info("Making a very real API call")
    time.sleep(3)
    return 42


def increment_count(n=1000000):
    global COUNTS
    logging.info(f"Incrementing count by {n}")
    for _ in range(1, n + 1):
        COUNTS += 1
    return COUNTS


def thread_pool_futures():
    """
    Faster as thread start up time is the bottle neck here.
    """
    with ThreadPoolExecutor() as pool:
        future = pool.submit(api_call)
        # we can do another task while we await for the result
        pool.submit(increment_count)

        # this blocks and waits until it has a value returned (like a JS promise)
        response = future.result()

        logging.info(f"API Response: {response}")
        logging.info(COUNTS)


if __name__ == "__main__":
    thread_pool_futures()
