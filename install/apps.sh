#!/usr/bin/env sh

brew install smartmontools gnupg2 pass pwgen fortune wd rbenv
brew install gnu-sed --with-default-names

brew install neovim
NEOVIM=~/.config/nvim/init.vim
mkdir -p ~/.config/nvim
rm -f $NEOVIM
echo 'set runtimepath^=~/.vim runtimepath+=~/.vim/after' >> $NEOVIM
echo 'let &packpath = &runtimepath' >> $NEOVIM
echo 'source ~/.vimrc' >> $NEOVIM

brew cask install karabiner-elements bettertouchtool alfred flux iterm2 firefox

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -s ~/hide/dotfiles/zshrc ~/.zshrc
cp xtrv_lars.zsh-theme ~/.oh-my-zsh/themes/

# gui apps
brew cask install appcleaner dropbox skype telegram steam transmission vlc ynab tresorit ticktick calibre fluid veracrypt gpgtools torbrowser
