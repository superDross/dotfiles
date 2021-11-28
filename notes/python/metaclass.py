"""
type can create classes on the fly as well as tell you what type an object is
type(name, bases, attrs)

This type() is used to create objects on the fly, this is possible because classes are objects

This is what python does when you use the keyword class, and it does so by using metaclasses.

Metaclasses are classes that create classes (also objects), classes are used to create objects.

This is possible with type as it is a metaclass and python uses it to create classes behind the scenes.
"""

from datetime import datetime, timedelta


class Person:
    def __init__(self, name, age):
        self.name = name.title()
        self.age = age


# create a subclass for male persons only
MalePerson = type("MalePerson", (Person,), {"gender": "male"})
david = MalePerson(name="David", age=1)

assert david.gender == "male"
assert david.age == 1

# lets dynamically add some methods
MalePerson.say_hello = lambda self: print(f"Hi my name is {self.name}!")
james = MalePerson(name="james", age=1)
james.say_hello()

# We can also add some methods via type()
FemalePerson = type(
    "FemalePerson",
    (Person,),
    {
        "gender": "female",
        "year_of_birth": lambda self: (
            datetime.now() - timedelta(days=(self.age * 365))
        ).year,
    },
)

jane = FemalePerson(name="jane", age=10)
assert jane.year_of_birth() == 2011

# class of all classes is type; the metaclass
# type is used by python to create classes, classes are used by the user create objects
print(jane.__class__.__class__)


# Lets create a metaclass


def lower_attr(future_class_name, future_class_parents, future_class_attrs):
    """
    Metaclass function that ensures all attr names are lower case.
    """
    lower_future_class_attrs = {k.lower(): v for k, v in future_class_attrs.items()}
    # create the class now
    return type(future_class_name, future_class_parents, lower_future_class_attrs)


class Foo(metaclass=lower_attr):
    NAME = "someone"


assert "name" in dir(Foo())


# The more OOP friendly method of doing this:


class LowerAttrMetaclass(type):
    def __new__(cls, clsname, bases, attrs):
        """
        __new__ creates the object, while init just initialises the object.

        Only ever use __new__ when you want to control how an object is created.
        We over ride it to do just this, alter object creation behaviour.
        """
        lower_attrs = {k.lower(): v for k, v in attrs.items()}
        # create the class now by calling the parents class (type)
        return super().__new__(cls, clsname, bases, lower_attrs)


class Foo(metaclass=LowerAttrMetaclass):
    NAME = "no one"


assert "name" in dir(Foo())


# sometimes a class decorator is simply more readable and appropriate


def lower_attr(cls):
    to_change = []
    for key, value in cls.__dict__.items():
        if not key.startswith("__") and not key.islower():
            to_change.append(key)

    for key in to_change:
        delattr(cls, key)
        setattr(cls, key.lower(), value)
    return cls


@lower_attr
class FooTwo:
    NAME = "no one"


assert "name" in dir(FooTwo())

# We can parse custom args to metaclasses too (see `n` arg)


class SubtractFromIntegersMetaclass(type):
    def _lower_int_values(cls, attrs, n):
        return {
            k: v - n if isinstance(v, int) else v
            for k, v in attrs.items()
            if not k.startswith("__")
        }

    def __new__(cls, clsname, bases, attrs, n=10):
        new_attrs = cls._lower_int_values(cls, attrs, n)
        return super().__new__(cls, clsname, bases, new_attrs)


class Bar(metaclass=SubtractFromIntegersMetaclass, n=20):
    age = 30
    name = "johnny"


assert Bar().age == 10
