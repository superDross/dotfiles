# Transport Layer Security (TLS)

[Video](https://www.youtube.com/watch?v=AlE5X1NlHgg&list=PLQnljOFTspQU3YDMRSMvzflh_qXoz9zfv&index=4)

Used in HTTPS for its security encryption.

## HTTPS

Before we send a request, a handshake is performed to allow the client and server to agree upon a key.

This key will be used to encrypt/decrypt data between client/server.

The data is encrypted, using the key, by the client and decrypted, using the key, by the server.

## TLS 1.2 (handshake)

Uses RSA, I think...

1. client hello; tells server everything it supports e.g. http version, browser version, rsa etc.

2. server determines security algorithm to use based upon the client supported software.

3. server hello; gives client the server certificate (servers public key)

4. client creates a symmetric key and then encrypts it using the servers public key, and sends it to the server

5. the server now has the symmetric key and tells the server, formally ending the handshake

The symmetric key is then used for encryption/decryption.

### CONS

- the symmetric key is sent to the server, which can be intercepted and stolen (INSECURE)
- 4 round trips of communication before any request can be made (SLOW)

## Diffie Hellman 

You use the clients private key, the clients private key and the servers public key.

Combining all 3 gives you a private symmetric key.

The Diffie Hellman algorithm combines the keys to create the private symmetric key.


## TLS 1.3

Diffie Hellman is used for key generation

No asking for what it supports; it has to use the above algorithm.

1. client generates a public and private key and merges them into one using the algorithm

2. the client then sends this to the server along with the plain old public key

3. the server then generates a private key and takes the combined keys (from the client) and creates a new one (symmetric key) with all three keys

4. the server then takes merges its own private key with the clients key and sends it to the client.

5. the client now has all 3 keys allowing it to create the symmetric key

The symmetric key is then used for encryption/decryption.

### PRO

- one round trip (FASTER)
- secure
