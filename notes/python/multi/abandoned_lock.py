"""
Demonstrates how an abandoned lock can cause a deadlock
"""

import threading

COUNT = 0

LOCK1 = threading.Lock()
LOCK2 = threading.Lock()
LOCK3 = threading.Lock()


def dead_lock(thread_name, lock_a, lock_b):
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

        # TOFIX: add try/finally block to release locks
        # OR use locks with context managers
        if COUNT == 10:
            raise OSError(f"{thread_name} unexpectedly terminated")

        lock_b.release()
        lock_a.release()


def main_thread():
    # locks are prioritised
    counter1 = threading.Thread(target=dead_lock, args=("counter1", LOCK1, LOCK2))
    counter2 = threading.Thread(target=dead_lock, args=("counter2", LOCK2, LOCK3))
    counter3 = threading.Thread(target=dead_lock, args=("counter3", LOCK1, LOCK3))

    counter1.start()
    counter2.start()
    counter3.start()

    # an example scenario causing the dead lock:
    # - counter1 grabs LOCK1 and LOCK2 then crashes before releasing
    # - counter2 awaits for LOCK2 to be released indefinitely
    # - counter3 awaits for LOCK3 to be released indefinitely

    # solution would be to create try/finally block to release the lock upon
    # an OSError occurring
    # alternatively, use context managers when acquiring the locks

    counter1.join()
    counter2.join()
    counter3.join()

    print(f"COUNT: {COUNT}")


if __name__ == "__main__":
    main_thread()
