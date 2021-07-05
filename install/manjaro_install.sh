#!/usr/bin/env bash

# To create a bootable usb:
#   sudo dd bs=4M if=/path/to/iso of=/dev/sdx status=progress oflag=sync 

# NOTE: use lxappearance to matcha-dark-aliz
#       use lightdm-settings to change the theme for the login screen

# NOTE: to install postgres
#   sudo su postgres -l # or sudo -u postgres -i
#   initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data/'

# NOTE: change GRUB_TIMEOUT_STYLE from hidden to menu in /etc/default/grub
#       GRUB_TIMEOUT_STYLE=menu (

# set -o xtrace           # Trace the execution of the script (debug)
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline

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

function git_completion(){
  curl \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
    -o ~/.git-completion.bash
}

function i3lock(){
  mkdir -p ~/bin/
  cd ~/bin/
  git clone https://github.com/meskarune/i3lock-fancy.git
  cd i3lock-fancy
  sudo make install
  cd
}


function update_and_install(){
  # Other tools (not in script):
  #   peek - gif record
  #   simplescreenrecorder - record screen

  sudo pacman -Syu

  sudo pacman -Syu \
    bash-completion \
    helm \
    kubectl \
    firefox \
    foliate \
    rlwrap \
    gnu-netcat \
    kdeconnect \
    the_silver_searcher \
    fd \
    pulseaudio-bluetooth \
    xclip \
    docker \
    git \
    xfce4-terminal \
    xfce4 \
    vlc \
    telegram-desktop \
    unp \
    npm \
    nodejs \
    ruby \
    tmux \
    yarn \
    evince \
    zathura \
    cups \
    clang \
    simple-scan \
    unclutter \
    ripgrep \
    ttf-hack \
    ttf-font-awesome \
    ttf-roboto-mono \
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
  pamac build hadolint
  pamac build mongodb-shell
}


function install_gems(){
  gem install sqlint
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


function setup_postgres(){
  sudo su postgres -l # or sudo -u postgres -i
  initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data/'
  sudo systemctl enable --now postgresql.service
}


function setup_files(){
  sudo cp \
    ${DOTFILESDIR}/images/wallpaper.jpg \
    /usr/share/backgrounds/

  mv ~/.bashrc ~/.bashrc_OG
  mv ~/.i3/config ~/.i3/config_OG
  mkdir -p /home/david/.config/xfce4/terminal/
  mkdir -p ~/.vim/

  ln -s ${DOTFILESDIR}/vim/vimrc ~/.vimrc
  ln -s ${DOTFILESDIR}/bash/bashrc ~/.bashrc
  ln -s ${DOTFILESDIR}/bash/inputrc ~/.inputrc
  ln -s ${DOTFILESDIR}/postgres/psqlrc ~/.psqlrc
  ln -s ${DOTFILESDIR}/terminal/terminalrc  ~/.config/xfce4/terminal/terminalrc
  ln -s ${DOTFILESDIR}/tmux/tmux.conf ~/.tmux.conf
  ln -s ${DOTFILESDIR}/i3/config ~/.i3/config
  ln -s ${DOTFILESDIR}/i3/i3status.conf ~/.i3/i3status.conf
  ln -s ${DOTFILESDIR}/images/wallpaper.jpg ~/Downloads/wallpaper.jpg
  ln -s ${DOTFILESDIR}/words/thesaurus.txt ~/.vim/thesaurus.txt
}


function main(){
  echo "Dotfiles dir is set as: ${DOTFILESDIR}"

  read -p "Are you sure you wish to continue? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    update_and_install
    autojump
    git_completion
    i3lock
    install_gems
    install_npm_packages
    install_python_packages
    install_snap_stuff
    setup_files
    setup_vim
    setup_postgres
  fi

  echo "Plesase reboot your system"
}

main
