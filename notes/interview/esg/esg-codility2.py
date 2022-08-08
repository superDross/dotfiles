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
from typing import Callable, Optional


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


"""
Below is an OOP based answer that I created after the test.
"""


class MachineError(Exception):
    """
    WordMachine based exception.
    """

    pass


class WordMachine:
    """
    Process a string of operations.
    """

    def __init__(self, upper_limit: int = 2**20 - 1) -> None:
        self.stack = []
        self.upper_limit = upper_limit
        self.ops = {"+": add, "-": sub}

    def __call__(self, commands: str) -> int:
        return self.process(commands)

    def _process_digits(self, number: str) -> None:
        """
        Add digit to the stack.
        """
        if number.isdigit():
            self.stack.append(int(number))

    def _process_expression(self, expr: str) -> Optional[int]:
        """
        Process +/- operations.
        """
        if expr not in self.ops.keys():
            return

        if len(self.stack) == 1:
            raise MachineError(
                "More than one digit needs to be within the stack to "
                "perform + or - operations."
            )

        func = self.ops[expr]
        result = func(self.stack[-1], self.stack[-2])

        if result < 0 or result > self.upper_limit:
            raise MachineError(
                f"Can only place digits between 0 - {self.upper_limit} upon the stack"
            )

        self.stack = self.stack[:-2] + [result]

    def _process_command(self, command: str) -> None:
        """
        Processes POP and DUP commands.
        """
        if command == "POP":
            self.stack.pop()
        elif command == "DUP":
            self.stack.append(self.stack[-1])

    @property
    def methods(self) -> list[Callable]:
        """
        Return all processing methods.
        """
        return [
            getattr(self, mthd) for mthd in dir(self) if mthd.startswith("_process")
        ]

    def process(self, commands: str) -> int:
        """
        Process all given operations.

        A -1 return states an error has occurred in one of the operations.
        """
        self.stack = []
        commands = commands.split()

        if not commands:
            return -1

        for command in commands:
            for method in self.methods:
                try:
                    method(command)
                except MachineError:
                    return -1

        return self.stack[-1]


machine = WordMachine()

S = "4 5 6 - 7 +"

assert machine(S) == 8

S = "13 DUP 4 POP 5 DUP + DUP + -"

assert machine(S) == 7

S = "5 6 + -"
assert machine(S) == -1

S = "6 5 -"

assert machine(S) == -1

S = "3 DUP 5 - -"

assert machine(S) == -1


S = "1048575 DUP +"

assert machine(S) == -1
