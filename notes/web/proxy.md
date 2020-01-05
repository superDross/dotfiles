# HTTP Proxy

A proxy intercepts traffic and forwards it to the destination on behalf of the client.

## Transparent Proxy (Gateway)

LAPTOP ------- ISP SERVER ------ DESTINATION IP
                 proxy

If you try to connect to google then your ISP or some other router will redirect you to another server (gateway to intercept your TCP packet).

It can only look at the non-encrypted part of your packet -- the destination IP (google) and port (layer 3/4 OSI).

Then it determines whether the IP can be accessed or not. If so it continues on to the IP, otherwise it is blocked.

This is all these types of proxies can do; they essentially work much like how firewalls do.

An example of this is your ISP disallowing access to the pirate bay.

## HTTP Proxy

The proxy ip address is defined on the laptop/client machine.

The TCP packet is destined to the proxy, and tells the proxy which IP to forward to in the header. 

So the proxy connects to google for you then receives and sends back the response to the client.

This provides anonymity and allows one to bypass transparent proxies e.g. like totesdefnotthepiratebay.org which connects to thepiratebay.com disallowing your ISP from blocking it
