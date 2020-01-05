# Web Servers

[Video](https://www.youtube.com/watch?v=JhpUch6lWMw)

## What is it?

- Software that serves web content.
- Uses the HTTP protocol.
- Can serve static and dynamic content.
- Used to host web pages & build API's.

Static; content that can be downloaded, essentially storage for HTML files etc.
Dynamic; content that query a database and retrieves the results, can be different based on context (user, location etc.).

## How it Works

### Blocking Single-Threaded Web Server

- Client GET requests from a specific web domain (IP address) which usually defaults to port 80.
- TCP connection established (TLS handshake, etc.) between the client & server.
- Every client connection reserves memory on server (aka TCP socket) and creates a new thread for fulfilling the request.
- Socket process gets info from DB/static-file.
- Uses existing TCP connection to sends it to the client, along with header and status code info.

Load Balancer is used to connect multiple single threaded web servers.

## Technologies

Existing ones like Apache or TomCat can be used to create one.

This really only works with static websites.

You can roll your own with a framework like Django or NodeJS.
