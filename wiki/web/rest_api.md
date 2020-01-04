# Representational State Transfer (REST) API

[Resource](https://www.youtube.com/watch?time_continue=4&v=M3XQ6yEC51Q)

[GitHub](https://api.github.com) has a great example of a strictly RESTful API.

## Defined

### Representation

The format of the response that represents the requested resource e.g. JSON

You change the representation of a resource such that it is decoupled from your storage mechanism and host it on the HTTP.

### State Transfer

State should not be stored on the server application; do not rely on information being stored in-memory.

REST is a stateless protocol.

## Pro

- using a representation of the data (JSON) instead of the actual storage mechanism means if you update PostgreSQL in the backend, it won't affect your users response JSON.

## Constraints

- Client/server
- Stateless
- Cache-ability e.g E-Tags
- Layer systems
- Uniform interface (HATEOAS) e.g. GET URL shows all the other URLs to get more resources

A request should always tell you were to go next.

- The root api should show all endpoints available.
- You then go to the `/users/<username>` endpoint and that should show you where you want to go to get that users followers or likes etc.

The uniform interface means you will need to make a lot of requests to get all the information you require. This kills performance and is inefficient.

For example, if you want to get all the users and their likes you have to go to `facebook.com/api` to find the API. Then get the users endpoint then you make a request to each users detailed endpoint and use the response to make another request to get the users likes. This adds up quickly.

## Next

- E-tags and cache
- Proxying
