# Build neovim separately in the first stage
FROM alpine:latest

# Install cargo and update the indexes using this hack
# Takes a long time to update the indexes hence why its first
RUN apk update && \
  apk --no-cache add rust cargo && \
  mkdir /tmp/deleteme \
    && cd /tmp/deleteme \
    && cargo init \
    && cargo add serde \
    && rm -rf /tmp/deleteme

RUN apk --no-cache add \
    # basic requirements for minimal configured neovim to work
    autoconf \
    automake \
    bash \
    build-base \
    cmake \
    coreutils \
    curl \
    gettext-tiny-dev \
    git \
    libtool \
    libc6-compat \
    neovim \
    ninja \
    openssl \
    pkgconf \
    unzip \
    wget \
    # packages required for nvim plugins
    ctags \
    fd  \
    lua \
    lua-dev \
    nodejs \
    npm \
    python3 \
    ripgrep

# Installing luarocks via pkg does not work hence the need for this
RUN cd /tmp && \
    git clone https://github.com/keplerproject/luarocks.git && \
    cd luarocks && \
    sh ./configure && \
    make build install && \
    cd && \
    rm -rf /tmp/luarocks

# Install pynvim for python plugins
RUN python3 -m ensurepip && \
    pip3 install --no-cache --upgrade \
        pip \
	setuptools \
	neovim

# init file and snippets (ignores the rest)
COPY ./ /root/.config/nvim/

WORKDIR /neovim
