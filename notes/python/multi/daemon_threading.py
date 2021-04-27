"""
A Daemon is a child process that does not block the main thread from terminating
after it has completed its task.

Thereby allowing the main thread to terminate.
"""

import threading
import time
import random
import string


def random_string(length=10):
    return "".join(random.choice(string.ascii_lowercase) for i in range(length))


class GarbageKiller(threading.Thread):
    def run(self):
        while True:
            print(f"killing process {random_string()}")
            time.sleep(0.5)


class GarbageCollector(threading.Thread):
    daemon = True

    def run(self):
        while True:
            print("collecting garbage...")
            # will inherit the daemon status
            child = GarbageKiller()
            child.start()
            time.sleep(1)


def main_thread():
    # child thread
    gc = GarbageCollector()
    gc.start()

    print("MAIN THREAD:: initialising...")
    time.sleep(0.5)

    print("MAIN THREAD:: starting task...")
    time.sleep(0.3)

    print("MAIN THREAD:: processing task...")
    time.sleep(1.1)

    # as the main thread is complete, everything should terminate (including the daemon)
    print("MAIN THREAD:: complete")


if __name__ == "__main__":
    main_thread()
