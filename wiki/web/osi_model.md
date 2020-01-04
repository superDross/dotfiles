# Open Systems Interconnection model (OSI model)

Standardised protocol for communication between computing systems; it is what the internet runs on and how all internet connected devices communicate.

## Definitions

**session**; a temp interactive exchange of information, while a user is connected to a web service; user stored information.

## Resources

[Hussians video](https://www.youtube.com/watch?v=7IS7gigunyI)

## 7 layers

### 7 Application

HTTP protocol

Prepares GET request - header, cookies, content-type etc.

### 6 Presentation (HTTPS only)

Encrypts the data

### 5 Session

The data is tagged with a session id

### 4 Transport

TCP/UDP protocol

Breaks the data into smaller segments, which are tagged with port numbers (source and destination ports) to allow them to be put back together again

### 3 Network

Segments are parsed here and are tagged with IP addresses (source and destination IPs) - now called a packet

### 2 Data Link

Each packet is then broken down and tagged with the target MAC address - now called a frame

### 1 Physical

The frames (bits; 1 or 0) are then transported everywhere over wifi

### Response

Every server in the vicinity will reverse the layering system. First they will check if the frames have the matching MAC address - that matched the server. The reversal of layering continues by checking the matching IP address, port etc. until you end up at the application layer again on the receiving server.
