"""
Demonstrates the producer-consumer pattern for CPU heavy tasks.
"""

import logging
import multiprocessing as mp
import time

logging.basicConfig(level=logging.INFO, format="")

# queues specifically for cpu intensive tasks
QUEUE = mp.Queue(maxsize=5)


def cpu_task(n):
    x = 0
    for work in range(n * 1_000_000):
        x += 1


def producer():
    """
    Puts messages into a queue.
    """
    for n in range(1, 21):
        # adds to the queue without blocking
        QUEUE.put_nowait({"id": n})
        logging.info(
            f"Adding message with id {n} - remaining queue capacity: "
            f" {QUEUE._maxsize - QUEUE.qsize()}"
        )
        time.sleep(0.2)


def consumer():
    """
    Consumes messages from a queue.
    """
    while True:
        message = QUEUE.get()
        logging.info(f"consumed message: {message}")
        # CPU heavy task
        cpu_task(80)


def main_thread():
    # we can scale process up for the consumer for cpu intensive tasks
    for _ in range(10):
        mp.Process(target=consumer).start()
    mp.Process(target=producer).start()


if __name__ == "__main__":
    main_thread()
