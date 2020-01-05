# Hyper Text Transfer Protocol (HTTP)

[Resource](https://www.youtube.com/watch?v=0OrmKCB0UrQ&t=177s)

An application request-response protocol in a client-server computer model.

HTTP/3 is still experimental

HTTP uses port 80

HTTPS uses port 443

## How It Works

HTTP is part of the layer 7 protocol of the OSI model.

Usually have a client (browser, desktop app) and server (host with web app).

Basically describing the OSI model

HTTP basically open and closes a TCP connection(s) request/response.

### HTTPS

TLS/SSL Handshake is added

An encrypted key is sent from the client to the server during a request.

The server sends another encrypted key in its response to the client.

NOTE - check out ssl video

## HTTP/1

1996 released, when RAM was puny, so TCP connections were expensive.

It closed the TCP connection as soon as it received a response, to save memory.

For example, if a web page has HTML page and 3 images it will create 4 separate TCP connections for each thingy. Opposed to leaving it open for all GET requests and then closing when everything id received.

This is a problem as TCP is slow to start.

Used buffering - no idea what this is

- Open/Close TCP connection
- Slow
- Buffering

## HTTP/1.1

1997 released, as version 1 slowness pissed everyone off.

Invented a keep alive header to keep the TCP connection open for all of the HTML pages and images to requested and received.

Pipelining; send all the requests in parallel and the server sent all the responses in parallel. Messed by with ordering causing a lot of problems.

- Persisted TCP connection
- Low latency
- Streaming and chunked transfer
- Pipelining (disabled by default)

## HTTP/2.0

2015 released

- Compression
- Multiplexing; shoves all HTTP requests into one TCP connection (solved pipelining problems)
- Server Push; send site assets before a request has been made
- Always HTTPS
- Protocol negotiation during TLS; client tells what HTTP version(s) it supports (during TLS handshake) and allows the server to pick which version protocol to work with.

Server push example is if the client requests a HTML page send the corresponding CSS file, even if they do not explicitly ask for it.

## HTTP/3.0

Experimental version still

Same as 2.0 except it uses a modified UDP named QUIC (UDP with congestion control)

## HTTP Anatomy

### Request

Main Properties:

- URL
- Method type e.g. GET, POST...
- Headers e.g. cookies,
- Body e.g. data you want to send

### Response

Main Properties:

- Status Code
- Headers
- Body

## Next

```
Query Parameters vs resource parameters https://www.youtube.com/watch?v=r9IZn...
GET vs POST https://www.youtube.com/watch?v=K8HJ6...
E-tags https://www.youtube.com/watch?v=TgZnp...
Cookies https://www.youtube.com/watch?v=sovAI...
Spinup nodejs https://www.youtube.com/watch?v=nHU2N...
Fetch API  https://www.youtube.com/watch?v=Vj7W8...
TLS https://www.youtube.com/watch?v=AlE5X...
```
