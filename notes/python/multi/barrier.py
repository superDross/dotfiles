"""
Barriers help synchronise a fixed number of threads at a known synchronisation point.

They help organise thread order of execution.

Threads block on wait() and are awoken all at once when they have ALL made that call.
"""

import logging
import random
import threading


logging.basicConfig(level=logging.INFO, format="")


COUNTS = 0
LOCK = threading.Lock()
# 10 threads should adhere to the barrier
BARRIER = threading.Barrier(10)

# toggle for seeing script executed with and without a barrier
ACTIVATE_BARRIER = True


def increment_count():
    global COUNTS
    with LOCK:
        name = threading.current_thread().getName()
        logging.info(f"RUNNING: {name}")
        COUNTS += 3
    if ACTIVATE_BARRIER:
        # prevent other threads from proceeding the Barrier until all increment_count
        # threads have completed
        BARRIER.wait()


def double_count():
    if ACTIVATE_BARRIER:
        # do not start until the increment_count threads have completed
        BARRIER.wait()
    global COUNTS
    with LOCK:
        name = threading.current_thread().getName()
        logging.info(f"RUNNING: {name}")
        COUNTS *= 2


def generate_child_threads():
    threads = []
    for i in range(5):
        threads.append(
            threading.Thread(target=increment_count, name=f"Increment-Thread-{i}")
        )
        threads.append(threading.Thread(target=double_count, name=f"Double-Thread-{i}"))

    # simultes random execution of threads to create a race condition
    random.shuffle(threads)
    return threads


def main_thread():
    # we prevent a data race by using locks before altering the COUNT
    threads = generate_child_threads()
    for thread in threads:
        thread.start()

    for thread in threads:
        thread.join()
    print(COUNTS)


if __name__ == "__main__":
    main_thread()
