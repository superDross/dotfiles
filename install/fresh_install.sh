#!/bin/sh

# MANUAL INSTALLATIONS; WPS doesn't work in 18.04
manual="WPS"
echo "The following will have to be installed manually:"
echo $manual
sleep 10

# add PPAs
add-apt-repository ppa:atareao/telegram

# Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |  apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

# SPOTIFY
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list

# update with new PPAs
apt update

# multimedia packages
apt -y install xubuntu-restricted-extras libdvd-pkg steam telegram vlc steamcmd spotify-client

#  general must haves
apt -y install sudo build-essential firefox google-chrome-stable apache2 bzip2 tmux cups evince java-common libreoffice mysql-server openvpn perl postgresql postgresql-contrib r-base tabix youtube-dl xboxdrv vpnc vim vim-common unrar udev transmission-cli tar syslinux rsync redshift redshift-gtk perl-base parted gparted openssh-client openssh-server openjdk-8-jdk ntfs-3g ntfs-config ncurses-base ncurses-bin mtp-tools git exfat-fuse exfat-utils curl bash bioperl zip bash-completion cmake console-setup cli-common ffmpeg chromium-codecs-ffmpeg-extra eject debianutils cron diffutils devscripts fontconfig ftp gcc gimp git-all grep gwenview htop joystick  incron keyboard-configuration keytouch-editor language-pack-en manpages nano mount npm openssh-client openssh-server wget unzip udev update-manager udev tree transmission-daemon time telnet xclip libfreetype6-dev libfontconfig1-dev libcurl4-openssl-dev libxml2-dev libxslt1-dev

# python stuff
apt install -y python3-pip libssl-dev libffi-dev python-dev python3-venv python2.7-dev python-setuptools python-pip dh-python
 
# install all pythonpackages
pip3 install --upgrade setuptools
pip3 install ez_setup ipython
pip3 install -r ~/projects/dotfiles/install/python_packages.txt

# android 
apt install -y android-tools-adb android-tools-fastboot

# Download all github repos
mkdir ~/projects
cd ~/projects
repos=`curl "https://api.github.com/users/superDross/repos?per_page=1000" | grep -o 'git@[^"]*' | sed 's/git@github.com://g' | xargs`
for repo in $repos; do 
    git clone "https://github.com/"$repo
done

# setup dot files
if [ ! -f ~/.bashrc_OG ]; then
    mv ~/.bashrc ~/.bashrc_OG
fi
ln -s ~/projects/dotfiles/bashrc ~/.bashrc
mv ~/.vimrc ~/.vimrc_OG
ln -s ~/projects/dotfiles/vimrc ~/.vimrc
 
# set up vim stuff
# NOTE: the colorschemes may need to be moved from bundle to colors dir
mkdir -p ~/.vim/colors ~/.vim/vimundo ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
