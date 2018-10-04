#!/bin/sh
TOP_DIR=$(dirname $(dirname "${BASH_SOURCE}"))

# back up old vimrc and set new one
if [ -e ~/.vimrc ]; then
	mv ~/.vimrc ~/.vimrc_OG
fi
ln -s ${TOP_DIR}/vimrc ~/.vimrc

# install vim plugin dependencies
apt install -y vim exuberant-ctags  nodejs npm tidy lacheck xdotool google-chrome tmux
python -m pip install flake8 vim-vint grip autopep8
# flake8 is not compatible with pycodestyle >= 2.4.0
python -m pip install pycodestyle==2.3.0

# create required dirs and install Plugins
mkdir -p ~/.vim/bundle ~/.vim/vimundo ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/
vim +PluginInstall +qall

# install fzf
~/.vim/bundle/fzf/install

# tmux stuff
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ${TOP_DIR}/tmux.conf ~/.tmux.conf

# js linters have to be installed on a per project basis
# npm install eslint babel-eslint eslint-plugin-react stylelint prettier eslint-config-prettier eslint-plugin-prettier --save-dev
# eslint --init
