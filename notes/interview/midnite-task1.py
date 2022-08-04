"""
Determine if the entries in the linked list make a palindrome

Try and make it 0(n); time correlates with the number of nodes in the list.
"""

from collections import deque


class Node:
    def __init__(self, value, next=None):
        self.value = value
        self.next = next

    def __repr__(self):
        return f"value={self.value}"

    def __str__(self):
        return self.__repr__()


def create_linked_list(values):
    head_node = None
    previous_node = None
    for value in values:
        node = Node(value)
        if previous_node:
            previous_node.next = node
        else:
            head_node = node
        previous_node = node
    return head_node


def solution(llist):
    """
    Initial solution which is 0(n2) (quadratic)

    This is because we are traversing the list and reversing the items
    at the end.

    Reversing the list is 0(n) (linear) itself alone so not an efficient solution.
    """
    items = []
    while llist is not None:
        items.append(llist.value)
        llist = llist.next
    return items == items[::-1]


def solution2(llist):
    """
    Second attempt was to use deque (a double linked list apparently).

    Deque can prepend in 0(1) (constant) so we can iterate over the linked
    list create a forward and backward deque and compare them.

    This makes the overall time complexity as 0(n) linear.
    """
    forward_list = deque()
    backward_list = deque()
    while llist is not None:
        forward_list.append(llist.value)
        backward_list.appendleft(llist.value)
        llist = llist.next
    return forward_list == backward_list


llist = create_linked_list([1, 2, 1])
assert solution2(llist) is True

llist = create_linked_list([1, 2, 1, 3, 5])
assert solution2(llist) is False
