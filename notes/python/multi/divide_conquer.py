from concurrent.futures import ProcessPoolExecutor, as_completed


def recursive_sum(low, high, pool=None):
    """
    :exploding-head:
    """
    if not pool:
        with ProcessPoolExecutor() as executor:
            futures = recursive_sum(low, high, pool=executor)
            return sum(f.result() for f in as_completed(futures))
    else:
        if high - low <= 100_000:
            return [pool.submit(sum, range(low, high))]
        else:
            mid = (high + low) // 2
            left = recursive_sum(low, high, pool)
            right = recursive_sum(mid, high, pool)
            return left + right


if __name__ == "__main__":
    total = recursive_sum(1, 1_000)
    print(total)
