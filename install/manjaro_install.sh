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


function update_and_install(){
  # Other tools (not in script):
  #   peek - gif record
  #   simplescreenrecorder - record screen

  sudo pacman -Syu

  # make sure to execute: xcompmgr -c -l0 -t0 -r0 -o.00
  # this stops the black screen issue when drawing in zoom

  sudo pacman -Syu \
    alacritty \
    bat \
    clang \
    ctags \
    cups \
    docker \
    evince \
    fd \
    feh \
    firefox \
    foliate \
    git \
    gnu-netcat \
    helm \
    kdeconnect \
    kitty \
    kubectl \
    nodejs \
    npm \
    pasystray \
    pulseaudio \
    pulseaudio-alsa \
    pulseaudio-bluetooth \
    python-virtualenvwrapper \
    redshift \
    rlwrap \
    ruby \
    scrot \
    simple-scan \
    timeshift \
    tmux \
    ttf-font-awesome \
    ttf-hack \
    ttf-roboto-mono \
    unclutter \
    unp \
    vlc \
    xclip \
    xcompmgr \
    xfce4 \
    xfce4-terminal \
    yarn \
    zathura
  
}

function install_aur_packages(){
  pamac build --no-confirm \
    autojump \
    git-completion \
    i3lock-fancy-git \
    mongodb-compass \
    mongodb-shell \
    postman-bin \
    python2 \
    python36 \
    python37 \
    python38 \
    python39 \
    spotify 
}


function install_npm_packages(){
  # change npm global dir inside the user space
  # otherwise you will get a user error every time you install with -g
  mkdir -p ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  
  npm install -g --save-dev tldr n
}


function install_python_packages(){
  pip3 install ipython grip pdbpp remote-pdb
}


function install_snap_stuff(){
  snap install pre-commit --classic
}


function install_ale_tools(){
  # install all ALE tooling used for IDE like features with vim

  # python linters and formatters
  pip3 install \
    flake8 \
    black \
    autoimport \
    isort \
    mypy

  # python language server
  pip3 install \
    python-lsp-server \
    pyright \
    python-lsp-black \
    pyls-isort \
    pyls-flake8 \
    pylsp-mypy

  # sql linters
  gem install sqlint

  # javascript linters & formatters (no idea which of these I actually use)
  npm install -g --save-dev \
    eslint \
    flow-bin \
    babel-eslint \
    eslint-plugin-react \
    stylelint \
    prettier \
    eslint-config-prettier \
    eslint-plugin-prettier

  # javascript language server
  npm install --unsafe-perm -g javascript-typescript-langserver

  # json linter
  sudo pacman -Sy jq

  # vimscript linters
  pip3 install vim-vint

  # vimscript language server
  npm install -g --save-dev vim-language-server

  # bash linter and formatting
  sudo pacman -Sy shellcheck shfmt

  # bash language server
  npm install --unsafe-perm -g bash-language-server

  # docker language server
  npm install -g dockerfile-language-server-nodejs

  # fzf functionality
  sudo pacman -Sy ripgrep

  # html linters
  npm install --unsafe-perm -g htmlhint

  # dockerfile linter
  pamac build --no-confirm hadolint

  # c/c++ language server
  snap install ccls --classic
}


function setup_vim(){
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  vim +PlugInstall +qall

  mkdir -p ~/.vim/vimundo ~/.vim/colors
  chmod -R +777 ~/.vim
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
  ln -s ${DOTFILESDIR}/terminal/.alacritty.yml ~/.alacritty.yml
  ln -s ${DOTFILESDIR}/tmux/tmux.conf ~/.tmux.conf
  ln -s ${DOTFILESDIR}/i3/config ~/.i3/config
  ln -s ${DOTFILESDIR}/i3/i3status.conf ~/.i3/i3status.conf
  ln -s ${DOTFILESDIR}/images/wallpaper.jpg ~/Downloads/wallpaper.jpg
  ln -s ${DOTFILESDIR}/words/thesaurus.txt ~/.vim/thesaurus.txt
  ln -s ${DOTFILESDIR}/postactivate ~/.virtualenvs/postactivate
  ln -s ${DOTFILESDIR}/postmkvirtualenv ~/.virtualenvs/postmkvirtualenv
}


function main(){
  echo "Dotfiles dir is set as: ${DOTFILESDIR}"

  read -p "Are you sure you wish to continue? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    update_and_install
    install_npm_packages
    install_python_packages
    install_aur_packages
    install_snap_stuff
    install_ale_tools
    setup_files
    setup_vim
  fi

  echo "Plesase reboot your system"
}

main
