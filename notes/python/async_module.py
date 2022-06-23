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



TODO: read more about how this works


https://www.aeracode.org/2018/02/19/python-async-simplified/

Everything runs on an event loop. This loop allows one to run several coroutines at once.
Coroutines run synchronously until they hit an await and then they pause, give up control
to the event loop. The event loop then allows another coroutine to be active.

TLDR; coroutines have to explicitly give up control via an await. This is different to threads or
greenlets which context-switch at ANY time.
"""

# Simple example showing how to chain coroutines


import asyncio
import datetime


async def sleep_five():
    await asyncio.sleep(5)
    print("sleep five done")


async def sleep_three_then_five():
    await asyncio.sleep(3)
    await sleep_five()
    print("sleep three then five done")


async def main():
    await asyncio.gather(sleep_five(), sleep_three_then_five())


start = datetime.datetime.now()
asyncio.run(main())
print(f"{(datetime.datetime.now() - start).total_seconds()} seconds have passed")
