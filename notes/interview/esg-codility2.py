"""
Task 2

We are creating a word machine that should operate like a FIFO structure.

It can consume a string of operations e.g. '13 DUP 4 POP 5 DUP + DUP + 1'

The operations are as follows:
    DUP: duplicate the value at the top of the stack
    POP: remove the value at the top of the stack
    +: add the two values at top of the stack, remove the orignal values and add the result to the top of the stack
    -: sub the two values at top of the stack, remove the orignal values and add the result to the top of the stack
    int: if only an integer then add it to the top of the stack

We should handle errors by returning -1. These are the error conditions:
    - if the value we are going to add to the stack is greater than the maximum value 2**20 - 1
    - if +/- when only one entry left in the entire stack


"""

from operator import add, sub


def solution(S):
    # TODO: turn into a class
    commands = S.split()

    if not commands:
        return -1

    upper_limit = 2**20 - 1

    store = []

    index = 0

    ops = {"+": add, "-": sub}

    while index < len(commands):
        command = commands[index]

        if command.isdigit():
            store.append(int(command))

        elif command in ops.keys():
            if len(store) == 1:
                return -1
            func = ops[command]
            result = func(store[-1], store[-2])

            if result < 0:
                return -1

            if result > upper_limit:
                return -1

            store = store[:-2] + [result]

        elif command == "POP":
            store.pop()

        elif command == "DUP":
            store.append(store[-1])

        index += 1

    return store[-1]


S = "4 5 6 - 7 +"

assert solution(S) == 8

S = "13 DUP 4 POP 5 DUP + DUP + -"

assert solution(S) == 7

S = "5 6 + -"

assert solution(S) == -1

S = "6 5 -"

assert solution(S) == -1

S = "3 DUP 5 - -"

assert solution(S) == -1


S = "1048575 DUP +"


assert solution(S) == -1
