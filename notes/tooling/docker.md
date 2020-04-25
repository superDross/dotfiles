# Docker

## Definitions

An *Image* is an immutable file that contains the minimum number files of source code,
libraries, parts of the OS, tools etc. needed to run the application.

They represent an application and its virtual environment at a specific point in time.

Images are just essentially templates which can be used to build a container. These can
be given to other devs to run your app in their local env.

Each time you change the intial state of an image and save it, you create a new image layer. You can have unlimited layers/snapshots that represent changes to the application over time.

You can switch between layers readily.

A *Container* is an isolated environment to run the image. It adds a writable layer on top of the immutable image which allows you to modify it.


## Commands

Create an image:

```
docker build
```

Create a container:

```
docker create
```

Look at images:

```
docker images
```

Run an interactive bash process within an ubuntu container:

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
