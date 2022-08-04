# Sorting

[[TOC]]


Make sure you are familiar with [Big O notation and complexity](./time_complexity.md).

## Languages Default Sorting Algorithm

Python -> Timsort (n log n)


## Bubble Sort

```python
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
```
