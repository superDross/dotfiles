"""
AsyncIO

See the [corotine notes](python/coroutine.py) for more details.

Keywords:

    async; marks a function as an asynchronous generator or coroutine.

    await; tells the event loop to suspend function until what you are waiting on
           returns and do something else in the meantime.


Example Usage:

Lets say you have to make requests to 3 different servers.

If one of the requests takes too long then it will slow down the rest of the program.


AysncIO is not threading nor multiprocessing, it is a different way to write concurrent code.

It has a single thread, single process design; via cooperative multitasking.

It uses coroutines and scedulers to achieve this.


Coroutines; generators that consume data, but does not generate it.

Tasks; scheduler for coroutines.

Event Loop; a central executor in asyncio.

- the event loop is running in a thread
- it grabs tasks from the queue
- each task calls next step of the coroutine
- coroutine calls another coroutine e.g. await coroutine-name

"""


