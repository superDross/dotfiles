# TODO: colours are off in tmux which makes sense bash -> tmux -> docker bash -> neovim

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin:$HOME/.cargo/bin:$GOPATH:/bin
export TERM=xterm-256color
export VISUAL=nvim
export EDITOR="$VISUAL"

# options
# vi mode
set -o vi
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# append to the history file, don't overwrite it
shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist

# aliases
alias ll='ls -alF'
alias cls="clear; ls"
alias cll="clear; ls -lh"
alias c="clear"

# command prompt
export PS1="\[\033[33m\]nvim-docker[\h]\[\033[0m\] \w \$ "
