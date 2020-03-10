"""
Double Linked List is linked by both a successor and precursor

Circular Linked List last node points to the first node (the one successeding the head node)

Resources:
  - https://www.tutorialspoint.com/data_structures_algorithms/linked_list_algorithms.htm
"""

from dataclasses import dataclass
from typing import List, Optional


@dataclass
class Node:
    value: int
    next: Optional["Node"] = None


class LinkedList:
    """
    Nodes linked by a successsor Node.
    """

    def __init__(self, value: int) -> None:
        self.head = Node(value)

    def prepend(self, value: int) -> None:
        """
        Insert Node at the start of the LinkedList.
        """
        self.head = Node(value=value, next=self.head)

    def append(self, value: int) -> None:
        """
        Insert Node at the end of the LinkedList.
        """
        node = self.head
        while node.next:
            node = node.next
        node.next = Node(value=value)

    def insert(self, value: int, after: Optional[int] = None) -> None:
        """
        Insert Node after an existing node in the LinkedList.
        """
        node = self.head
        existing_next_node = node.next
        while node.next:
            if not after or not node.value == after:
                node = node.next
                existing_next_node = node.next
                continue
            break

        node.next = Node(value)
        if node.next:
            node.next.next = existing_next_node

    def delete(self, value: int) -> None:
        previous_node = None
        node = self.head
        next_node = node.next
        while node.next:
            if node.value == value:
                break
            previous_node = node
            node = node.next
            next_node = node.next

        del node
        if previous_node:
            previous_node.next = next_node
        if next_node:
            self.head = next_node

    def reverse(self) -> None:
        previous_node = None
        node = self.head

        while node:
            next_node = node.next
            node.next = previous_node
            previous_node = node
            node = next_node  # type: ignore

        self.head = previous_node  # type: ignore

    def search(self, value: int) -> Optional[Node]:
        node = self.head
        while node:
            if node.value == value:
                return node
            node = node.next  # type: ignore
        return None

    @property
    def values(self) -> List[int]:
        node = self.head
        values = []
        while node:
            values.append(node.value)
            if not node.next:
                break
            node = node.next
        return values


def create_linked_list():
    ll = LinkedList(1)

    for x in [2, 3]:
        ll.insert(x)
    return ll


# Values property to show all values in linked list
ll = create_linked_list()
assert [1, 2, 3] == ll.values

# Prepend node at start of list
ll.prepend(10)
assert [10, 1, 2, 3] == ll.values

# Append node at the end of the list
ll.append(5)
assert [10, 1, 2, 3, 5] == ll.values

# Inserting betweeen 2 nodes
ll.insert(value=4, after=3)
assert [10, 1, 2, 3, 4, 5] == ll.values

# Inserting after final node
ll.insert(6)
assert [10, 1, 2, 3, 4, 5, 6] == ll.values

# Deleting a value between 2 nodes
ll.delete(6)
assert [10, 1, 2, 3, 4, 5] == ll.values

# Deleting the head value
ll.delete(10)
assert [1, 2, 3, 4, 5] == ll.values

# Deleting the last value
ll.delete(5)
assert [1, 2, 3, 4] == ll.values

# Reverse the order of the nodes
ll.reverse()
assert [4, 3, 2, 1] == ll.values

# Search for a specific node
found_node = ll.search(3)
assert 3 == found_node.value
