# GraphQL

A query language for you API; kind of like SQL for an API.

GraphQL is an open-source data query and manipulation language for APIs, and a runtime for fulfilling queries with existing data.

Github have both a good quality REST and GraphQL API.

## Why Not Use REST?

Developed by Facebook because of the limitations of REST.

REST, requires you to hit multiple endpoints to get all the info you need.

To get the number of likes of a users most recent comment one would have to call all the below endpoints:

```
/user/<user-id>/posts/
# identify desired post id and use it to get the comments
/user/<user-id>/posts/<post-id>/comments/
# identify desired comment-id and use it to get the likes
/user/<user-id>/posts/<post-id>/comments/<comment-id>/likes/
```

This is very inefficient, as it requires multiple requests to get a single piece of information.

## Defined

In GraphQL you tell the endpoint what you want. In this way you only have to make a single request to get the info you need.

Gives you directly what you want, REST will give you a JSON full of info that you may not want.

Heavily typed, schema operated API.

Transport agnostic. Designed for the web (HTTP) but can be used atop TCP, UDP, WebSockets etc.

## Properties

- Schema; uses it to

- Query; you can query the schema?

- Nesting; nest multiple queries in a single query

- Mutation; update/alter the query equivalent to PUT/PATACH

- Subscription; can subscribe to specific object ?

## Examples

See `graphql.py`

## Pros

- Flexible API, due to it being a query language
- Efficient Responses; get what you ask for, nothing more
- No Roundtrips on Network; only one request to get everything you want
- Single Endpoint
- Self Documenting

## Cons

- Complexity; forced to create a schema and typing stuff
- No HTTP Caching
- No Standard Errors; as it is transport agnostic, it won't use HTTP status codes (always 200)
- Expensive Queries Backends; simplicty of API does not come for free

## When to Use Over REST

- Don't know how an API will be used
- Enterprise APIs
- Well defined Schema
