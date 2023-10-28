#!/usr/bin/env sh

DIR=~/hide/dotfiles

ln -s $DIR/vim ~/.vim
ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/gvimrc ~/.gvimrc
ln -s $DIR/zprofile ~/.zprofile
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/inputrc ~/.inputrc
ln -s $DIR/irbrc ~/.irbrc
ln -s $DIR/bashrc ~/.bashrc
ln -s $DIR/bash_profile ~/.bash_profile

ln -s $DIR/gitconfig ~/.gitconfig
ln -s $DIR/gitignore_global ~/.gitignore_global
ln -s $DIR/hgrc ~/.hgrc

mkdir -p ~/.config/nvim
ln -s $DIR/nvim_init.vim ~/.config/nvim/init.vim

ln -s $DIR/ssh_config ~/.ssh/config
ln -s $DIR/tmux.conf ~/.tmux.conf

# Mac OS only!
if [[ $OSTYPE = darwin* ]]; then
    cp -r $DIR/mvim.app /Applications/mvim.app
    ln -s $DIR/hammerspoon ~/.hammerspoon
    ln -s $DIR/karabiner ~/.config/karabiner
fi
