# Common Web Dev Issues

## Timeouts

They can be configured at various levels:

- WSGI HTTP server (gunicorn/apache)
- load balancer (ZXTM)
- Back End frameword (Django/Flask/Cherrypy)


## Caching

Things to consider when caching.

- LRU-cache is not centralised so can be dangerous if used across multiple procs. (give example)

- In such a situation, you should use something like redis. (can be used easily with `ring`)

- Not always a good idea to pickle an object as there can be issues when using serialising/deserialising when getting/setting to/from redis.

- The `requests-cache` lib is useful as it patches all get requests downstream to cache responses. 
  - it will cache all responses everywhere in your app, be aware of this.
  - cache exceptions can be added for urls or a custom function can be parsed for specific custom exceptions.


## Kubernetes

`Transport endpoint is not connected` means there is an issue with the volume

You can check by jumping into the prod container and trying `cd /app/data/`


