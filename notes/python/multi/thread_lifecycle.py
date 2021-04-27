"""
Basic demonstration of the thread lifecycle
"""

import threading
import time


def is_thread_alive(thread):
    alive = "yes" if thread.is_alive() else "no"
    print(f"Is {thread.name} thread alive: {alive}")


class ChildThread(threading.Thread):
    def run(self):
        print("Child thread starting and waiting for event...")
        time.sleep(3)
        print("Child thread has completed the event")


def main_thread():
    # New state
    print("Main thread started and requesting child threads help")
    child = ChildThread(name="child")

    # Runnable state
    print("Main thread tells child thread to start")
    child.start()
    is_thread_alive(child)

    print("Main thread continues task while child thread works")
    time.sleep(0.5)

    # Blocked state; this essentially blocks the main thread until the child thread has terminated
    print("Main thread waits for child thread to finish by joining")
    child.join()

    # Terminated state
    print("Both main and child threads have completed")


if __name__ == "__main__":
    main_thread()
