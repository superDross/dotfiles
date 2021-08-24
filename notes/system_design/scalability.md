# Scalability

Resources:

```
https://www.youtube.com/watch?v=-W9F__D3oY4
```

## Load Balancer

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


memcache or redis can be used as in store memory caching



