# TODO: change to ubuntu to make this easier to maintain
FROM alpine:3.22.1

# use system wide python packages
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV GOPATH=$HOME/go
ENV PATH="$PATH:$GOPATH/bin"

# Install cargo and update the indexes using this hack
# Takes a long time to update the indexes hence why its first
RUN apk update && \
  apk --no-cache add rust cargo && \
  mkdir /tmp/deleteme \
    && cd /tmp/deleteme \
    && cargo init \
    && cargo add serde \
    && rm -rf /tmp/deleteme

# basic requirements for minimal configured neovim to work
RUN apk --no-cache add \
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
	tree-sitter \
    unzip \
    wget

# packages required for nvim plugins
RUN apk --no-cache add \
    bat \
    ctags \
    fd  \
    fzf \
    lua \
    lua-dev \
    nodejs \
    npm \
    python3 \
	go \
	py3-pip \
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
RUN pip install --no-cache --no-cache-dir --upgrade \
      pip \
	  setuptools \
	  neovim

# init file and snippets (ignores the rest)
COPY ./ /root/.config/nvim/

# create an application directory incase we need to mount a host directory
RUN mkdir -p app/

WORKDIR /app
