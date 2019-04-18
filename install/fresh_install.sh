#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
# set -o xtrace          # Trace the execution of the script (debug)

TOP_DIR=$(dirname $(dirname "${BASH_SOURCE}"))


install_xfce() {
  apt install -y xfce4 xfce4-terminal xfce4-settings xfce4-power-manager
  apt install -y flat-remix arc-theme pop-theme flat-remix-gnome \
                 fonts-inconsolata xfce4-battery-plugin
}

install_fonts() {
  mkdir -p ~/.fonts
  cp -r ${TOP_DIR}/fonts/ ~/.fonts/
  fc-cache -f -v
}


add_ppas() {
  add-apt-repository ppa:atareao/telegram
  add-apt-repository ppa:daniruiz/flat-remix
  add-apt-repository ppa:system76/pop
  apt update
}


install_multimedia() {
  apt -y install xubuntu-restricted-extras libdvd-pkg steam telegram vlc steamcmd spotify-client ffmpeg chromium-codecs-ffmpeg-extra
  snap install spotify
}


install_gaps() {
  mkdir -p ~/bin
  cd ~/bin/
  git clone https://www.github.com/Airblader/i3 i3-gaps
  cd i3-gaps
  autoreconf --force --install
  rm -rf build/
  mkdir -p build && cd build/
  # Disabling sanitizers is important for release versions!
  # The prefix and sysconfdir are, obviously, dependent on the distribution.
  ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make
  make install
}

install_i3() {
  mkdir -p ~/.config/i3/
  apt install lxappearance arandr libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
              libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
              libstartup-notification0-dev libxcb-randr0-dev \
              libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
              libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
              autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev \
              i3lock i3lock-fancy i3-wm
}

install_browsers() {
  apt install firefox google-chrome-stable
}

install_python() {
  apt install -y build-essentials python3-pip libssl-dev libffi-dev python-dev python3-venv python2.7-dev python-setuptools python-pip dh-python
  pip3 install --upgrade setuptools
  pip3 install ez_setup ipython
  pip3 install -r ${TOP_DIR}/install/python_packages.txt
}

install_js() {
  apt install -y npm nodejs
  npm install -g eslint flow-bin babel-eslint eslint-plugin-react stylelint prettier eslint-config-prettier eslint-plugin-prettier --save-dev
  npm install --unsafe-perm -g htmlhint n javascript-typescript-langserver bash-language-server
}

install_languages() {
  apt install -y java-common perl mysql-server postgresql \
                 postgresql-contrib r-base perl-base openjdk-8-jdk \
                 bash bash-completion
}


install_office() {
  apt install -y cups evince libreoffice zathura wps-office
}


install_vim() {
  mkdir -p ~/.vim/vimundo ~/.vim/colors
  sudo chmod -R +777 ~/.vim
  # install Plug
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  apt install -y vim vim-common exuberant-ctags tidy lacheck xdotool ripgrep ack-grep
  python -m pip install flake8 vim-vint grip autopep8 isort python-language-server
  # flake8 is not compatible with pycodestyle >= 2.4.0
  python -m pip install pycodestyle==2.3.0
  python3 -m pip install pynvim
  # install plugins
  vim +PlugInstall +qall
}


install_essential_tools() {
  apt install -y sudo vim vim-common apache2 bzip2 tmux \
                 openvpn tabix unrar udev tar syslinux \
                 rsync redshift redshift-gtk parted gparted \
                 openssh-client openssh-server ntfs-3g ntfs-config \
                 ncurses-base ncurses-bin mtp-tools exfat-fuse \
                 exfat-utils curl zip cmake console-setup cli-common \
                 eject debianutils cron diffutils devscripts fontconfig \
                 ftp gcc gimp git-all grep gwenview htop joystick \
                 incron keyboard-configuration keytouch-editor \
                 language-pack-en manpages nano mount openssh-client \
                 openssh-server wget unzip update-manager tree \
                 time telnet xclip libfreetype6-dev libfontconfig1-dev \
                 libcurl4-openssl-dev libxml2-dev libxslt1-dev tidy \
                 mono-xbuild texlive-latex-base texlive-fonts-recommended vpnc \
                 texlive-latex-extra
}


install_android() {
  apt install -y android-tools-adb android-tools-fastboot
}



install_extras() {
  apt -y install youtube-dl xboxdrv transmission-cli \ 
                 transmission-daemon autojump ripgrep \
                 ack-grep source-highlight arandr feh
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  snap install tldr
}


download_projects() {
  mkdir ~/projects
  cd ~/projects
  repos=`curl "https://api.github.com/users/superDross/repos?per_page=1000" | grep -o 'git@[^"]*' | sed 's/git@github.com://g' | xargs`
  for repo in $repos; do
      git clone "https://github.com/"$repo
  done
}

backup_dotfiles() {
  if [ ! -f ~/.bashrc_OG ]; then
      mv ~/.bashrc ~/.bashrc_OG
  fi
  if [ -e ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc_OG
  fi
  if [ -e ~/.config/i3/config ]; then
    mv ~/.config/i3/config ~/.config/i3/config_BU
  fi
}


create_shortcuts() {
  ln -s ${TOP_DIR}/vim/vimrc ~/.vimrc
  ln -s ${TOP_DIR}/bash/bashrc ~/.bashrc
  cp ${TOP_DIR}/terminal/terminalrc  ~/config/xfce4/terminal/
  ln -s ${TOP_DIR}/tmux/tmux.conf ~/.tmux.conf
  ln -s ${TOP_DIR}/i3/config ~/.config/i3/config
  ln -s ${TOP_DIR}/i3/i3status.conf ~/.config/i3/i3status.conf
  ln -s ${TOP_DIR}/images/wallpaper.jpg ~/Downloads/wallpaper.jpg
}

set_tidy() {
  echo "indent: auto
  indent-spaces: 2
  quiet: yes
  tidy-mark: no
  wrap: 90" >> /etc/tidy.conf
}

main() {
  add_ppas
  install_essential_tools
  install_xfce
  install_i3
  install_gaps
  install_fonts
  install_browsers
  install_python
  install_js
  install_languages
  install_office
  install_multimedia
  install_android
  install_extras
  backup_dotfiles
  install_vim
  create_shortcuts
  download_projects
  set_tidy
}

main
