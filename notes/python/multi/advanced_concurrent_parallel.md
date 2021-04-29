# Advanced Parallel and Concurrent Programming

Example scripts are available in the same dir as this document.

## Synchronisation

### Conditional Variable

Repeatedly checking for a certain condition is pretty inefficient & will result in the thread spend most of its time waiting.

```python
while some_action != condition:
    if something:
        do_stuff()
    else:
        # wait for threads turn
        continue
```

Condition Variable; Queue of threads waiting for a certain condition to be met.

When a CV is combined with a Mutex it creates a monitor, which protects section of code with mutex and provide a way for threads to block/wait until a condition has been met.

#### Operations

- **Wait**
    - automatically release lock on the mutex
    - got to sleep and enter waiting queue
    - reacquire lock when woken up

- **Signal**
    - wake up one thread from conditional variable queue

- **Broadcast**
    - wakes up all threads in the waiting queue


### Producer-Consumer Pattern

Producer; add elements to shared data structure.

Consumer; removes elements from the shared data structure.

Producer adds to a FIFO queue, consumer grabs it.

This pattern requires some form of mutual exclusion as well as rate limiting properties for adding and removing to/from the queue.

This is especially important to prevent buffer overflows; when the consumer can't keep up with the producer so data is eventually lost (as RAM is finite).

To avoid this, the average rate of consumption must be higher than the average rate of production.

Pipeline; a series of consumer-producer pairs with queues.


### Semaphore

Like a mutex/lock but can allow multiple threads to access the resource at the same time.

#### Counting Semaphore

It uses a counter to track availability. As long as the semaphores counter is positive, any thread can grab the resource otherwise the thread is blocked and moved to a wait queue.

When a thread acquires the semaphore its counter is decremented.

When a thread releases the semaphore its counter is incremented.


#### Binary Semaphore

No counter, can only be locked or unlocked like a normal mutex.

The difference is that a mutex can only be acquired/released by the same thread, while a semaphore this can be aqcuired/released by separate thread.


### Race Conditions

Data races occur when two or more threads concurrently access the same memory location.

Race conditions are flaws in timing ordering that causes undesirable behaviour.

They can occur together or apart.

Barriers can prevent a group of threads from proceeding until enough threads have reached the barrier, thereby preventing a race condition.
