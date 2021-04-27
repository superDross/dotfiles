"""
Non-blocking lock demo.
"""

import time
import threading

COUNT = 0
REQUIRED = 20
LOCK = threading.Lock()


class CounterThread(threading.Thread):
    def run(self):
        global COUNT
        while COUNT < REQUIRED:
            # nonblocking lock
            if LOCK.acquire(blocking=False):
                print(f"{self._name}:: incrementing count...")
                COUNT += 1
                LOCK.release()
                # fake processing time
                time.sleep(0.01)
            else:
                print(f"{self._name}:: doing other task...")


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
