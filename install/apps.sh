#!/usr/bin/env sh

brew install smartmontools gnupg2 pass pwgen fortune wd rbenv
brew install gnu-sed --with-default-names
brew install p7zip

brew install neovim
NEOVIM=~/.config/nvim/init.vim
mkdir -p ~/.config/nvim
pip install neovim

# TODO download vim package manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

rm -f $NEOVIM
echo 'set runtimepath^=~/.vim runtimepath+=~/.vim/after' >> $NEOVIM
echo 'let &packpath = &runtimepath' >> $NEOVIM
echo 'source ~/.vimrc' >> $NEOVIM

brew cask install karabiner-elements bettertouchtool hammerspoon
brew cask install alfred flux iterm2 firefox

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -s ~/hide/dotfiles/zshrc ~/.zshrc
cp xtrv_lars.zsh-theme ~/.oh-my-zsh/themes/

# gui apps
brew cask install appcleaner dropbox skype telegram steam transmission vlc ynab tresorit ticktick calibre veracrypt gpgtools torbrowser
