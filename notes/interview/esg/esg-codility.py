"""
Task 1


There are N blocks

numbered from 0 to N-1

The frogs want to get as far away as possible from each other.

They can only jump up or to blocks of equal height (they cannot jump down)

Starting block can be any, I have to determine this.


N = [2, 6, 8, 5]

the index represents the column number and the value represents the height

In the above example N should be 3 from position/index 0

"""


def can_jump(_from, to):
    return True if to >= _from else False


def max_distance(sub_blocks):
    max_distance = 1
    index = 0
    for index, value in enumerate(sub_blocks):
        if index + 1 >= len(sub_blocks):
            return max_distance
        if not can_jump(sub_blocks[index], sub_blocks[index + 1]):
            return max_distance
        index += 1
        max_distance += 1


def solution(blocks):
    index = 0
    actual_max_right_distance = 0
    actual_max_left_distance = 0
    total_max_distance = 0

    while index < len(blocks):

        if len(blocks[index:]) > 1:
            max_right_distance = max_distance(blocks[index:])
            if max_right_distance > actual_max_right_distance:
                actual_max_right_distance = max_right_distance

        left_sub = blocks[:index][::-1]
        if len(left_sub) > 1:
            max_left_distance = max_distance(left_sub)
            if max_left_distance > actual_max_left_distance:
                actual_max_left_distance = max_left_distance

        index_max = actual_max_right_distance + actual_max_left_distance
        if index_max > total_max_distance:
            total_max_distance = index_max

        index += 1
        actual_max_right_distance, actual_max_left_distance = 0, 0

    return total_max_distance


N = [2, 6, 8, 5]

assert solution(N) == 3

N = [1, 5, 5, 2, 6]

assert solution(N) == 4

N = [1, 1]

assert solution(N) == 2
