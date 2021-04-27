"""
Demonstrates how an starvation can result in one thread performing the entire task.

This is a very real problem; think of a server creating a thread for every user request.

Starvation means we would have to wait for the first user request to be created before continuing.
"""

import threading

COUNT = 0

LOCK1 = threading.Lock()
LOCK2 = threading.Lock()
LOCK3 = threading.Lock()

THREAD_TRACKER = {}


def count(thread_name, lock_a, lock_b):
    """
    Dead locking example resource.

    In a real world example, there would be multiple resources with
    nested locks; each resource having a different lock.

    For demo purposes we have placed the nested locks in the same resource.
    """
    global COUNT
    while COUNT < 50000:
        # nested locks using context managers to prevent abanonded locking
        with lock_a:
            with lock_b:
                COUNT += 1
                # count which thread counted the most
                new_thread_count = THREAD_TRACKER.get(thread_name, 0) + 1
                THREAD_TRACKER[thread_name] = new_thread_count


def main_thread():
    # so many threads only one dominates
    for num in range(1, 201):
        counter = threading.Thread(target=count, args=(f"counter{num}", LOCK1, LOCK2))
        counter.start()
        counter.join()

    print(f"COUNT: {COUNT}")

    for k, v in THREAD_TRACKER.items():
        print(f"{k}: {v}")

    # we will see the first counter (counter1) will have performed the entire
    # operation, as it has the highest priority (as it was created and executed first)

    # resolving this is quite complicated


if __name__ == "__main__":
    main_thread()
