import threading
import random


COUNTS = 0
LOCK = threading.Lock()
# does not work
BARRIER = threading.Barrier(10)


def incement_count():
    global COUNTS
    with LOCK:
        COUNTS += 3
    # prevent threads from proceding until something
    BARRIER.wait()


def double_count():
    BARRIER.wait()
    global COUNTS
    with LOCK:
        COUNTS *= 2


def generate_child_threads():
    threads = []
    for _ in range(5):
        threads.append(threading.Thread(target=incement_count))
        threads.append(threading.Thread(target=double_count))

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
