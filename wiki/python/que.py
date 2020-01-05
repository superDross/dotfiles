import queue

fifo = queue.Queue()

fifo.put('one')
fifo.put('two')
fifo.put('three')

print('\nFIFO\n----')
print(fifo.get())
print(fifo.get())
print(fifo.get())


lifo = queue.LifoQueue()

lifo.put('one')
lifo.put('two')
lifo.put('three')

print('\nLIFO\n----')
print(lifo.get())
print(lifo.get())


# heapq module is better suited for priority queues
priority = queue.PriorityQueue()

priority.put(9)
priority.put(12)
priority.put(1)

print('\nPRIORITY\n----')
print(priority.get())
print(priority.get())



# OWN implementation
class Queue(object):
    def __init__(self, l=[]):
        self.l = l

    def get(self):
        n = self.l[0]
        self.l.remove(self.l[0])
        return n

    def put(self, n):
        self.l.append(n)


class FIFO(Queue):
    def __init__(self, l=[]):
        super().__init__(l)


class LIFO(Queue):
    def __init__(self, l=[]):
        super().__init__(l)

    def get(self):
        n = self.l[-1]
        self.l.remove(self.l[-1])
        return n


class Priority(Queue):
    def __init__(self, l=[]):
        super().__init__(sorted(l))

    def get(self):
        self.l = sorted(self.l)
        return super().get()

l = FIFO()
l.put(0)
l.put(1)
print('\nMY IMPLEMENTATION\n\nFIFO\n----')
print(l.get())


l = LIFO()
l.put(0)
l.put(1)
print('\nLIFO\n----')
print(l.get())

l = Priority()
l.put(99)
l.put(1)
print('\nPriority\n----')
print(l.get())
