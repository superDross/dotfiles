"""
Binary search looks for a particular item by comparing the middle most item of the sorted
collection.

If a match occurs, then the index of item is returned.

If the middle item is greater than the item, then the item is searched in the sub-array
to the left of the middle item.

Otherwise, the item is searched for in the sub-array to the right of the middle item.

This process continues on the sub-array as well until the size of the subarray reduces to zero.

Time Complexity: O(log n)
"""

numbers = list(range(1000))

del numbers[500]


def binary_search(numbers: list[int], target: int) -> int:
    mid_idx = int(len(numbers) / 2)
    start_idx = 0
    end_idx = len(numbers)

    # if the start index is equal or greater than the end then target not found
    while start_idx <= end_idx:

        # get the midpoint between the sublist
        mid_idx = (start_idx + end_idx) // 2

        # if target is greater than the midpoint then increase the start of the sub array
        if target > numbers[mid_idx]:
            start_idx = mid_idx + 1

        # if target is lesser than the midpoint then decrease the end of the sub array
        elif target < numbers[mid_idx]:
            end_idx = mid_idx - 1

        else:
            # found so return
            return mid_idx

    # signifies that the number is not present in the array
    return -1


assert binary_search(numbers, 600) == 599
assert binary_search(numbers, 500) == -1
