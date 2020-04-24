# Docker

## Definitions

An *Image* is an immutable file that contains the minimum number files of source code,
libraries, parts of the OS, tools etc. needed to run the application.

They represent an application and its virtual environment at a specific point in time.

Images are just essentially templates which can be used to build a container.

Each time you change the intial state of an image and save it, you create a new image layer. You can have unlimited layers/snapshots that represent changes to the application over time.

You can switch between layers readily.

A *Container* is a running image. It adds a writable layer on top of the immutable image which allows you to modify it.


## Commands

Look at images:

```
docker images
```

Run latest ubuntu image bash and go within an iteractive terminal:

```
docker run -ti ubuntu:latest bash
```

To see running processes:
```
docker ps
```

## Installation

To allow non-root access to docker:

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
```
