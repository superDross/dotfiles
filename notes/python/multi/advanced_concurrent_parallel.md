# Advanced Parallel and Concurrent Programming

Example scripts are available in the same dir as this document.

Celery is used to asynchronously distribute work across threads or machines

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


### Race Conditions & Barriers

Data races occur when two or more threads concurrently access the same memory location.

Race conditions are flaws in timing ordering that causes undesirable behaviour.

They can occur together or apart.

Barriers can prevent a group of threads from proceeding until enough threads have reached the barrier, thereby preventing a race condition.


##  Asynchronous Tasks


### Computational Graph

Help to visualise the asynchronicity and order of executables.

Can determine the critical path; path that takes the longest time to execute.

Its a visual helper nothing more. Not sure how much utility this has for me.


### Thread Pool

Thread pool; creates and maintains a collection of worker threads

It reuses existing worker threads to execute tasks (efficient).

Sometimes this is more efficient than creating numerous threads.

This is more efficient as we are reusing threads, instead of recreating them, we reduce the overhead involved with creating new ones.

This is an advantage only when the time it takes to execute the task is **less** than the time required to create a new thread.


### Future

Future; A placeholder for a result that will be available later (like promises in JS)

An asynchronous task will eventually write the result to the Future when it is finished processing.


### Divide & Conquer Algorithms

1. divide the problem into subproblems of equal size
2. recursively solve the subproblems
3. combine the solutions to the subproblems


They can be parallel in different processors.

The example was not good or clear to me, find another.


## Evaluating Parallel Performance

### Speedup, Latency & Throughput

Strong Scaling; breaking down and spreading a problem across multiple processors to execute the program faster

Throughput; number of tasks over time

Latency; the amount of time to complete a task

Speedup; ratio of the sequential execution time over the parallel execution time with N workers (so how much faster it becomes when adding additional processes)

Throughput would increase as you add more processors; applying strong scaling. Which would increase the speedup ratio


### Amdahl's Law

Estimating speedup for entire program. Useful for determining whether it is worth parallelizing a program.

Overall Speedup = 1 / (1 - P) + (P/S)

P = portion of program thats parallelizable
S = speedup of the parallelized portion

Example, we know that 95% of our program can be executed in parallel and using two processors equals a speedup of 2:

P = 0.95
S = 2

Overall Speedup = 1 / ( (1 - 0.95) + (0.95 / 2) )= 1.9

The higher S (speedup; number of processors) the higher the overall speedup, **but** eventually the 5% sequentially executed code will create an upper limit. So no matter how many processors you throw at the problem, eventually it will not be able to go faster.


### Measuring Speedup

Speedup; ratio of the sequential execution time over the parallel execution time with N workers (so how much faster it becomes when adding additional processes)

Efficiency; how well additional resource are utilised.

Efficiency = speedup / n. processors


Example, we have a task that sequentially took 25 seconds but parallelised took 17 seconds

speedup = 25 / 17 = 1.47

efficiency = (1.47 / 2) * 100 = 73.5%

You may want to warm up your code before measuring speedup


## Designing Parallel Programs

There 4 stages:

- partitioning
- communication
- agglomeration
- mapping

### Partitioning

Domain decomposition; break down data into smaller chunks where each chunk is processed by a different thread

Cyclic decomposition; threads cyclic process data

Functional decomposition; divides the work based on task and data. These are then grouped based on them.

### Communication

Only required sometimes, usually when the threads need to know what the other is doing for co-ordinating task order.

Co-ordinate task execution between threads.

Overhead; compute time/resources spent on communication

Bandwidth; amount of data communicated per seconds (GB/s)

### Agglomeration

Fine Grained Parallelism

- Large number of small tasks
- Good distribution of workload (load balancing)
- Low computation to communication ratio (lots of computation to break down the task)

Coarse Grained Parallelism

- Small number of large tasks
- Less time splitting up tasks and more time processing the data
- Inefficient load balancing

Usually a middle ground is found between both these agglomeration methods.

Keep flexibility in mind when designing so you can add more CPU etc.

### Mapping

OS usually do this; scheduling task.

Only needed for distributed systems.
