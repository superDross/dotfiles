# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --hide="*.pyc" --hide="*.egg-info" --hide="__pycache__" --group-directories-first --sort=extension'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# allows sudo to work with alias command
alias sudo='sudo '

# sets up volume, second monitor & xbox controller for steam big picture mode
alias game-on="/home/david/key-scripts/game-on.sh"

# as above without volume
alias game-quietly="/home/david/key-scripts/game-quietly.sh"

# an alias for clear and list details & another with details
alias cls="clear; ls"
alias cll="clear; ls -lh"
alias c="clear"

# load the most recently modified file in cwd with vim
newest(){
	vim "$(find . -maxdepth 1 -type f ! -name '.' -printf '%T@ %Tc %p\n' | sort -n | awk '{print $NF}' | tail -n 1)"
}

export PERL5LIB=$PERL5LIB:$HOME/bin/vcfhacks:$HOME/bin/dapPerlGenomicLib:$HOME/bin/vcftools/src/perl/
export PATH=$PATH:$HOME/bin/vcfhacks:$HOME/key-scripts/csq_query.py:$HOME/bin/dapPerlGenomicLib:$HOME/.cargo/bin

# point python-path to some user made functions/modules
export `python3 ~/key-scripts/pythonpath.py /home/david/projects/`

# start up pythonrc to get autocomplete and saving of python environment in python shell
export PYTHONSTARTUP=$HOME/.pythonrc

# change the colour of the dirs and executable files
# https://www.howtogeek.com/307899/how-to-change-the-colors-of-directories-and-files-in-the-ls-command/
export LS_COLORS=$LS_COLORS:'di=1;35;95:ex=1;32;33:fi=0:ln=1;31:*.md=0;37'

# vim to be default editor
export VISUAL=vim
export EDITOR="$VISUAL"
export PATH=$PATH:~/configuration/ideas/bash/:~/bin/vcfhacks/
export VIMRC=~/.vimrc

# shorthand for connecting to remote
alias osmc="ssh osmc@192.168.1.7"
alias edinburgh="sudo vpnc ~/key-*/edVPN.conf"
alias ledaig="ssh dross11@ledaig.hgu.mrc.ac.uk"
alias eddie3="ssh dross11@eddie3.ecdf.ed.ac.uk"

# shorthand for software
alias tree="tree -I '*.egg-info|*.pyc|__pycache__|__init__.py'"

# copy a file, usage: `copy <file>`
alias copy="xclip -sel c <"

# an alias for clear and list details & another with details
alias cls="clear; ls"
alias cll="clear; ls -lh"
alias c="clear"

alias csq_query="~/key-scripts/csq_query.py"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
