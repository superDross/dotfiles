#!/usr/bin/env bash

# NOTE: use lmxappearance to matcha-dark-aliz
#       use lightdm-settings to change the theme for the login screen

# NOTE: to install postgres
#   sudo su postgres -l # or sudo -u postgres -i
#   initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data/'
#   exit

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
# set -o xtrace          # Trace the execution of the script (debug)

TOP_DIR=$(dirname $(dirname "${BASH_SOURCE}"))


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
    git \
    xfce4-terminal \
    vlc \
    telegram-desktop \
    npm \
    nodejs \
    tmux \
    evince \
    zathura \
    cups \
    simple-scan \
    ripgrep \
    ttf-hack \
    ttf-font-awesome \
    ctags \
    scrot \
    feh \
    pasystray \
    redshift \
    xfce \
    python-virtualenvwrapper
    postgresql
  
  pamac build spotify
}


function install_npm_packages(){
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
    vim-vint \
    grip \
    autopep8 \
    isort
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

  ln -s ${TOP_DIR}/vim/vimrc ~/.vimrc
  ln -s ${TOP_DIR}/bash/bashrc ~/.bashrc
  cp ${TOP_DIR}/terminal/terminalrc  ~/config/xfce4/terminal/
  ln -s ${TOP_DIR}/tmux/tmux.conf ~/.tmux.conf
  ln -s ${TOP_DIR}/i3/config ~/.i3/config
  ln -s ${TOP_DIR}/i3/i3status.conf ~/.i3/i3status.conf
  ln -s ${TOP_DIR}/images/wallpaper.jpg ~/Downloads/wallpaper.jpg
  ln -s ${TOP_DIR}/words/thesaurus.txt ~/.vim/thesaurus.txt
}


update_and_install()
autojump()
i3lock()
install_npm_packages()
install_python_packages()
setup_vim()
setup_files()
