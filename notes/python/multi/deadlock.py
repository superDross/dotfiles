"""
Demonstrates how a dead lock can occur
"""

import threading

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
        # nested locks
        lock_a.acquire()
        lock_b.acquire()

        COUNT += 1
        print(f"{thread_name} is deducting COUNT to equal: {COUNT}")

        lock_b.release()
        lock_a.release()


def main_thread():
    counter1 = threading.Thread(target=count, args=("counter1", LOCK1, LOCK2))
    counter2 = threading.Thread(target=count, args=("counter2", LOCK2, LOCK3))
    # To fix, swap LOCK3 & LOCK1 around (be warned race conditions can occur there after)
    counter3 = threading.Thread(target=count, args=("counter3", LOCK3, LOCK1))

    counter1.start()
    counter2.start()
    counter3.start()

    counter1.join()
    counter2.join()
    counter3.join()

    # An example order of events preceding a dead lock:
    # - counter1 grabs LOCK1
    # - counter2 grabs LOCK2
    # - counter3 grabs LOCK3

    # There is now a deadlock as:
    # - counter1 needs LOCK2 which is held by counter2
    # - counter2 needs LOCK3 which is held by counter3
    # - counter3 needs LOCK1 which is held by counter1

    # no thread can move forward

    # one way to get around this is to prioritize the locks in a specific order
    # swapping LOCK3 & LOCK1 in counter3

    # this would mean counter3 would wait for LOCK1, allowing counter2 to grab LOCK3
    # counter3 would resume when counter1 & counter2 have finished utilising the resource

    print(f"COUNT: {COUNT}")


if __name__ == "__main__":
    main_thread()
