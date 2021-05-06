import threading
import time
from random import random

COUNT = 0

LOCK1 = threading.Lock()
LOCK2 = threading.Lock()
LOCK3 = threading.Lock()


def count(thread_name, lock_a, lock_b):
    """
    Dead locking example resource.

    In a real world example, there would be multiple resources with
    nested locks; each resource having a different lock.

    For demo purposes we have placed the nested locks in the same resource.
    """
    global COUNT
    while COUNT < 500:
        lock_a.acquire()

        # algorithm to attempt to prevent deadlocking but causes LIVE LOCKING
        if not lock_b.acquire(blocking=False):
            print(f"{thread_name} releasing first lock")
            lock_a.release()

        try:
            COUNT += 1
            print(f"{thread_name} is incrementing COUNT to equal: {COUNT}")
        # in case of unexpected thread termination
        finally:
            lock_b.release()
            lock_a.release()


def main_thread():
    counter1 = threading.Thread(target=count, args=("counter1", LOCK1, LOCK2))
    counter2 = threading.Thread(target=count, args=("counter2", LOCK2, LOCK3))
    counter3 = threading.Thread(target=count, args=("counter3", LOCK3, LOCK1))

    counter1.start()
    counter2.start()
    counter3.start()

    counter1.join()
    counter2.join()
    counter3.join()

    # the threads key releasing locks until infinitely

    print(f"COUNT: {COUNT}")


if __name__ == "__main__":
    main_thread()
