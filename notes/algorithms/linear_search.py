"""
Linear searching requires one to search sequentially over all items in a list
and returns the items index if found.
"""

from typing import List, Optional


def linear_search(items: List[int], desired_item: int) -> Optional[int]:
    for index, item in enumerate(items, start=0):
        if desired_item == item:
            return index
    return None


l = [10, 20, 40, 50, 77]
item = 40

assert 2 == linear_search(l, item)
