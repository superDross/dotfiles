# TCP v UDP

**protocol**; system of rules governing the exchange of data between devices

**internet protocol suite**; a set of communication protocols which specifies how data should be packetized, addressed, transmitted, routed, and received.

The internet protocol suite predates the OSI model.

UDP & TCP exist at layer 4 of the OSI model; transport protocol.

IP Address - each machine has one so each machine can be identified in a network

Ports - allow you to identify and access a specific application on a machine over the network

Many applications have default ports on all OS's e.g. 21 is FTP, 22 is SSH

An IP address + port is often asserted as a server in this video, which makes sense.

## Transmission Control Protocol (TCP)

Essentially acts as a vehicle for HTTP requests

This protocol was designed to access an application over the network by specifying an ip address and port; allows one server to send a message to another server by specifying an IP and a port number.

### Pro

- Acknowledgements; sends back a message to the requester that they received the message.
- Guaranteed Delivery; retries sending the message if an ack has not been received or is corrupted.
- Connection Based; both server and client establish a unique & _stateful_ connection with one another. The app and server hold information about this unique connection. This helps facilitates the previous two pros
- Congestion Control; it will send data only when the network can handle it.
- Order Packets; labels the packets broken up in layer 4 osi to order them back on the server when they receive them.

### Con

- Larger Packets; all these pros increase the amount of data added on a simple message
- More Bandwith; larger packets mean more bandwith
- Slower than UDP; waiting for all the features described in the pro section
- Stateful; **Check the stateful vs stateless video** connection needs to be reconnected if the TCP server goes down -- you cannot to resume that previous connection.
- Server Memory; connection based stateful connection the server has to allocate memory for each connection it establishes. It needs to listen and check them, hence the limit of connections that can be made to server (this is why DOS attacks work).

## User Datagram Protocol (UDP)

### Pro
- The opposite of the TCP cons

### Con

- All the TCP pros are not available in UDP
- Security; as it is not connection based, anyone can jump on and send stuff if the port is open

