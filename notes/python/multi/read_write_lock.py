import time
import threading
import random

# third-party lib
from readerwriterlock import rwlock


TASKS = [
    "go to gym",
    "eat healthy",
    "find your soul",
    "eat some pencils",
    "punch the toes",
    "smell the grapes",
    "be the plug",
    "jam well no",
    "what is going on",
    "find the meaning of life",
    "learn a language",
    "keep up toast in bread",
    "picture day",
]

DAYS = {
    "monday": [],
    "tuesday": [],
    "wednesday": [],
    "thursday": [],
    "friday": [],
    "saturday": [],
    "sunday": [],
}
# fair and equal priority to both read and write locks
LOCK = rwlock.RWLockFair()


class ReaderThread(threading.Thread):
    def read_reminders(self):
        day = random.choice(list(DAYS.keys()))
        print(f"\n+ Getting reminders for {day}")
        for reminder in set(DAYS[day]):
            print(f"\t- {reminder}")

    def run(self):
        for _ in range(5):
            read_lock = LOCK.gen_rlock()
            read_lock.acquire()
            # number of reading threads should be 2 most of the time
            print(f"\nread lock count: {read_lock.c_rw_lock.v_read_count}")
            self.read_reminders()
            read_lock.release()


class WriterThread(threading.Thread):
    def write_reminder(self):
        time.sleep(0.1)
        day = random.choice(list(DAYS.keys()))
        reminder = random.choice(TASKS)
        print(f"\nwriting task for {day}")
        DAYS[day].append(reminder)

    def run(self):
        for _ in range(10):
            write_lock = LOCK.gen_wlock()
            write_lock.acquire()
            self.write_reminder()
            write_lock.release()


def main_thread():
    writer = WriterThread()
    reader1 = ReaderThread()
    reader2 = ReaderThread()
    writer.start()
    reader1.start()
    reader2.start()


if __name__ == "__main__":
    main_thread()
