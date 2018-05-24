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
# old plugins: plugins=(osx history vi-mode ruby rbenv irb)
plugins=(osx history git wd common-aliases brew colored-man-pages colorize history-substring-search)

source $ZSH/oh-my-zsh.sh

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# Customize to your needs...
export PATH=/usr/local/include:/usr/local/bin:/usr/local/lib:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin:/usr/local/k/bin:$PATH

# bindkey "[D" backward-word
# bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
bindkey "^[w" backward-kill-word

bindkey -v

# stty stop '' -ixoff; - ctrl is not intercepted by terminal
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

v(){ nvim -p $* }
alias vdiff='nvim -d'
alias vd='nvim -d'

rb(){
    open -a /Applications/Firefox.app/ \
    "http://ruby-doc.org/core/classes/$1.html"
}

diary_open(){
    (wd text && cd diary &&
      ARG='' &&
      for DATE in $*; do ARG="$ARG $DATE.md"; done &&
      v $(echo "$ARG"))
}
diary(){
  [[ $# -ge 1 ]] && DIFF=$1 || DIFF=0
  [[ $DIFF -eq 0 ]] && DIFF=-0
  diary_open $(date -v${DIFF}d +%Y/%m-%d)
}

alias umount="diskutil unmount"
alias shuf="gshuf"
unalias t

# switch sierra karabiner-elements config depending on keyboard
keyboard() {
  ~/Documents/scripts/karabiner-elements_switch_keyboard $*
}

osm() {
  telnet mapscii.me
}

# count lines of files matching $1 in directory $2 (defaults to .)
countlines(){
    [ $# -eq 1 ] && 2="."
    find $2 -name $1 -print0 |
    xargs -0 cat 2>/dev/null |
    wc -l | awk '{print $1}'
}

# generate passwort of length $1
passgen(){
    [ $# -eq 0 ] && 1="16"
    gtr -dc "[A-Za-z0-9]" < /dev/random |
    head -c $1; echo
}

# copy $1 as $2 to subdir when $3 is present
add_when_found(){
    find . -name $3 |
    xargs -n 1 dirname |
    sed 's!$!/'$2'!' |
    xargs -I target cp $1 target
}

reload(){clear && fortune $*}

pdfunite(){
    echo "sejda merge -o outfile -f infiles"
}

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init -)"

# java-home

# mono
export MONO_GAC_PREFIX="/usr/local"

# perl
PATH="/Users/huluk/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/huluk/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/huluk/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/huluk/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/huluk/perl5"; export PERL_MM_OPT;

clear

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
