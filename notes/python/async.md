# AsyncIO

## Terminology

**Coroutines**; generators that consume data, but does not generate it

**Tasks**; used to schedule coroutines concurrently

**Futures**; an eventual result (like a Promise in JS)

**Event Loop**; a central executor in asyncio

**Async**; turns a function into an coroutine

**Await**; tells the event loop to suspend the coroutine until IO (say waiting request response) task is completed and execute another coroutine in the meantime


## Explanation

AsyncIO allows one to run multiple tasks concurrently and specifically when these tasks should run concurrently using the await keyword.

An event loop is ran in a *single thread* and is used to manage multiple coroutines to ensure they all run concurrently.

Coroutines in the event loop run synchronously until they hit an await (something blocking that is IO bound like waiting for an network to respond) at which point the event loop pauses the coroutines task and executes another one in the task queue until the network responds on the original task. Then it switches back to complete the initial task. This constant switching is concurrency and saves valuable wasted time compared to synchronous code.

Everything that's paused has an associated trigger that will wake it up again - some are time-based, some are
network-based, and most of them are waiting for a result from another coroutine.


TLDR;

- The event loop is running in a thread
- It grabs tasks from the queue
- Each task calls next step of the coroutine
- Coroutine calls another coroutine (if chained) e.g. await coroutine-name
- When a blocking event occurs (e.g. waiting on a network response) the task is paused
- Another task is grabbed from the queue
- When the blocking event in the initial task is finished we switch back to it and pause the other task



## Differences to Multithreading

Coroutines have to explicitly give up control via an await. This is different to threads or greenlets which context-switch at ANY time.

You are essentially deciding when the context switch occurs.

 Async functions need to run on an event loop, and while they can call synchronous functions, it's dangerous.
 Sync functions just run on bare Python, and to have them call to asynchronous functions you need to either find or make
 an event loop to run the code in.

 
 ## AsyncIO Code

 `asyncio.run()`; creates, manages and closes the event loop, consumes a parent coroutine.

 `asyncio.gather()`; runs coroutines concurrently by scheduling tasks for each coroutine and executing them at once

`asyncio.create_task()`; schedules the execution of a coroutine thereby preparing it for concurrent execution

`asyncio.to_thread()`; transforms a synchronous function into a coroutine and run its in a separate thread as to not block the event loop (only works with IO based functions).
