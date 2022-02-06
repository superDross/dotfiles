# System Design

## High Scalable

A scalable web app is one that is able to smoothly handle an ever increasing user base or sudden increase in traffic.

### Stateless

Ensure dependant data is not stored in memory or on the file system.

Example, session token stored in memory (but not the db) means the user would be logged out if the server is restarted or app re-deployed.

The token should be stored in the db, that way it can be retrieved.


### Highly Partitioned Databases

Give each database entry a partition key.

This means if an mass amount of data is uploaded, you should automatically spread your database to multiple servers.

This will ensure your data is organised cleanly across each partition.
