# Atomicity, Consistency, Isolation & Durability (ACID)

[Video](https://www.youtube.com/watch?v=pomxJOFVcQs)

A set of properties that guarantee transactions are processed reliably in a relational databases.

## Transactions

- a collection of queries
- commit; persist/make changes
- rollback; abort transactions

Example:

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100.00
    WHERE name = 'Alice';
COMMIT;
```

In-flight transaction; in progress transaction.
Reads; reading data.

## Atomicity

All queries must succeed, if one fails all should rollback.

If rollback was not implemented, then your query will only be partly executed.

This could result in someone's bank account being credited but the senders not debited.

## Isolation

Determines whether in progress transactions is visible to other users/transactions.

Determines level of concurrency, essentially.

It is up to the DBA how this is handled.

### Read Phenomena

- Dirty reads; non committed transaction has been read by your transaction.
- Non-repeatable reads; reads look different with the same query during a transaction due to a committed value occurring during.
- Phantom reads; a diff transaction inserted a new record during our transaction which picked it up when it should have not.
- Lost updates; in progress transaction overwrites your UPDATE before you committed (lost)

DB locks can prevent most of these (not phantom reads)

### Isolation Levels

Determine conditions in which concurrent transactions can take place.

Performance decreases with every level of isolation, but number of read phenomena that can occur also decrease.

- Read Uncommitted; no isolation, any change is visible to your queries.
- Read Committed; queries can only see committed transactions.
- Repeatable Read; queries can only see committed UPDATES at the beginning of the query.
- Serializable; transactions are serially executed; not concurrent. Uses a locking mechanism.

[Table](<https://en.wikipedia.org/wiki/Isolation_(database_systems)#Isolation_levels,_read_phenomena,_and_locks>) showing isolation level vs read phenomena.

Read Committed is the default isolation level in postgres.

## Consistency

How reliable data is in the DB e.g. having a high isolation level means high consistency

### Consistency in Data

Sometimes it matters (bank stuff), other times not (number of FB likes).

Defined by:

- table schema
- referential integrity (foreign keys)
- atomicity
- isolation level

### Consistency in Reads

A read must receive an updated value; a transaction committed a change must be seen by a new transaction immediately.

Problem with NoSQL and relational DBs.

The problem occurs when multiple DB servers (replicas) need to sync, there is a delay in updating all servers.

There is eventual consistency, but this can take time, leading one to read on old commit/value.

Again, not a problem for FB like numbers but is for banking account balances.

**THIS MAKES HORIZONTAL SCALING OF DATABASES VERY HARD**

## Durability

Committed transactions must be persisted in a durable storage.

For example, if a power cut takes place then the values must still be present after the power comes back on.

So postgres is durable while redis is not (in memory).
