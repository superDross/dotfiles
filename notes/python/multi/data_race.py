"""
Demonstrates data races and how to prevent them using a lock.
"""

import threading

COUNT = 0
LOCK = threading.Lock()


class CounterThread(threading.Thread):
    def run(self):
        global COUNT
        for i in range(1_000_000):
            LOCK.acquire()
            # three seperate operations here; read, modify & write
            COUNT += 1
            LOCK.release()


def main_thread():
    counter1 = CounterThread()
    counter2 = CounterThread()
    counter1.start()
    counter2.start()
    counter1.join()
    counter2.join()
    # should equal 2 million
    # however, without a lock, the 2 threads are reading, modifying & writing at different stages
    # thereby overriding the count value
    print(f"COUNT: {COUNT}")


if __name__ == "__main__":
    main_thread()
