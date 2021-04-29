"""
A basic example of the producer-consumer pattern.
"""

import logging
import queue
import threading
import time

logging.basicConfig(level=logging.INFO, format="")

# a FIFO queue which maintains its own threading lock and conditional variables
# the source code is very cool (and beautiful), worth a look.
QUEUE = queue.Queue(maxsize=5)


def producer():
    """
    Puts messages into a queue.
    """
    for n in range(1, 21):
        # adds to the queue without blocking
        QUEUE.put_nowait(item={"id": n})
        logging.info(
            f"Adding message with id {n} - remaining queue capacity: "
            f" {QUEUE.maxsize - QUEUE.qsize()}"
        )
        # processing time
        time.sleep(0.2)


def consumer():
    """
    Consumes messages from a queue.
    """
    while True:
        message = QUEUE.get()
        logging.info(f"consumed message: {message}")
        # consumption time
        time.sleep(0.3)


def main_thread():
    # two consumers to keep up with the producer and queues max size
    # although scaling consumers won't work for cpu intensive tasks (blame the GIL).
    for _ in range(2):
        threading.Thread(target=consumer).start()
    threading.Thread(target=producer).start()


if __name__ == "__main__":
    main_thread()
