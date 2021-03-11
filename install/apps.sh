#!/usr/bin/env sh

defaults write com.apple.PowerChime ChimeOnAllHardware -bool false &&
    killall PowerChime

brew install smartmontools gnupg2 pass pwgen fortune rbenv
brew install gnu-sed --with-default-names
brew install keyboard-maestro
brew install homebrew/cask/dash

# not working: 
brew install p7zip mas wd

brew install neovim
NEOVIM=~/.config/nvim/init.vim
mkdir -p ~/.config/nvim
pip install neovim

# download vim package manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

rm -f $NEOVIM
echo 'set runtimepath^=~/.vim runtimepath+=~/.vim/after' >> $NEOVIM
echo 'let &packpath = &runtimepath' >> $NEOVIM
echo 'source ~/.vimrc' >> $NEOVIM

brew install karabiner-elements
brew install alfred iterm2 firefox

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -s ~/hide/dotfiles/zshrc ~/.zshrc
cp xtrv_lars.zsh-theme ~/.oh-my-zsh/themes/

# gui apps
brew install appcleaner skype telegram steam transmission vlc calibre veracrypt

# Pixelmator
mas install 407963104
