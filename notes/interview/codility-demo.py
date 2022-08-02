"""
This is a demo task.

Write a function:

    def solution(A)

that, given an array A of N integers, returns the smallest positive integer (greater than 0) that does not occur in A.

For example, given A = [1, 3, 6, 4, 1, 2], the function should return 5.

Given A = [1, 2, 3], the function should return 4.

Given A = [−1, −3], the function should return 1.

Write an efficient algorithm for the following assumptions:

        N is an integer within the range [1..100,000];
        each element of array A is an integer within the range [−1,000,000..1,000,000].

"""


def solution(A):
    lmin = min(A)
    lmax = max(A)

    if lmax <= 0 and lmin <= 0:
        return 1

    full_list = set(range(lmin, lmax + 1))
    diff = set(A).symmetric_difference(full_list)
    if not diff:
        return lmax + 1
    return max(diff)


assert solution([1, 3, 6, 4, 1, 2]) == 5
assert solution([-1, -3]) == 1
assert solution([1, 2, 3]) == 4
assert solution([-1, -3, 1, 2, 4]) == 3

# only passed 1/5 performance and 1/5 additional tests
