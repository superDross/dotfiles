#!/bin/sh

# install vim plugin dependecies
apt install -y vim git exuberant-ctags autopep8 nodejs npm tidy lacheck xdotool google-chrome
python -m pip install flake8 vim-vint grip
# flake8 is not compatible with pycodestyle >= 2.4.0
python -m pip install pycodestyle==2.3.0

# create required dirs and install Vundle
mkdir -p ~/.vim/bundle/ ~/.vim/vimundo/
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/

# go into .vimrc and :PluginInstall

# js linters have to be installed on a per project basis
# npm install eslint babel-eslint eslint-plugin-react stylelint prettier eslint-config-prettier eslint-plugin-prettier --save-dev
