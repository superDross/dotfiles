# Testing

This document refers to automated testing.

## Types

**Unit Testing**: tests a small component of your application

A real world example of this would be to test your car lights (a unit of an entire system; a car) you would simply
try turning them on and going outside to check they are on.

```py
def my_name_is_david(name):
    """
    Part of a larger web app stored as a utility function
    """
    if name.lower() == "david":
        return True
    return False


def test_my_name_is_david():
    assert my_name_is_david("david") is True


def test_my_name_is_not_david():
    assert my_name_is_david("james") is False
```


**Integration Testing**: tests the components of your applications operate with one another

An example would be to call a specific API endpoint and ensuring the expected result is returned.

This is an integration test because it involves multiple components; the handler, model and utility function code.
