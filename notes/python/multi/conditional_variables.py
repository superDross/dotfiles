import threading


NUMS_LEFT = 11
LOCK = threading.Lock()
# a queue for threads to wait
CONDITION = threading.Condition(lock=LOCK)


def number_deducter_non_conditional(thread_id):
    """
    Without a condition variable, we find most threads spend their time waiting for
    their turn.
    """
    global NUMS_LEFT

    while NUMS_LEFT > 0:
        with LOCK:
            if thread_id == (NUMS_LEFT % 5):
                NUMS_LEFT -= 1
                print(f"Thread {thread_id} is deducting a value")
            else:
                print(f"Thread {thread_id} is waiting for their turn")


def number_deducter(thread_id):
    global NUMS_LEFT

    while NUMS_LEFT > 0:
        with LOCK:
            while thread_id != (NUMS_LEFT % 5) and NUMS_LEFT > 0:
                print(f"Thread {thread_id} is waiting for their turn")
                CONDITION.wait()
            if NUMS_LEFT > 0:
                NUMS_LEFT -= 1
                print(f"Thread {thread_id} is deducting a value")
                # notify the queue that the lock has been released, so another thread can grab it
                CONDITION.notify_all()


def main_thread():
    # you will find they are spending must of there time waiting for their turn
    for thread_id in range(5):
        threading.Thread(target=number_deducter, args=(thread_id,)).start()


if __name__ == "__main__":
    main_thread()
