"""
Find the kth smallest array in a given array. You are not allowed to sort
the list (using sorted() or list.sort()).

Example:
    n = [1, 4, 6, 3], k = 2
    answer = 3

    As 3 is second smallest value in the list
"""

# I did not finish, I tried to swap elements as I went for a 0(n) time
# complexity
# I did not finish sadly...

nums = [3, 4, 1, 5, 4, 4]
k = 2

# answer == 3


def solution(nums, k):
    """
    This does not work as we would have to iterate over the list
    every time we check and find a val1 > val2; the swapped value
    would have to be compared backward which is very inefficient.

    Even if I finished this it would be a poor answer.

    What I was trying to do was BUBBLE SORT
    """
    index = 0
    while index < len(nums) - 1:
        index1 = index
        index2 = index + 1
        val1 = nums[index1]
        val2 = nums[index2]

        if val1 > val2:
            nums[index1] = nums[index2]
            nums[index2] = nums[index1]

        index += 1

    # FAILED SUBMITTED SOLUTION
    return nums[k - 1]


def bubble_sort(arr):
    total_length = len(arr)

    # Traverse through all array elements
    for index1 in range(total_length):
        # Last i elements are already in place
        for index2 in range(0, total_length - index1 - 1):
            # traverse the array from 0 to n-i-1
            # Swap if the element found is greater
            # than the next element
            if arr[index2] > arr[index2 + 1]:
                arr[index2], arr[index2 + 1] = arr[index2 + 1], arr[index2]
    return arr


def solution2(arr, k):
    bubble_sort(arr)
    return arr[k-1]


assert solution2(nums, k) == 3
