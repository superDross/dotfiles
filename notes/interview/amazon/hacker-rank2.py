"""
You are given an input integer array of n-length.

Sum, for all subarrays:

Minimum in subarray * Sum of subarray.

For instance:

[1,3,4]


min(1) * sum(1) = 1 * 1 = 1
min(1,3) * sum(1,3) = 1 * 4 = 4
min(1,3,4) * sum(1,3,4) = 1 * 8 = 8
min(3) * sum(3) = 3 * 3 = 9
min(3,4) * sum(3,4) = 3 * 7 = 21
min(4) * sum(4) =4 * 4 = 16 1+4+8+9+21+16 = 59

for a returned value of 59
"""


def solution(power: list[int]) -> int:
    """
    Brute force solution that does not work for larger power lists.
    """
    # TODO: consider finding a more efficient solution in your own time
    n = len(power)

    total = 0
    for i in range(n):
        for j in range(i, n):
            if i == j + 1:
                continue
            subarray = power[i:j + 1]
            total += min(subarray) * sum(subarray)
    return total


power = [2, 3, 2, 1]
assert solution(power) == 69

power = [1, 3, 4]
assert solution(power) == 59
