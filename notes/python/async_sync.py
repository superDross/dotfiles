import asyncio
import datetime
import requests
import time

# CALLING SYNC CODE IN ASYNC SCRIPT


def sync_request(delay):
    """
    Simulates an synchronous API call.
    """
    time.sleep(delay)  # simulate network call delay
    return requests.get("https://api.github.com/orgs/python")


async def async_sleep(seconds):
    await asyncio.sleep(seconds)


async def main():
    # Asynchronously run a blocking IO sync function in a seperate thread using to_thread(),
    # this prevents the function execution from blocking the thread that the event loop is
    # running within.
    # Due to the GIL, this should only ever be used for IO based tasks.
    response = await asyncio.gather(
        async_sleep(2), asyncio.to_thread(sync_request, delay=2)
    )
    return response


start = datetime.datetime.now()
asyncio.run(main())
print(f"{(datetime.datetime.now() - start).total_seconds()} seconds have passed")


# CALLING ASYNC CODE IN SYNC SCRIPT


async def get_database_id():
    """
    Pretend async db call to get an id.
    """
    await asyncio.sleep(3)
    return 3


async def check_id_is_valid(double_id):
    """
    Pretend async request call to determined validality of id.
    """
    await asyncio.sleep(3)
    return True


def double_id(id):
    return id * 2


def sync_main():
    # Essentially have to run async code in its own event loop,
    # each event loop is blocking so the proceeding code will not run
    # until event loop has finished.
    # Creating a new event loop to run each async code feels inefficient...
    db_id = asyncio.run(get_database_id())
    doubled = double_id(db_id)
    if asyncio.run(check_id_is_valid(doubled)):
        return True
    return False


start = datetime.datetime.now()
result = sync_main()
print(f"{result} is the id doubled")
print(f"{(datetime.datetime.now() - start).total_seconds()} seconds have passed")
