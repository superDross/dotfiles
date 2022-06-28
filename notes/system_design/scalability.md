# Scalability

Resources:

```
https://www.youtube.com/watch?v=-W9F__D3oY4
```

## Load Balancer

Public servers of a scalable web service are hidden behind a load balancer.  This load balancer evenly distributes load (requests from your users) onto your group/cluster of  application servers. That means that if, for example, user Steve interacts with your service, he may be served at his first request by server 2, then with his second request by server 9 and then maybe again by server 2 on his third request. 

Every server contains exactly the same codebase and does not store any user-related data, like sessions or profile pictures, on local disc or memory. 

Sessions need to be stored in a centralized data store which is accessible to all your application servers. It can be an external database or an external persistent cache, like Redis. An external persistent cache will have better performance than an external database. By external I mean that the data store does not reside on the application servers. Instead, it is somewhere in or near the data center of your application servers. 

This pattern is called horizontal scaling.

### Simple Explanation

The load balancer takes a request from a client and decides which server should receive this request.

```
              -------------
client1 ---> |load balancer| ----> server2
             |             |
client2 ---> |             | ----> server1
              -------------
```

There are many ways to do this

### Round Robin

Iterate through all the servers ip addresses sequentially for each request.

e.g. request 1 goes to server1, request 2 goes to server2, request 3 goes to server1 etc.

To implement this properly we need to use caching to ensure that cpu intensive tasks are not done over and over again.


Session data is stored on a separate server or RAID so we can share state across all the servers.

Session data could be stored on a shared database that all servers will have access to.


RAID (specifically RAID1) is essentially having multiple HDDs storing the exact same data such that if one HDD fails, your data is not lost.

Any lost data is then copied back to the other drive.

There is multiple forms of RAID.

Replication of load balancers is possible through various toolings


active:passive LB; duplicated LB's whereby the if the active LB breaks we promote the passive LB to active (takes over active IP address)

active:active LB; 2 LB's constantly working independently parsing packets to the web servers

Both are highly available.

High availability (HA); paradigm that eliminates single points of failure to ensure continuous operations of uptime for an extended period.



Replication of databases is possible to mitigate data loss



This can have multiple slaves (completely different servers) where they essentially store a copy of the master database. That way 3 slave databases will contain the exact same data as master.

If anything goes wrong its fine as we have multiple replicants of master.

To be more efficient in sites that are especially read heavy, we can designate some database replicants as read only (slaves) and master are for write operations only. However, this gives a single point of failure for writing to databases

We can use another paradigm where there are 2 masters (for writing operations) each with their own slave (for read operations). Both masters then get a copy of the operation of the which other received. Thereby keeping both masters in sync. Slaves get a copy from their masters.

This second approach is more HA as we will always have master available to use.

We can use a load balancer to direct to slave databases (does not matter which one as only reading)



Database Partitioning; splitting large table into smaller individual tables.

Partitioning allows you to run faster queries as each table has less data.

Example; users partitioned between 2 tables one with usernames beginning with a-m and another with n-z.


```
database master slave paradigm

                      ┌─────┐
                      │     │
                      │ LB  │
                      │     │
    ┌─────────┬───────┴──┬──┴────────┬─────────┐
    │         │          │           │         │
    │         │          │           │         │
    │         │          │           │         │
    │         │          │           │         │
┌───▼───┐  ┌──▼────┐  ┌──▼────┐  ┌───▼───┐ ┌───▼───┐
│       │  │       │  │       │  │       │ │       │
│server │  │server │  │server │  │server │ │server │
│       │  │       │  │       │  │       │ │       │
└────┬──┘  └───┬───┘  └───┬───┘  └───┬───┘ └────┬──┘
     │         │          │          │          │
     ├─────────┴──────────┴──────────┴──────────┤
     │                                          │
     │Read Queries                    Write Queries
     │                                          │
     │ ┌────┐                                   │
     └─► LB │                                   │
       └─┬──┘                                   │
         │                                      │
    ┌────┴─────┬──────────┐                     │
    │          │          │                     │
┌───▼────┐ ┌───▼────┐ ┌───▼────┐                │
│        │ │        │ │        │                │
│PS slave│ │PS slave│ │PS slave│                │
│        │ │        │ │        │                │
└───▲────┘ └────▲───┘ └───▲────┘                │
    │           │         │                     │
    │           │         │          ┌──────────▼┐
    └───────────┴─────────┴──────────┤ PS Master │
              Replication            └───────────┘
```


Memcache or Redis can be used as in store memory caching



## Databases

Taken from [here](https://www.lecloud.net/post/7994751381/scalability-for-dummies-part-2-database)

Databases can be a bottle neck. To scale this there are two options.

### Solution one

First is to perform a master slave replication whereby the slave db servers are for write only and the single master server is used for writing. The master server will require significant vertical scaling (especially RAM upgrades).

If there are still issues the master server can be sharded which is a horizontal partition of rows of data across multiple database servers. Sharding can be based on something like EU customers vs US customers.

This can reduce index size & individual server load.

The issue with sharding is it results in a reliance on the interconnection between the servers and increases query latency (when more than one shard needs to be searched). Cross shard consistency and durability is very challenging and there can no guarantee of adherence.

### Solution Two

Denormalise data from the beginning and disallow join queries in the database. Instead make all joins occur at the application code level.

If you are doing that then perhaps using a NoSQL database would be better to use after all..

### Optimisation Techniques

#### Denormalisation

Denormalisation is the process of trying to increase the read performance of a database, at the expense of losing some write performance by adding redundant copies of data of by group data.

An [example](https://stackoverflow.com/questions/59059327/a-practical-example-of-denormalization-in-a-sql-database) is to merge two tables into one table so joins are no longer required to query all the necessary data.

Ultimately there are three types of denormalisation:
  - combine tables together so you don't have to perform joins
  - perform aggregate calculations (sum(), count() etc.) so you don't have to use GROUP BY
  - pre-calculate expensive calculations so you don't have to use queries with complex expressions

The negatives of denormalisation is that the pre-calculated data may be out dated if data was added/deleted/changed to the normalised table but the corresponding denormalised table pre-calculated data was not updated. Data is not inconsistent and incorrect.


#### Partitioning

[Explained](https://www.singlestore.com/blog/database-sharding-vs-partitioning-whats-the-difference/)

The process of dividing a very large table into multiple smaller individual tables. This results in faster queries as there is less data to scan. The aim is to reduce to overall read response time for SQL operations.

Vertical partitioning is splitting table by columns and connecting to the two table rows by a common id.

You should consider partitioning when:

- the table becomes greater than 2Gb
- table containing historical data only which will never be updated

#### Sharding

[Explained](https://www.singlestore.com/blog/database-sharding-vs-partitioning-whats-the-difference/)

A form of Horizontal partitioning where a tables rows are split up across multiple database servers. Sharding can be based on something like EU customers vs US customers.

Advantages:

- Reduces index size
- Distribute the database across servers thereby improving performance
- Segment data by geography


Disadvantages:

- SQL code becomes more complex
- Multiple points of failure within the now interconnected system
- Single point of failure; corruption of one shard causes failure of the entire table
- Backing up becomes complex; back up of shards must be co-ordinated
- Operational complexity; adding indexes or columns, modifying schema becomes much more difficult

