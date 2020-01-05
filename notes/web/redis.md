# Redis

An in-memory key-value store NoSQL database.

Usually used for caching.

Competes with memcache-D,

## NoSQL

Database Schema; the skeleton structure that represents the how the data is organised and how the relationships among them are associated.

Relational databases, like postgres, require you to define a schema, create a table, specify pk, type of values, default tables etc.

NoSQL does not require a schema of any sort.

It only stores key-values, like dictionaries in Python or JSON.

## Storage

It is not stored on disk but rather in RAM.

This makes it super fast for retrieving information, making it suitable for caching.

## Threading

Single threaded system; require to spin up multiple instances for multiple processes.

Simpler than multi threaded system.

A second thread is used for durability; this writes to disc that takes snapshots of the DB from time to time.

## Durability (Optional)

Handled by the second thread.

Problem with it being in-memory is if it crashes/shuts-down you lose your data.

Durability is handled by a second thread.

### Journaling

Anytime you write a key to memory, it is written to disk.

Everything is always written to disk but available to the user in-memory.

Presumably slows down the whole thing as it is constantly writing to the disk.

### Snapshot

The whole DB in-memory is written to disk at intervals (2 seconds).

You could lose data if a power cut occurs then you may miss some data.

## Transport

Uses TCP that has a request/response like system (similar to HTTP)

Uses message format RESP (REdis Serialization Protocol)

## Pub/Sub

Publish and subscribe model

This allows you to subscribe to a channel/topic. This means anytime you publish to the channel all subscribers to the channel receive the message.

## Replication/Clustering

Replication; storing data in more than one site or node; copying data from a db from one server to another server.

Having multiple copies is useful for setting up a proper testing env.

In replication enabled databases, one leader node writes the data while the rest of the nodes (followers) read the data.

Clustering; sharded database; split the database up.
