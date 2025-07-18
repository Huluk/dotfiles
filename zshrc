# Path to your oh-my-zsh configuration
export ZSH=$HOME/.oh-my-zsh
export LANG=de_CH.UTF-8

typeset -U PATH

[[ $(uname) == "Linux" ]] && LINUX=true
[[ $(uname) == "Darwin" ]] && MACOS=true

# Set name of the theme to load ––– if set to "random", if will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="xtrv_lars"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "xtrv_lars" "extravagant" "clean" "gnzh" "remiii" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# previous plugins: git github heroku irb macos rbenv ruby rvm vi-mode
plugins=(brew colored-man-pages colorize history history-substring-search pass wd)

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'
alias ex='nvim -E -u ~/.exrc'

if [ $MACOS ]; then
  unalias run-help
  autoload run-help
  HELPDIR=/usr/local/share/zsh/help
  alias help=run-help
else
  HELPDIR=/usr/share/zsh/help
fi

# from https://g3doc.corp.google.com/company/users/julienbc/cmdline/index.md?cl=head#command-line-setup
zstyle ':completion:*' menu yes select
zstyle ':completion::complete:*' use-cache 1        #enables completion caching
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
zstyle ':completion:*' users root $USER             #fix lag in google3
autoload -Uz compinit && compinit -i
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# bindkey "[D" backward-word
# bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
bindkey "^[w" backward-kill-word

bindkey -v

v(){
  if [[ ( $# -eq 1 ) && ( "$*" =~ ^(.+):([[:digit:]]+)$ ) ]]; then
    nvim +${match[2]} ${match[1]}
  else
    nvim -p $*
  fi
}
alias vdiff='nvim -d'
alias vd='nvim -d -c "windo set wrap"'

# for git
alias -g create-upstream='--set-upstream origin $(git rev-parse --abbrev-ref HEAD)'

osm() {
  telnet mapscii.me
}

vtip() {
  curl -s -m 3 https://vtip.43z.one
}

# generate passwort of length $1
passgen(){
    [ $# -eq 0 ] && 1="16"
    gtr -dc "[A-Za-z0-9]" < /dev/random |
    head -c $1; echo
}

reload(){
  clear && fortune $*
}

export FZF_DEFAULT_COMMAND='rg --files'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ $MACOS ]; then

  # stty stop '' -ixoff; - ctrl is not intercepted by terminal
  # `Frozing' tty, so after any command terminal settings will be restored
  ttyctl -f

  alias umount="diskutil unmount"
  alias shuf="gshuf"
  alias 7z="7za"

  # switch sierra karabiner-elements config depending on keyboard
  keyboard() {
      ~/Documents/scripts/karabiner-elements_switch_keyboard $*
  }
  eval "$(mise activate zsh)"
fi

if [ $LINUX ]; then
  export PATH=$PATH:/usr/sbin

  alias open=xdg-open
fi

alias g="raku $HOME/hide/dotfiles/version_control.raku"

export ANDROID_HOME=/Users/huluk/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.pub-cache/bin

diary_open() {
    (wd text && cd diary &&
      ARG='' &&
      for DATE in $*; do ARG="$ARG $DATE.md"; done &&
      v $(echo "$ARG"))
}
diary() {
  [[ $# -ge 1 ]] && DIFF=$1 || DIFF=0
  [[ $DIFF -eq 0 ]] && DIFF=-0
  diary_open $(date -v${DIFF}d +%Y/%m-%d)
}

REMARKABLE_HOST=remarkable.wifi
RESTART_XOCHITL_DEFAULT=1
REMARKABLE_PARENT_DIR='4ec3a632-bbd8-445d-83e3-dd4897fc829d'
remarkable_backup(){
    rsync -auhP --rsync-path=/opt/bin/rsync \
        --exclude='*.cache' \
        --exclude='*.highlights' \
        --exclude='*.textconversion' \
        --exclude='*.thumbnails' \
        --exclude='*.pagedata' \
        "root@$REMARKABLE_HOST:/home/root/.local/share/remarkable/xochitl/*" \
        /Volumes/kEb8ASeZOpEE/remarkable-backup/files/
    }
# if rsync -rv -zz --rsync-path=$remarkable_rsync_path --exclude='*.cache' --exclude='*.highlights' --exclude='*.textconversion' --exclude='*.thumbnails' --exclude='*.pagedata' $hostname:$remarkable_data_dir $local_backup_dir ; then
