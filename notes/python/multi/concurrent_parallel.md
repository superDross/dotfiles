# Python Parallel and Concurrent Programming

Based off the linkedin course(s)

Mutliple script examples are present within the same directory as this document.

## Process Vs Threads

Thread part of a process (process = a processor task).

They share the process address space which gives them access to the same resources and memory as the process (which includes the code and the data).

Different processes can not share data (not easily anyway).

Threads

- require less overhead to create and terminate
- OS can switch between threads faster than processes


## Concurrency vs Parallel

### Concurrency

Two independent threads using the same processor, so task switching; not happening at the same time.

IO operations are processed concurrently, as they are used infrequently.

### Parallel

Multiple CPUs (or muli-core processors) allows for multiple processes happening at the same time.

Computational heavy tasks are better to use multiple processors; math operation can be subdivided and distributed to different processors. So in this case we would be using parallel threads; derive from my process but the threads are distributed to different cores.

Single CPUs can have multiple cores which can access separate processes. Some CPUs have hyper-threading which allows the user to execute 2 independent processes in a single core. So 4 cores can be treated as 8 logical processors.

Hyper-threading can only be used if the resources are available, so is not exactly like have double the cores.

## GIL

The Global Interpretor Lock (GIL) make this impossible in python.

Prevents multiple python threads from executing at the same time.

Interpreter compiles your Python program into bytecode which is then executed to a virtual machine.

CPython uses the GIL to provide thread-safe memory management, by only letting one thread execute at a time.
CPython memory management is not thread-safe, hence the need for the GIL.

We can still use multi-threads with IO based tasks.

### Advantages

- increases the speed of single-threaded programs
- easy integration of C libraries which are not thread safe
- does not affect IO based tasks

## With Python

As the GIL does not affect IO based tasks we can still use multi-threading for it (using the `threading` library)

For computational heavy task we cannot use multi-threading as they act concurrently in python.

Instead, we can use multiple processes instead of multiple threads (using the `mutliprocessing` library)

Each process will be its own instance of the Python interpreter with its own GIL, so the separate processes can execute in parallel.

The negatives of using multiprocessing over multiple threads:
  - communicating between different processes is very difficult
  - uses more system resources than threads


## Scheduling

OS schedules processes and threads to run on available CPUs, by placing them within a queue.

When processes are switched, the stopped tasks state is saved and resumed when the process leaves the queue again

There are different scheduling algorithms for different purposes.

## Thread Lifecycle

When a new process begins it starts with one thread (the main thread) which can spawn additional child threads that are part of the same process.

Child threads derived from the main thread can also spawn there own child threads.

When child threads finish executing they notify the parent and terminate.

This continues until the main thread is the only thread left.

### States

#### New State

The child thread is spawned but not running (not consuming cpu resources)

The code it is to executed is assigned to it and is started.

#### Runnable State

The OS can schedule the child thread to execute and be swapped out with other threads to run on one of the available processors.

The main thread can then continue its tasks when it is is scheduled onto the processor.

#### Blocked State

When a thread needs to wait for an event to occur (external input or timer) it goes into a blocked state.

This means the thread is not using any CPU resources (which can be utilised by another thread).

It is returned to a runnable state by the OS when the event is over.

If a main thread is dependant upon a child thread completing, the main thread can call the `join()` method.

This causes the main thread to enter a blocked state until the child thread enters the terminated state.

#### Terminated State

When the execution of the thread has completed, or if an error occurs, the thread enters a terminated state.


## Daemon Thread

A background thread that does not prevent the main process from terminating.

This daemon thread is detached from the main thread and can only terminate when all non-daemon threads have stopped running.

Daemon threads can therefore be terminated abruptly which could be an issue if you are doing an IO task.

Make sure no negative side effects will occur when creating a daemon thread.


### Caveats

- Daemon threads will inherit daemon status from their parent thread.
- Daemon threads do not gracefully exit, they are abruptly killed (not great for IO tasks)

### Example

Garbage collector; automatic memory management which attempts to reclaim memory no longer in use by the program

If you had the garbage collector as a child thread then the main thread could never exit as the collector will always
be running in a continuous loop.

Asserting the garbage collector as a daemon thread prevents this from happening.


## Locking (AKA Mutual Exclusion)

Data races occur when one thread is accessing the same memory location as another thread that is modifying it.

A lock/mutex only allows one thread to do the operation at any given time.

### Re-entrant Locks

Can be blocked multiple times by the same thread but must be unlocked as many times as it has been locked

Some think the above code snippet should be refactored to not use nested locking instead of using an re-entrant lock

`threading.Lock` can be released by a different thread that was used to acquire it, `threading.Rlock` cannot as it must be released by the same thread.

`Rlock` must also be unlocked the same number of times it has been unlocked


### Try Locks (Non-blocking lock)

A non blocking lock mechanism that allows to do other things if the lock can't be acquired.


### Read-Write Lock

Only locks when writing to the resource (does not care about locking when multiple threads are reading).

If a writer has locked it though, a read lock will not able to be established.

However, multiple read locks can be acquired at once.

More complicated logic, uses more resources, but can increase performance of your program


## Liveness

Properties that require a system to make progress; avoid dead locking.

A way to get around this issue is to make sure each thread tries to grab the **same** lock. So only one thread has the lock at the same time.

### Dead Lock

When a thread tries to activate a lock that it already locked, it will be permenantely locked.

This usually occurs when mutliple threads are trying to access the same locks (note the plural here).

This can happen when your program needs to lock an operation multiple times before unlocking it
e.g. due to nested locks or within a recursive function.

```python
increment_counter():
    lock()
    counter++
    unlock()

def increment_and_say_hi() :
    # nested locking here
    lock()
    print("hi")
    increment_counter()
    unlock()
```

One way to get around this is to prioritise the locking, by ordering them.

If a thread can not know which lock it will consume, we can place a timeout. This will cause it to back up and free up all the locks once the timeout has been reached and wait a random amount of time before retrying.

### Abandoned Lock

Dead lock via thread death; thread does not release the lock before it terminates (unexpectedly).

Then the other thread awaiting the lock is in a form of dead lock.

Use a try/finally block to release the locks or use locks with context managers to fix.

### Starvation

A thread is constantly denied access to a resource, which means it cannot be executed

This can occur when there are too many competing threads or when prioritising threads

This is a very real problem; think of a server creating a thread for every user request.

Starvation means we would have to wait for the first user request to be created before continuing.

### Livelock

Two threads block each other by trying to unblock each other; usually due to an algorithm designed to unblock
then actually blocks them. The irony...

Add a mechanism that randomly determines which thread goes first, will prevent the issue.
