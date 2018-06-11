#!/bin/sh

# MANUAL INSTALLATIONS
manual="WPS"
echo "The following will have to be installed manually:"
echo $manual
sleep 10


# add PPAs
add-apt-repository ppa:atareao/telegram

# update with new PPAs
apt update

# multimedia packages
apt -y install xubuntu-restricted-extras libdvd-pkg steam telegram vlc mozilla-plugin-vlc steamcmd

# SPOTIFY
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list
apt-get update
apt-get install spotify-client

#  general must haves
apt -y install sudo build-essential firefox google-chrome-stable apache2 bzip2 tmux cups evince java-common libreoffice mysql-server openvpn perl postgresql postgresql-contrib r-base tabix youtube-dl xboxdvr vpnc vim vim-common unrar udev transmission-cli tar syslinux rsync redshift redshift-gtk perl-base parted gparted openssh-client openssh-server openjdk-8-jdk ntfs-3g ntfs-config ncurses-base ncurses-bin mtp-tools git exfat-fuse exfat-utils curl bash bioperl zip bash-completion cmake console-setup cli-common ffmpeg chromium-codecs-ffmpeg-extra eject debianutils cron diffutils devscripts fontconfig ftp gcc gimp git-all grep gwenview htop joystick  incron keyboard-configuration keytouch-editor language-pack-en manpages nano mount npm openssh-client openssh-server pulse-audio-module-bluetooth wget unzip udev update-manager udev udisks tree transmission-daemon time telnet

# python stuff
apt install python3-pip libssl-dev libffi-dev python-dev python3-venv python2.7-dev python-setuptools python-pip dh-python

# install all pythonpackages
pip3 install -r python_packages.txt

# android 
apt install android-platform-tools android-tools-adb android-tools-fastboot

# Download all github repos
mkdir ~/projects
cd ~/projects
curl "https://api.github.com/users/superDross/repos?per_page=1000" | grep -o 'git@[^"]*' | xargs -L1 git clone

# setup dot files
mv ~/.bashrc ~/.bashrc_OG
ln -s ~/projects/dotfiles/bashrc ~/.bashrc
mv ~/.vimrc ~/.vimrc_OG
ln -s ~/projects/dotfiles/vimrc ~/.vimrc

# set up vim stuff
# NOTE: the colorschemes may need to be moved from bundle to colors dir
mkdir -p ~/.vim/colors ~/.vim/vimundo ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
