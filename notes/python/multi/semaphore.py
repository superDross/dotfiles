import logging
import random
import time
import threading

logging.basicConfig(level=logging.INFO, format="")

# lock with max counter of 4 (change to 1 to create a binary semaphore)
SEM = threading.Semaphore(value=4)


class Task(threading.Thread):
    def run(self):
        name = threading.current_thread().getName()
        with SEM:
            logging.info(f"START: {name} is doing task...")
            time.sleep(random.randint(1, 3))
            logging.info(f"DONE:  {name} has completed task")


def main_thread():
    # you will see 4 threads utilising the resource at any given time
    for n in range(1, 11):
        Task(name=f"Thread{n}").start()


if __name__ == "__main__":
    main_thread()
