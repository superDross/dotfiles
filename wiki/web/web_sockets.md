# Web Sockets

**NEXT TOPIC** - SSL or layer 4 and 7 videos

A communication protocol that facilitates full duplex communication channels between a client and server over a single TCP connection.

It is almost like an asynchronous request-response cycle.

Uses the `ws://` or `wss://` protocol to make requests.

Web sockets are distinct from HTTP. Both protocols are located at layer 7 in the OSI model and depend on TCP at layer 4.

It is compatible with the HTTP protocol though.

Is stateful (HTTP is stateless) as the client & server have to be aware of one another.

There is now an API to the TCP connection available so you can send anything really.

## HTTP Limitations

Request-Response cycle does not allow for real-time communication.

Web sockets are built on HTTP 1.1 (open TCP connection, which is required for bidirectional communication)

## Duplexity

Full-duplex; allows communication in both directions and allows it to happen **simultaneously**.

Half-duplex; as above but does not allow simultaneous communication (HTTP).

Example, telephone networks are full duplex as both speakers can talk at the same time.

## How It Operates

### Handshake

HTTP request between the client server to determine if each support the websocket protocol.

The HTTP header has an `UPGRADE` key to help to determine if the client wants to upgrade the protocol to web socket.

If so, the server responds with a 101 to switch protocols to ws and full-duplex communication occurs.

### Use Cases

Anything that requires simultaneous communication:

- Chatting (e.g. little icon showing when some one is typing in FB)
- Live Feed
- Multiplayer Games
- Showing Client Progress

### Pro

- Full-duplex
- HTTP compatible
- Firewall friendly


### Con

- Stateful, so harder to scale horizontally -- not impossible, like using DB for state
- Proxying is difficult (Nginx is adding support)
- L7 load balancing results in timeouts, even though it should be open all the time
