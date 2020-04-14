#!/usr/bin/env bash

# NOTE: use lxappearance to matcha-dark-aliz
#       use lightdm-settings to change the theme for the login screen

# NOTE: to install postgres
#   sudo su postgres -l # or sudo -u postgres -i
#   initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data/'
#   exit

# NOTE: change GRUB_TIMEOUT_STYLE from hidden to menu in /etc/default/grub
#       GRUB_TIMEOUT_STYLE=menu (

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline
# set -o xtrace          # Trace the execution of the script (debug)

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
DOTFILESDIR="$(dirname $SCRIPTPATH)"


function autojump(){
	mkdir -p ~/bin/
	cd ~/bin/
	git clone git://github.com/wting/autojump.git
	cd autojump
	./install.py
	cd
}


function i3lock(){
  cd ~/bin/
  git clone https://github.com/meskarune/i3lock-fancy.git
  cd i3lock-fancy
  sudo make install
  cd
}


function update_and_install(){
  pacman -Syu

  pacman -Syu \
    firefox \
    the_silver_searcher \
    pulseaudio-bluetooth \
    xclip \
    docker \
    git \
    xfce4-terminal \
    xfce4 \
    vlc \
    telegram-desktop \
    npm \
    nodejs \
    tmux \
    yarn \
    evince \
    zathura \
    cups \
    clang \
    simple-scan \
    ripgrep \
    ttf-hack \
    ttf-font-awesome \
    ctags \
    scrot \
    feh \
    pasystray \
    redshift \
    timeshift \
    python-virtualenvwrapper \
    pulseaudio \
    pulseaudio-alsa \
    postgresql
  
  pamac build spotify
  pamac build python37
}


function install_npm_packages(){
  # change npm global dir inside the user space
  # otherwise you will get a user error every time you install with -g
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  
  npm install -g --save-dev \
    eslint \
    flow-bin \
    babel-eslint \
    eslint-plugin-react \
    stylelint \
    prettier \
    eslint-config-prettier \
    eslint-plugin-prettier \
    tldr 

  npm install --unsafe-perm -g \
    htmlhint \
    n \
    javascript-typescript-langserver \
    bash-language-server
}


function install_python_packages(){
  pip install \
    python-language-server \
    ipython \
    flake8 \
    black \
    vim-vint \
    grip \
    autopep8 \
    mypy \
    isort
}


function install_snap_stuff(){
  # c/c++ language server
  snap install ccls --classic
  snap install pre-commit --classic
}


function setup_vim(){
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  vim +PlugInstall +qall

  mkdir -p ~/.vim/vimundo ~/.vim/colors
  chmod -R +777 ~/.vim
}


function setup_files(){
  mkdir -p ~/projects
  git clone http://github.com/superdross/dotfiles

  cp ~/projects/dotfiles/images/wallpaper.jpg /usr/share/backgrounds/
lmxappearance
  ln -s ${DOTFILESDIR}/vim/vimrc ~/.vimrc
  ln -s ${DOTFILESDIR}/bash/bashrc ~/.bashrc
  cp ${DOTFILESDIR}/terminal/terminalrc  ~/.config/xfce4/terminal/
  ln -s ${DOTFILESDIR}/tmux/tmux.conf ~/.tmux.conf
  ln -s ${DOTFILESDIR}/i3/config ~/.i3/config
  ln -s ${DOTFILESDIR}/i3/i3status.conf ~/.i3/i3status.conf
  ln -s ${DOTFILESDIR}/images/wallpaper.jpg ~/Downloads/wallpaper.jpg
  ln -s ${DOTFILESDIR}/words/thesaurus.txt ~/.vim/thesaurus.txt
}


echo "dotfiles dir is set as: ${DOTFILESDIR}"

# update_and_install
# autojump
# i3lock
# install_npm_packages
# install_python_packages
# install_snap_stuff
# setup_files
# setup_vim
