#!/usr/bin/env sh

# ! Switch to testing branch first, for current neovim

sudo apt update && sudo apt upgrade

sudo apt install curl gpg
sudo apt install ripgrep fzf
sudo apt install make cmake
sudo apt install python3-neovim ruby-neovim

sudo apt install htop tmux

sudo apt install rakudo raku-zef

sudo apt autoremove
