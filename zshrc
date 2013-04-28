# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

typeset -U PATH

# Allow VIM-commands in terminal (does not work)
# autoload -U edit-command-line
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="xtrv_lars"
# my last: xtrv_lars, extravagant, clean
# also interesting: gnzh, remiii
# default: "robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# old plugins: plugins=(git github heroku osx history ruby rvm brew vi-mode)
plugins=(osx history vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/Users/huluk/.rvm/bin:$PATH

bindkey -v

mvim() {
    stty stop '' -ixoff; /Applications/MacVim.app/Contents/MacOS/Vim -v $*
}
# this and stty stop '' -ixoff; make that ctrl is not intercepted by terminal
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

alias v=mvim

rb(){
    open -a /Applications/Firefox.app/ "http://ruby-doc.org/core/classes/$1.html"
}

rvm use default
