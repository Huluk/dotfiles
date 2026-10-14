#!/usr/bin/env sh

DIR=~/hide/dotfiles

link() {
    ln -sn "$DIR/$1" "$2"
}

link vim ~/.vim
link vimrc ~/.vimrc
link zshrc ~/.zshrc
link inputrc ~/.inputrc
link irbrc ~/.irbrc
link bashrc ~/.bashrc
link bash_profile ~/.bash_profile

link gitconfig ~/.gitconfig
link gitignore_global ~/.gitignore_global
link hgrc ~/.hgrc
link codebuff_knowledge.md ~/.knowledge.md

mkdir -p ~/.config/nvim
link vim/init.lua ~/.config/nvim/init.lua
link vim/lua ~/.config/nvim/lua
link vim/lsp ~/.config/nvim/lsp

mkdir -p ~/.ssh
link ssh_config ~/.ssh/config
link tmux.conf ~/.tmux.conf

if [ "$(uname)" = Darwin ]; then
    cp -R "$DIR/mvim.app" /Applications/
    link karabiner ~/.config/karabiner
fi
