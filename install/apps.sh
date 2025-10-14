#!/usr/bin/env sh

defaults write com.apple.PowerChime ChimeOnAllHardware -bool false &&
    killall PowerChime

brew install coreutils
brew install gnu-sed --with-default-names
brew install rsync ripgrep fd wget

brew install smartmontools gnupg
brew install pass fortune tldr jq git jj

# Mise-en-place
brew install mise
mise install ruby python node
brew install libyaml # ruby dependency
mise use -g ruby python node

# Neovim
brew install neovim
mkdir -p ~/.config/nvim
gem install neovim
pip install neovim
npm install -g neovim
brew install lua-language-server

# Optional stuff
brew install rakudo-star
brew install yt-dlp

# gui apps
brew install --cask scroll-reverser
brew install --cask karabiner-elements flux raycast quitter
brew install --cask jordanbaird-ice
brew install --cask iterm2 firefox obsidian
brew install --cask proton-mail-bridge nordvpn
brew install --cask appcleaner cryptomator veracrypt gpg-suite
brew install --cask skype telegram whatsapp signal discord
brew install --cask transmission steam mediathekview
brew install --cask vlc spotify calibre

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f ~/.zshrc
ln -s ~/hide/dotfiles/zshrc ~/.zshrc
cp xtrv_lars.zsh-theme ~/.oh-my-zsh/themes/
cp -r completions ~/.oh-my-zsh/
