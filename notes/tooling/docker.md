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


## Exposing Ports

Expose a continers 


## Commiting New Images

If you run a new ubuntu:latest container and save some files, you can
then commit it and run it. That way, in changes you see will persist.

```
# after exiting a container, create a new image
docker commit <container-name> <tag-name>

# run inside new image
docker run -ti <tag-name>
```

## Networking

### Port Exposure

Connect containers to each other and the internet.

- Apps in containers are isolated from the internet by default
- Containers can be grouped into private networks
- Ports have to be exposed to let connections in from outside the host machine

Private Networks; allows groups of containers to talk to each other but be
isolated from other containers on your computer/server.

Setting up example server

```
docker run --rm --ti -p 4567:4567 --name server ubuntu:14.04 bash

# 4567:4567 means expose port 4567 and connect it to 4567; expose the same port
# on the inside of the containeras on the outside.

# create a netcat server and parse data to other port
nc -lp 4567 | nc -lp 9989
```

To connect a client, run this locally:

```
nc localhost 4567
```

To connect a docker client

```
docker run --rm -ti ubuntu:14.04 bash

# then within docker use the local ip
nc 192.168.1.xxx 4567

# have to use this on MacOS
nc host.docker.internal 4567
```

#### Dynamic Port Exposure

- The port inside the container is fixed
- The port on the host machine is automatically chosen
- This allows many containers running a program with a fixed ports
- Used in conjunction with Kubernetes

```
# only declare the port inside the container
docker run --rm --ti -p 4567 --name server ubuntu:14.04 bash

# discover what port has been used outside the container.
docker port server

# use the resulting port to attach as a client locally
nc localhost <port>
```

### Linking

Legacy way of connecting docker containers via the network.

- Links all ports & env vars, though only one way
- Startup/restart order is therefore important

```
# server
docker run --rm -ti -e SECRET=envvar --name catserver ubuntu:14.04 bash

# open port
nc -lp 1234

# link service to catserver
docker run --rm -ti --link catserver --name dogserver ubuntu:14.04 bash

# connect to catserver
nc catserver 1234
```

Connecting to `dogserver` from `catserver` via `nc -lp 1234` in `dogserver` will
not work, as the connection is only one way.

Env vars linking works only one way too:

```
# dogserver cmd
env
# should show the env CATSERVER_ENV_SECRET=envvar
```

### Directly Connecting Containers

Connecting between containers goes through:

host container -> virtual network -> host network -> virtual network (clients) -> client container

This is inefficient, you can connect directly:

```
docker network create learning

# place containers on private network
docker run --rm -ti --net learning --name catserver ubuntu:14.04 bash
docker run --rm -ti --net learning --name dogserver ubuntu:14.04 bash

# to connect an existing container
docker network connnect learning catserver
```

Both servers can now `ping` one another and connect via `nc`. Only containers within the
virtual network can communicate.

#### Default Networks

Three default networks exist:
  - `bridge` network used by containers that don't specify a network preference
  - `host` no nework isolation at all (security concern)
  - `none` when a container should have no networking


## Volumes

Virtual disks to store and share between containers.

Not part of images.

There are two types:
  - Persistant; available always
  - Ephemeral; exists when containers use them, then are deleted

### Persistant

To share a directory on your local disk and have it be accessible as
`/shared/` within the container:

```
docker run -ti --name sharing-is-caring -v ~/example:/shared ubuntu bash
```

### Ephemeral

Create a container with a shared folder named `/shared-data/`:

```
docker run -ti --name sharing-is-caring -v /shared-data ubuntu bash
echo 'salutations fellow homosapian' > shared-data/hello.msg
```

Get access to the volumes in the original container:

```
docker run -ti --volumes-from sharing-is-caring ubuntu bash
cat shared/hello.msg
```

Only when ALL containers connected to the shared volume exit, will the volume
be deleted.

## Registries

Basically docker image repositories.

Search docker hub for manjaro:

```
docker search ubuntu
```

## Dockerfiles

Yaml that describe how to create an image that can be built with `docker build`.

```
docker build -t name-of-result ./
```

Each step/line in the dockerfile is cached, so if the line has not changed since it was last
run then it won't be reexecuted.

The parts you change most should exist at the end of the Dockerfile.

*NOTE* - processes you start on one line will not running on next line, so you may have to run
something over the same line if two processes need to communicate.

### Commands

`ENV` allows env vars to be used across lines.

`RUN` - lets you execute commands inside of your docker image during build time and get written
into your image as a new layer

This coule be used when wanting to mkdir or add a package.

`CMD` - lets you define a default command to run everytime your container starts.

Like a runtime operation so something like `python myapp/cli.py web` would be useful here.


## Command Cheatsheet

Create an image:

```
docker build
```

Delete an image:

```
docker rmi <image-id>
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

# delete container after task completion
docker run --rm -ti ubuntu bash "sleep 5; echo hi"
```

Attach to an ongoing docker containter:

```
docker attach <container-name>
```

Check the log of an container

```
docker logs <container-name>
```

Kill to stop container, rm to delete it.

```
docker kill <container-name>
docker rm <container-name>
```

Execute a command in an existing container:

```
docker exec -ti <container-name> bash
```

Limit resources:

```
docker run --memory 4m --cpus=1
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
