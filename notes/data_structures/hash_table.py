"""
Hash tables are essentially dictionaries in Python.

Hashing; a technique to convert a range of key values into a range of indexes of an array.

Data is stored in an associative manner in an array format where the index
value is unique. This allows for fast look ups if we know the key.
"""

from typing import Any, Optional

# USING A DICTIONARY

d = {1: "a", 2: "b", 3: "c"}

# Inserting
d[4] = "d"

# Updating
d[4] = "e"

# Searching
assert "c" == d.get(3)

# Deleting
del d[4]
assert None == d.get(4)


# FROM SCRATCH


class HashTable:
    """
    An inefficient hash table.
    """

    def __init__(self):
        self._data = []

    def insert(self, key: Any, item: Any) -> None:
        for i in range(len(self._data)):
            index, value = self._data[i]
            if index == key:
                self._data[i] = (key, item)
                break
        else:
            self._data.append((key, item))

    def delete(self, key: Any) -> None:
        for i in range(len(self._data)):
            index, value = self._data[i]
            if index == key:
                del self._data[i]
                break
        else:
            raise ValueError(f"Index {key} was not found")

    def search(self, key: Any) -> Optional[Any]:
        for i in range(len(self._data)):
            index, value = self._data[i]
            if index == key:
                return value
        else:
            raise ValueError(f"Index {key} was not found")


# Test inserting a single set of data
table = HashTable()
table.insert(key=3, item="three")
assert table._data[0] == (3, "three")

# Test inserting multiple sets of data
table.insert(key=1, item="one")
table.insert(key=2, item="two")
assert all(x in table._data for x in [(1, "one"), (2, "two"), (3, "three")])

# Updating an existing indexes value
table.insert(key=1, item='ONE')
assert (1, 'ONE') in table._data

# Deleting a set of data
table.delete(2)
assert (2, 'two') not in table._data

# Searching for an index and returning its value
assert 'three' == table.search(3)
