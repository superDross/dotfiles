"""
Example showing how to use a re-entrant lock
"""

import threading

COUNT = 0
LOCK = threading.RLock()


class CounterThread(threading.Thread):
    def run(self):
        global COUNT
        if COUNT < 100:
            LOCK.acquire()
            COUNT += 1
            # using threading.Lock() this will halt the program indefinetly
            # as the lock has been activated twice before being unlocked
            self.run()
            LOCK.release()


def main_thread():
    counter1 = CounterThread()
    counter2 = CounterThread()
    counter1.start()
    counter2.start()
    counter1.join()
    counter2.join()
    print(f"COUNT: {COUNT}")


if __name__ == "__main__":
    main_thread()
