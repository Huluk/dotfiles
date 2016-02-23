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
plugins=(osx history git wd common-aliases)

source $ZSH/oh-my-zsh.sh

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# Customize to your needs...
export PATH=/usr/local/include:/usr/local/bin:/usr/local/lib:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin:/usr/local/k/bin:$PATH

# bindkey "[D" backward-word
# bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
bindkey "^[w" backward-kill-word

bindkey -v

mvim(){
    stty stop '' -ixoff; /Applications/MacVim.app/Contents/MacOS/Vim -v -p $*
}
# stty stop '' -ixoff; - ctrl is not intercepted by terminal
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

alias v=mvim

rb(){
    open -a /Applications/Firefox.app/ \
    "http://ruby-doc.org/core/classes/$1.html"
}

cdun() {cd /Volumes/BoxCryptor/Dropbox/Crypt/Text\ und\ Schrift/Uni/}
cdb() {cd ~/Documents/Programmieren/gitblog/}

alias d="mvim /Volumes/BoxCryptor/Dropbox/Crypt/Text\ und\ Schrift/d.md"
alias t="mvim /Volumes/BoxCryptor/Dropbox/Crypt/Text\ und\ Schrift/todo.md"
alias umount="diskutil unmount"
alias shuf="gshuf"

# count lines of files matching $1 in directory $2 (defaults to .)
countlines(){
    [ $# -eq 1 ] && 2="."
    find $2 -name $1 -print0 |
    xargs -0 cat 2>/dev/null |
    wc -l | awk '{print $1}'
}

addclock(){
    while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &
}
# quit with fg and <Ctrl-c>

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

dice_init() {
    kinit s1520582@INF.ED.AC.UK
}
dice(){
    ssh -Y student.ssh.inf.ed.ac.uk -t 'ssh student.login; bash -l'
}
dicec(){
    ssh -Y student.ssh.inf.ed.ac.uk -t 'ssh student.compute; bash -l'
}

pdfunite(){
    echo "sejda merge -o outfile -f infiles"
}
santander(){
    getspwd $(pass 'uk/santander/1679031081') $*
}
santander-online(){
    getspwd $(pass 'uk/santander/online') $*
}
getspwd(){
    PWD=$1
    i1=$2; ((--i1))
    i2=$3; ((--i2))
    i3=$4; ((--i3))
    echo "${PWD:$i1:1}${PWD:$i2:1}${PWD:$i3:1}"
}

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init -)"

clear
fortune -s
