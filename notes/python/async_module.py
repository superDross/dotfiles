"""
Simple example showing how to chain coroutines.
"""


import asyncio
import datetime


# Async converts the function into a coroutine
async def sleep_five():
    # Await explicitly gives up control of the coroutine to the event loop and suspends it until IO task is finished,
    await asyncio.sleep(5)
    print("sleep five done")


async def sleep_three_then_five():
    # The below commented code is run synchronously
    # await asyncio.sleep(3)
    # await sleep_five()

    # The create_task function can be used to run coroutines concurrently, an alternative
    # to asyncio.gather()
    # This is essentially what asyncio.gather() is abstracting away.
    task1 = asyncio.create_task(asyncio.sleep(3))
    task2 = asyncio.create_task(sleep_five())
    await task1
    await task2

    print("sleep three then five done")


async def main():
    # use gather to run coroutines concurrently
    # all coroutines are scheduled as tasks and run concurrently, all produced values are returned
    await asyncio.gather(sleep_five(), sleep_three_then_five())


def async_run(func_call):
    """
    Demonstrates what async.run() is actually calling.

    Create an event loop, set the loop in the global space and run async function until complete.

    The event loop is added to the global state inside asyncio so you don't have to parse the event
    loop explicitly to each coroutine.
    """
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    return loop.run_until_complete(func_call)


start = datetime.datetime.now()
# Method run() runs the parsed coroutine, taking care of creating & managing the asyncio event loop,
# finalizing asynchronous generators, & closing the threadpool.
asyncio.run(main(), debug=True)
print(f"{(datetime.datetime.now() - start).total_seconds()} seconds have passed")
