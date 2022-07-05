"""
An attempt at implementing LRUCaching (for fun).
"""

from typing import Any, Callable


class LRUCache:

    store: dict[str, Any] = {}

    def __call__(self, func: Callable) -> Any:
        return self.cache(func)

    def _normalise_args(self, args):
        """
        Extract and use object name as the arg where possible.
        """
        normalised_args = []
        for arg in args:
            if hasattr(arg, "__name__"):
                arg = arg.__name__
            normalised_args.append(arg)
        return normalised_args

    def create_cache_key(self, func_name: str, *args: Any, **kwargs: Any) -> str:
        """
        Combine all function name, args & kwargs to create a key for the cache store.
        """
        all_args = self._normalise_args(args + tuple(kwargs.values()))
        return "-".join(str(x) for x in [func_name] + all_args)

    def cache(self, func: Callable) -> Any:
        """
        Store the args as the keys and the return item as the value.
        """
        def inner(*args: Any, **kwargs: Any) -> Any:
            key = self.create_cache_key(func.__name__, *args, **kwargs)

            if value := self.store.get(key):
                return value

            result = func(*args, **kwargs)
            self.store[key] = result
            return result

        return inner


cache = LRUCache()

# Basic Tests


@cache
def double(num1: int, num2: int) -> int:
    return (num1 + num2) * 2


double(2, num2=3)
assert cache.store.get("double-2-3") == 10


@cache
def no_args() -> int:
    # some api call, lets pretend
    return 12


no_args()
assert cache.store.get("no_args") == 12


@cache
def this(t: tuple, d: dict, integer: int) -> int:
    return integer * len(t)


this((1, 2), {"a": 5}, integer=4)
assert cache.store.get("this-(1, 2)-{'a': 5}-4") == 8


def dummy_func():
    pass


@cache
def check_func_parse(function: Callable, number: int) -> str:
    return f"{function.__name__}({number})"


check_func_parse(dummy_func, 2)
assert cache.store.get("check_func_parse-dummy_func-2") == "dummy_func(2)"
