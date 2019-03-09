#!/bin/sh

# NOTE: https://gitlab.com/cbo77/dotfiles
# the above setup is better

TOP_DIR=$(dirname $(dirname "${BASH_SOURCE}"))

# MANUAL INSTALLATIONS; WPS doesn't work in 18.04
manual="WPS"
echo "The following will have to be installed manually:"
echo $manual
sleep 10

mkdir -p ~/.fonts/ ~/bin/ ~/.config/i3/

# font install
echo "Installing fonts..."
cp -r ${TOP_DIR}/fonts/ ~/.fonts/
fc-cache -f -v

# add PPAs
add-apt-repository ppa:atareao/telegram
add-apt-repository ppa:daniruiz/flat-remix
add-apt-repository ppa:system76/pop

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

# i3 specific stuff
apt install lxappearance arandr i3 libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev \
i3lock i3lock-fancy i3-wm

# i3-gaps
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

#  general must haves
# NOTE: this will likely break
apt -y install sudo build-essential firefox google-chrome-stable apache2 bzip2 tmux cups evince java-common libreoffice mysql-server openvpn perl postgresql postgresql-contrib r-base tabix youtube-dl xboxdrv vpnc vim vim-common unrar udev transmission-cli tar syslinux rsync redshift redshift-gtk perl-base parted gparted openssh-client openssh-server openjdk-8-jdk ntfs-3g ntfs-config ncurses-base ncurses-bin mtp-tools git exfat-fuse exfat-utils curl bash bioperl zip bash-completion cmake console-setup cli-common ffmpeg chromium-codecs-ffmpeg-extra eject debianutils cron diffutils devscripts fontconfig ftp gcc gimp git-all grep gwenview htop joystick  incron keyboard-configuration keytouch-editor language-pack-en manpages nano mount npm openssh-client openssh-server wget unzip udev update-manager udev tree transmission-daemon time telnet xclip libfreetype6-dev libfontconfig1-dev libcurl4-openssl-dev libxml2-dev libxslt1-dev tidy mono-xbuild texlive-latex-base texlive-fonts-recommended texlive-latex-extra autojump ripgrep ack-grep source-highlight arandr zathura feh

# HTML linter for vim ale
npm install htmlhint -g

# XFCE theme stuff
sudo apt install -y flat-remix arc-theme pop-theme flat-remix-gnome font-inconsolata xfce4-battery-plugin

# python stuff
apt install -y python3-pip libssl-dev libffi-dev python-dev python3-venv python2.7-dev python-setuptools python-pip dh-python

# javascript stuff
npm install -g eslint
npm install -g eslint-plugin-react
npm install --global prettier-eslint
 
# install all pythonpackages
pip3 install --upgrade setuptools
pip3 install ez_setup ipython
pip3 install -r ${TOP_DIR}/install/python_packages.txt

# android 
apt install -y android-tools-adb android-tools-fastboot

# Download all github repos
mkdir ~/projects
cd ~/projects
repos=`curl "https://api.github.com/users/superDross/repos?per_page=1000" | grep -o 'git@[^"]*' | sed 's/git@github.com://g' | xargs`
for repo in $repos; do 
    git clone "https://github.com/"$repo
done

# setup font
# NOTE: this should no longer be required
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
unzip Hack-v3.003-ttf.zip
mv ttf/ /usr/share/fonts/
rm -r ttf/
git clone https://github.com/source-foundry/Hack/
cp Hack/config/fontconfig/*  /etc/fonts/conf.d/
rm -rf Hacks/
fc-cache -f -v

# setup dot files
if [ ! -f ~/.bashrc_OG ]; then
    mv ~/.bashrc ~/.bashrc_OG
fi
if [ -e ~/.vimrc ]; then
	mv ~/.vimrc ~/.vimrc_OG
fi
#
ln -s ${TOP_DIR}/vimrc ~/.vimrc
ln -s ${TOP_DIR}/bashrc ~/.bashrc
ln -s ${TOP_DIR}/vimrc ~/.vimrc
cp ${TOP_DIR}/terminalrc  ~/config/xfce4/terminal/ 
ln -s ${TOP_DIR}/tmux.conf ~/.tmux.conf
ln -s ${TOP_DIR}/i3/config ~/.config/i3/config
ln -s ${TOP_DIR}/i3/i3status.conf ~/.config/i3/i3status.conf
 
# set up vim stuff
# NOTE: the colorschemes may need to be moved from bundle to colors dir
mkdir -p ~/.vim/colors ~/.vim/vimundo ~/.vim/bundle
sudo chmod -R +777 ~/.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# some global rules for tidy applictaion
echo "indent: auto
indent-spaces: 2
quiet: yes
tidy-mark: no
wrap: 90" >> /etc/tidy.conf

echo "ensure to install wting/autojump and junegunn/fzf"
