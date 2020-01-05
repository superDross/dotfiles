# Cache Strategies

[Cache Strategies](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Strategies.html)

## Write Through/Back

### Write Through Storage

The write-through strategy adds data or updates data in the cache whenever data is written to the database.

This allows for fast retrieval on demand while the data in main memory ensures nothing is lost during system failure.

This ensures the data in the cache is never stale.

However, everything has to be written twice which slows things down.
