# E-Tags AKA Entity Tag

It is part of the HTTP protocol that is used for web cache validation. Almost all web servers (Apache, Nginx etc.) implement them.

Apache deals with them AFAIK. Is framework independent.

## Use

When you make a GET request the server replies and gives you an E-tag which uniquely identifies the request made.

This tag is used when you make the same GET requests to determine whether anything has changed since your last request. It is placed in the `If-None-Match` header.

If nothing has changed, the server does not have to respond with the whole resource. But instead replies a `304` response.

This is a form of web caching.

The cache is generated & stored on the server, so requires a stateful application.

Solution is to link all the e-tags across servers, apache can be configured to do this.

E-tags are difficult to delete (they are managed by the browser), while cookies can be easily deleted. As such, they can be misused to track a user.

## Zombie Cookies

Companies (Hulu) automatically respond any request with a 304 so an e-tag is always generated but never changes.

The browser caches the e-tag until it thinks it no longer needs it.

The client will then always keep sending the same e-tag with each request, thereby allowing a company to identify a user.

They are often referred to as zombie cookies.

## Pros

- fast response
- reduces bandwidth
- saves server computation

## Cons

- stateful app required otherwise, or a solution/fix needed.
- zombie cookies
