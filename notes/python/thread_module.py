""" Threading

A good explanation:
https://medium.com/@bfortuner/python-multithreading-vs-multiprocessing-73072ce5600b


NOTE: If you are doing something that is more IO bound, such as reading from many
      sockets in a network application, or calling out to subprocess, you can get
      performance increases from threads.

NOTE: If what you are doing is more CPU bound then multiprocessing is more useful.
      If you use multithreading in this scenario then it may even slow down the process.

Doing multiple calulations in threads is going to dramatically degrade performance.
This is specific to Python and is due to the Global Interpreter Lock (GIL).

Process; an instance of program (e.g. Jupyter notebook, Python interpreter).

Threads (subprocesses); processes spawn threads to handle subtasks like
                        reading keystrokes, loading HTML pages, saving files.

Threads live inside processes and share the same memory space.

Multithreading; multiple threads (subprocesses) that exist within the context
of a process such that they execute independently but share their process resources.

Because of the GIL, threads in Python does not execute code simultaneously,
instead they run concurrently.

Concurrency;  when two or more tasks can start, run, and complete in overlapping time
periods. It doesn't necessarily mean they'll ever both be running at the same instant.
For example, multitasking on a single-core machine.

Parallelism; when tasks literally run at the same time, e.g., on a multicore processor.
"""
import os
import time
from queue import Queue
from threading import Thread


def pointless_task(number):
    """
    IO task adding number to a file after sleeping.
    """
    number *= 3
    os.system(f"sleep {number} ; echo {number} sec >> f.txt")
    return number


def main():
    """
    Parse 2, 3 and 4 to pointless_task iteratively.
    """
    ts = time.time()
    os.system("echo SERIAL-THREAD >> f.txt")
    for number in range(2, 5):
        pointless_task(number)
    t = round(time.time() - ts, 3)
    os.system(f"echo Time Taken: {t}s >> f.txt")
    os.system(f"echo ---------- >> f.txt")


def threading_main():
    """
    Multi-threading version of main().

    All 3 tasks will be run simultaneously,
    therefore it takes less time to complete
    the script.
    """
    os.system("echo MULTI-THREADING >> f.txt")
    ts = time.time()
    # Put the tasks into the queue as a tuple
    for number in range(2, 5):
        th = Thread(target=pointless_task, args=(number,))
        th.start()
    t = round(time.time() - ts, 3)
    os.system(f"echo Time Taken: {t}s >> f.txt")
    os.system(f"echo ---------- >> f.txt")


class Worker(Thread):
    """
    A thread that runs in the background to complete a task.
    """

    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue

    def run(self):
        while True:
            number = self.queue.get()
            try:
                pointless_task(number)
            finally:
                self.queue.task_done()


def threading_queue_main():
    """
    Multi-Threading version of main() that uses queues.
    """
    os.system("echo MULTI-THREADING >> f.txt")
    ts = time.time()
    queue = Queue()
    # Create 8 worker threads
    for _ in range(8):
        worker = Worker(queue)
        worker.daemon = True
        worker.start()
    # put all tasks into the queue
    for number in range(2, 5):
        queue.put(number)
    # Causes the main thread to wait for the queue to be depleted.
    queue.join()
    t = round(time.time() - ts, 3)
    os.system(f"echo Time Taken: {t}s >> f.txt")
    os.system(f"echo ---------- >> f.txt")


if __name__ == "__main__":
    main()
    threading_queue_main()
    threading_main()
