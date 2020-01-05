#!/usr/bin/python3
''' Python version of tail -f

Usage:
    tail.py some.log
'''
import time
import sys


def follow(f):
    ''' Returns a generator containing new entries written to a log.'''
    # go to end of file
    f.seek(0, 2)
    while True:
        line = f.readline()
        if not line:
            time.sleep(0.1)
            continue
        yield line


def grep(pattern, lines):
    ''' Grep a set of lines for a pattern'''
    for line in lines:
        if pattern in line:
            yield line


def pipeline():
    ''' String all these generators together.'''
    logfile = open(sys.argv[1])
    logline = follow(logfile)
    grepline = grep("python", logline)
    for line in grepline:
        print(line)


if __name__ == '__main__':
    pipeline()
