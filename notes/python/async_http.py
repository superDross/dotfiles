"""
Demonstrates how to perform async requests
"""

import asyncio
import datetime
import json
from pprint import pprint

import aiohttp

URLS = [
    "https://api.github.com/orgs/python",
    "https://api.github.com/orgs/django",
    "https://api.github.com/orgs/pallets",
    "https://api.github.com/orgs/php",
    "https://api.github.com/orgs/ruby",
    "https://api.github.com/orgs/perl",
    "https://api.github.com/orgs/javascript",
    "https://api.github.com/orgs/npm",
]


def write_to_file(data):
    with open("repo_data.json", "w") as jf:
        json.dump(data, jf)


async def fetch(session, url):
    async with session.get(url) as response:
        data = await response.json()
        return {"name": data["name"], "avatar_url": data["avatar_url"]}


async def main():
    async with aiohttp.ClientSession() as session:
        data = await asyncio.gather(*[fetch(session, url) for url in URLS])
        pprint(data)
        write_to_file(data)


start = datetime.datetime.now()
asyncio.run(main())
print(f"{(datetime.datetime.now() - start).total_seconds()} seconds have passed")
