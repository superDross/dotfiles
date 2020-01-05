# RabbitMQ

Message queue written in erlang.

Clients want to talk to every other client the system creating meaning 10 different clients are communicating with one another; inefficient and complex.

RabbitMQ introduces an intermediate layer so these clients can easily communicate with one another.

Instead of having each client having knowledge of other clients, we group everything into a rabbitmq server (port: 5672)

## Components

Publisher creates a stable TCP connection to the server, a two way communication so they can send messages to each other, uses the Advanced Message Queue Protocol (AMQP) communication layer on top of TCP -- has its methods, headers etc.

Publisher <----> RabbitMQ Server <----> Consumer

Channels; allows for one consumer (one TCP connection) to consume 3 different types of messages, instead of 3 different consumers; multiplexing.

A channel can only exist in the context of a connection.

## Definitions

**Producer/Publisher** is a user application that sends messages.<br>

**Queue** is a buffer that stores messages.<br>

**Consumer** is a user application that receives messages.<br>

**Work Queue** scheduling time consuming task among multiple workers.<br>

**Bindings** the relationship between the exchange and the queue.<br>

**Channel** connections that share a single TCP connection through a single consumer/producer.<br>

## Exchange

The producer can only send messages to an exchange; not directly to a queue.

On one side the exchange receives messages from producers and the other side the exchange pushes them to queues.

The exchange must know exactly what to do with a message it receives. The rules for that are defined by the exchange type.

[**Types**](https://lostechies.com/derekgreer/2012/03/28/rabbitmq-for-windows-exchange-types/)

- **Fanout** broadcasts all the messages it receives to all the queues.<br>

- **Direct** where the message is bound to a specific queue and consumed by a specific consumer.<br>

- **Topic** where the message is bound to queues based on wild cards.<br>

- **Headers** where the message is bound to queues based on multiple criteria (in a JSON like format).<br>

**Binding Key** determines which queue the exchange directs the message to.

**Routing Key** a message attribute that the exchange uses to determine which queue to assign the message - also used by consumers to determine which queue to assign it to.

## Acks

An ack is sent back to the broker to tell that a particular message has been consumer and processed.

If a consumer dies, it won't send back an ack which the broker will understand as it not being processed and requeue the message.

## Message Durability

Ensures messages and acks are not lost when rabbitmq dies -- must declare a queue as durable for this to work and message as persistent.

## Publish & Subscribe

Delivering a single message to multiple consumers
