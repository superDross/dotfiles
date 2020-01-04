# Stateful vs Stateless

[Resource](https://www.youtube.com/watch?v=nFPzI_Qg3FU)

[Resource-2](https://www.youtube.com/watch?v=nhwZn6v5vT0&feature=youtu.be)

Example will be a login-authentication page whereby a post request is made to the page with the login info.

## Stateful

Stateful application; one where the client is depending on some state on the server e.g. session data

The call with the username and password is used to query the DB to verify the user credentials.

After verification, the session variable `logged` will change to `true` allowing him to view his profile page.

This means one does not have to query the DB twice to check if the user is who they claim to be.

The session variable `logged` is stored on the server RAM. The problem with this is if the user tries to access the application on another server then it will fail as the session variables will not be the same.

This means we can not scale horizontally easily.

Usually we have a server (load balancer) which sits between the users request and the servers. This decides (randomly) which server the client will be assigned to.

Scaling horizontally usually requires a mix of stateful and stateless, usually embracing "write through" and "write back" cache.

### Pro

- connection to DB can be used with multiple clients
- a lot of useful info can be stored in a session

### Con

- load balancer sending your request to a different server means you have to re-authenticate
- if the server fails the user will have to re-authenticate
- does not scale horizontally well

## Stateless

State is not stored (no session data), instead a token is sent back to the user which the user requires for any communication with pages restricted by authentication.

Doesn't matter which server the load balancer takes us to.

The problem with this is the database has to be queried every time the token is sent by the user with a request. One solution to this is an in memory database (Redis).

### Pro

- does not matter which server the load balancer assigns to the client
- if the server fails and is quickly restarted, the client will have no issues as they are not reliant upon session data
- scales horizontally well

### Con

- opens, reads & closes in one request, which is expensive to the DB

## Hybrid

Storing state in a stateless manner can be achieved by storing the state on an in memory DB (reddis/memcache) -- still considered stateless as the state is stored elsewhere.

In this way the application is stateless but the entire system is stateful
