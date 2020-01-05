#!/usr/bin/python3
'''
Coroutine example.

Usage:
    tail.py some.log

NOTE: use the asyncio module, this example is for demo purposes

Coroutines:

    Coroutine; generator that consumes data, but doesn't generate it.

    Generators produce values with yield.
    Coroutines consume values with yield.


    Coroutines parse data through the pipeline with the send() method.
    By having a `var = (yield)` expression in a generator, data can
    be parsed to it.


    Coroutines can be used to construct pipelines (like in Bash).
    Pipelines are usually structured such that they have a source
    which drives the entire pipeline (typically not a coroutine)
    which then passes data into coroutines that filter the data,
    usually data transformation etc. Data is then parsed to a sink
    (end-point) which processes it.


    follow -----> grep -----> printer
   (source)     (filter)       (sink)



                               ---> grep ---> printer
                              |
    follow -----> broadcast --
                              |
                               ---> grep ---> printer
'''
import time
import sys


def coroutine(func):
    ''' Ensures the generator is initialised and the next
        function is called on it. The next function advances
        the coroutine to the first yield expression.
    '''
    def start(*args, **kwargs):
        generator = func(*args, **kwargs)
        # generators always initialised with next otherwse error
        next(generator)
        return generator
    return start


@coroutine
def follow(logfile, target):
    ''' Parses new entries written to a given log file
        and sends them to a target coroutine.

        Note:
            This is a generator, not a coroutine.
            Coroutines have a yield expression for
            input.
    '''
    # go to end of file
    logfile.seek(0, 2)
    while True:
        line = logfile.readline()
        if not line:
            time.sleep(0.1)
            continue
        target.send(line)


@coroutine
def broadcast(targets):
    ''' Sends a sent value (item) to a list of coroutines.'''
    while True:
        item = (yield)
        for target in targets:
            target.send(item)


@coroutine
def grep(pattern, target):
    ''' Grep a set of lines for a given pattern and sends them
        to a coroutine.

        Note:
            Is a coroutine. It uses the yield expression to
            consume input (via send()) and process it before
            sending it onto another coroutine.
    '''
    try:
        while True:
            line = (yield)
            if pattern in line:
                target.send(line)
    except GeneratorExit:
        print("Closing grep")


@coroutine
def printer():
    ''' Prints anything sent to it.

    Note:
        Is a sink; endpoint for pipeline.
    '''
    while True:
        line = (yield)
        print(line)


def pipeline(log):
    ''' String all these generators together.'''
    logfile = open(log)
    # tail -f log | grep -e "python\|bash"
    coroutines = broadcast([
        grep("python", printer()),
        grep("bash", printer())
    ])
    follow(logfile, coroutines)


if __name__ == '__main__':
    pipeline(sys.argv[1])
