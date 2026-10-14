#!/usr/bin/env sh

DIR=~/hide/dotfiles

RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sfn "$DIR/zshrc" ~/.zshrc
mkdir -p ~/.oh-my-zsh/custom/themes
ln -sfn "$DIR/xtrv_lars.zsh-theme" ~/.oh-my-zsh/custom/themes/xtrv_lars.zsh-theme
