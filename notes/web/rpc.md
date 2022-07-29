# Remote Procedure Call (RPC)

A client causes a procedure to execute on a remote server.

For example, by wrapping this code in an RPC library and asserting a remote server as the receiver it will result in that code being executed on the remote server as thought it were a *local* procedure.

Uses the HTTP protocol.

Pros:

- smaller sized implementation over HTTP
- interface is very transparent and customisable

Cons:

- RPC clients become tighly coupled to the service implementation
- A new API must be defined for every new operation or use case
- Difficult to debug
