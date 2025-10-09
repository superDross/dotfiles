FROM alpine:3.22.1

# TODO: generate virualenvs when creating docker image

# Install cargo and update the indexes using this hack
# Takes a long time to update the indexes hence why its first
RUN apk --no-cache add rust cargo \
	&& mkdir /tmp/deleteme \
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
	ninja \
	openssl \
	pkgconf \
	tree-sitter \
	unzip \
	wget

# install neovim from source so we can control the version
# bob does not work with alpine and using the pkg version is too old
RUN git clone https://github.com/neovim/neovim.git \
	&& cd neovim \
	&& git checkout v0.11.4 \
	&& make CMAKE_BUILD_TYPE=Release \
	&& make install

# packages required for nvim plugins
# ensure lua version is the same as what nvim uses
RUN apk --no-cache add \
	bat \
	ctags \
	fd  \
	fzf \
	lua5.1 \
	lua5.1-dev \
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
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN pip install --no-cache --no-cache-dir --upgrade \
	pip \
	setuptools \
	neovim

RUN rm -rf /var/cache/apk/* /tmp/*

COPY nvim.bash /root/.bashrc

WORKDIR /app

# NOTE:
# manual installation of some lua LSP/Linters is required:
# :MasonInstall --target=linux_arm64_gnu lua-language-server stylua
