''' The Iterartor Pattern.'''
import requests
import re


class CapitalIterator:
    ''' Represents a specific location in a given iterable.'''

    def __init__(self, iterable):
        self.words = [w.capitalize() for w in iterable.split()]
        self.index = 0

    def __next__(self):
        ''' Defines what is done when the next() function is used.'''
        if self.index == len(self.words):
            raise StopIteration()

        word = self.words[self.index]
        self.index += 1
        return word

    def __iter__(self):
        ''' It iterates itself.'''
        return self


class CapitalIterable:
    ''' An iterable object has elements that can be looped over.'''

    def __init__(self, string):
        self.string = string

    def __iter__(self):
        ''' This method marks the object as iterable.'''
        return CapitalIterator(self.string)


def main():
    iterable = CapitalIterable('I am a sentence of sorts')
    # NOTE: below is what the `for x in list` syntax does

    # Alternative:
    #   iterator = iter(CapitalIterator('I am a sentence of sorts'))

    # executes the iterables __iter__ method to retrive its iterator
    iterator = iter(iterable)
    while True:
        try:
            # next() execute the __next__ iterators method
            print(next(iterator))
        except StopIteration:
            break


# main()

'''
GENERATORS
    Execute each line within a function until a yield statement is
    encounterd, return the value at the point and then pauses until the
    next next() call.
'''


def prepare_file():
    r = requests.get(
        'https://people.sc.fsu.edu/~jburkardt/data/csv/biostats.csv'
    )
    rows = r.text.replace(' ', '').replace('"', '').split('\n')
    data = [row.split(',') for row in rows]
    return data


def male_filter(f):
    for row in f:
        if row[1] == 'M':
            return row


def male_filter_gen(f):
    for row in f:
        if row[1] == 'M':
            yield row


f = prepare_file()

# normal function can only return once
print(male_filter(f))

# generator can keep returning as they remember their position/index
# and can therefore continue from it.
gen = male_filter_gen(f)
print(next(gen))
print(next(gen))
print(next(gen))


''' COROUTINES

    1 - yield occurs and the generator pauses.
    2 - send() occurs from outside the function and the generator wakes up.
    3 - the sent value is assigned to the left side of the yield statement.
    4 - the value to the right of the yield statement is returned.
    5 - the generator contineus until it encountera another yield statement.

    A generator can only produce values, a coroutine can also consume them.
'''


def tally():
    ''' Coroutine that tallies sent scores.'''
    score = 0
    while True:
        increment = yield score
        print(f'Increment: {increment}')
        score += increment


rangers = tally()
next(rangers)
# send() does the same as next() except it also passes a value to
# the coroutine which is assigned to the left of the statement (increment).
tally1 = rangers.send(3)
tally2 = rangers.send(9)
print(f'Tally: {tally1}\nTally: {tally2}')
