#!/usr/bin/env sh

brew install smartmontools gnupg2 pass pwgen fortune wd

brew install neovim
NEOVIM=~/.config/nvim/init.vim
mkdir -p ~/.config/nvim
echo 'set runtimepath^=~/.vim runtimepath+=~/.vim/after' >> $NEOVIM
echo 'let &packpath = &runtimepath' >> $NEOVIM
echo 'source ~/.vimrc' >> $NEOVIM

brew cask install karabiner-elements bettertouchtool alfred flux iterm2 firefox
brew cask install dropbox skype telegram steam transmission vlc ynab tresorit ticktick
