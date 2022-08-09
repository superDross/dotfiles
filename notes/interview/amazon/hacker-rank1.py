"""
Amazon Delivery Centers dispatch parcels every day. There are n delivery centers each having parcels[i]
parcels to be delivered. On each day, an equal number of parcels are to be dispatched from each delivery
center that has at least one parcel remaning.

Find the maximum number of days needed to deliver all the parcels.

Example:
parcels = [4,2,3,4]

On the First day - [2,0,1,2]
On the 2nd day - [1,0,0,1]
On the 3rd day - [0,0,00]

The Answer is 3 days.
"""


def inefficient_solution(parcels: list[int]) -> int:
    """
    Brute force technique that does not scale
    """
    parcels = [parcel for parcel in parcels if parcel > 0]
    days = 0
    while parcels:
        least = min(parcels)
        updated_parcels = [parcel - least for parcel in parcels if (parcel - least) > 0]
        parcels = updated_parcels
        days += 1
    return days


def solution(parcels: list[int]) -> int:
    """
    Removing duplicates and zeros give us the total number of trips required
    to complete the task.

    This is because the limiting factor is the minimum number of parcels; as that is
    the most that can be delivered at any given time.

    Therefore, the number of non zero unique packages equates to the number of trips we
    will have to make to delivery all parcels.
    """
    unique_parcels = set(parcels)
    if 0 in unique_parcels:
        unique_parcels.remove(0)
    return len(unique_parcels)


parcels = [2, 3, 4, 3, 3, 0]
assert solution(parcels) == 3

parcels = [100, 300, 394, 89, 100, 300, 0]
solution(parcels)
