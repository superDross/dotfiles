"""
Binary search looks for a particular item by comparing the middle most item of the
collection.

If a match occurs, then the index of item is returned.

If the middle item is greater than the item, then the item is searched in the sub-array
to the left of the middle item.

Otherwise, the item is searched for in the sub-array to the right of the middle item.

This process continues on the sub-array as well until the size of the subarray reduces to zero.
"""

from typing import List, Optional


def middle_index(items: List[int]) -> int:
    pos = int(abs(len(items) / 2))
    return pos


def binary_search_iterative(items: List[int], item: int) -> Optional[int]:
    sorted_items = sorted(items)
    previous_index = 0
    while True:
        index = middle_index(sorted_items)
        # index position in the original list of items
        actual_index = index + previous_index
        mid_item = sorted_items[index]
        if mid_item == item:
            return actual_index
        elif item > mid_item:
            sorted_items = sorted_items[index:]
            previous_index += index
        elif item < mid_item:
            sorted_items = sorted_items[:index]


def binary_search(
    items: List[int], item: int, previous_index: int = 0
) -> Optional[int]:
    """
    Recursive solution
    """
    sorted_items = sorted(items)
    index = middle_index(sorted_items)
    # index position in the original list of items
    actual_index = index + previous_index
    mid_item = sorted_items[index]
    if mid_item == item:
        return actual_index
    elif item > mid_item:
        sorted_items = sorted_items[index:]
        previous_index += index
        return binary_search(sorted_items, item, previous_index)
    elif item < mid_item:
        sorted_items = sorted_items[:index]
        return binary_search(sorted_items, item, previous_index)
    return None


# Basic example
items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for item in items:
    try:
        ans = binary_search(items, item=item)
        assert ans == item - 1
    except AssertionError:
        AssertionError(f"Input={item}, Expected={item-1}, Answer={ans}")


# Odd number length of items
items = [1, 2, 3, 4, 5, 6, 7, 8, 9]
for item in items:
    try:
        ans = binary_search(items, item=item)
        assert ans == item - 1
    except AssertionError:
        AssertionError(f"Input={item}, Expected={item-1}, Answer={ans}")


# Unsorted numbers
items = [10, 34, 56, 8990, 90]
assert 0 == binary_search(items, item=10)
assert 4 == binary_search(items, item=8990)
assert 3 == binary_search(items, item=90)


# Negative numbers
items = [900, 78, -4, -5, 8990, 1]
assert 0 == binary_search(items, item=-5)
assert 2 == binary_search(items, item=1)
assert 5 == binary_search(items, item=8990)
