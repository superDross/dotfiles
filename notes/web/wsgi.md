# Web Server Gateway Interface (WSGI)

WSGI allows python code to run on a HTTP server (like nginx or apache) by creating a standard interface between web servers and python web applications to promote portability across web servers.

The WSGI server is a separate running process that runs on a different port than your web server.

There are 2 primary WSGI implementations (uWSGI & Green Unicorn).

```
Browser <---> HTTP server <---> WSGI server <---> Python app
```

Cherrypy also functions as its own WSGI server

Note that the terms HTTP server and web server are used interchangeable

## Why use it?

- you can easily swap gunicorn for uWSGI without modifying the python application
- the WSGI server deals with managing thousands of requests so the application does not have to
- clear segregation of responsibility between the application & request management

## WSGI Standard

- http://ivory.idyll.org/articles/wsgi-intro/what-is-wsgi.html
- http://www.python.org/dev/peps/pep-0333/

## How Frameworks Implement WSGI

## Resources

- https://www.fullstackpython.com/wsgi-servers.html
- https://stackoverflow.com/questions/57105831/can-we-connect-our-flask-app-directly-with-nginx-server/57107517
- https://www.nginx.com/blog/maximizing-python-performance-with-nginx-parti-web-serving-and-caching/

