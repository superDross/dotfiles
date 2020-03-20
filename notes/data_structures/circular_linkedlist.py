"""
Circular Linked List last node points to the first node (the one successeding the head node)
"""

from typing import List, Optional

from linkedlist import LinkedList, Node


class CircularLinkedList(LinkedList):
    def __init__(self, value: int) -> None:
        self.head = Node(value)
        super().__init__(value)

    @property
    def first_node(self) -> Optional[Node]:
        return self.head.next

    @first_node.setter
    def first_node(self, node: Node) -> None:
        self.head.next = node

    @property
    def last_node(self) -> Optional[Node]:
        if not self.first_node:
            return self.head
        elif not self.first_node.next:
            return self.first_node

        node = self.first_node
        while node.next != self.first_node:
            node = node.next
        return node

    def insert(self, value: int, after: Optional[int] = None) -> Node:
        """
        Insert Node after an existing node in the LinkedList.
        """

        if not self.first_node:
            self.first_node = Node(value)
            return self.first_node
        elif not self.first_node.next:
            node = Node(value)
            self.first_node.next = node
            node.next = self.first_node
            return node

        node = self.head
        existing_next_node = self.first_node
        while node.next != self.first_node:
            if not after or not node.value == after:
                node = node.next
                existing_next_node = node.next
                continue
            break

        node.next = Node(value)
        if node.next:
            node.next.next = existing_next_node
        print(node.value, node.next.value)


# Last Node tests
ll = CircularLinkedList(1)
assert 1 == ll.last_node.value
ll.insert(2)
assert 2 == ll.last_node.value
ll.insert(3)
assert 3 == ll.last_node.value


# Check last node
assert [1, 2, 3] == ll.values
