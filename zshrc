# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

typeset -U PATH

[[ -e /google ]] && export WORK=true
[[ $(uname) == "Linux" ]] && LINUX=true
[[ $(uname) == "Darwin" ]] && MACOS=true

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
# old plugins: plugins=(github heroku osx ruby vi-mode ruby rvm rbenv irb vi-mode)
plugins=(macos history pass git wd common-aliases brew colored-man-pages colorize history-substring-search)

source $ZSH/oh-my-zsh.sh

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

v(){ nvim -p $* }
alias vdiff='nvim -d'
alias vd='nvim -d -c "windo set wrap"'

# for git
alias -g create-upstream='--set-upstream origin $(git rev-parse --abbrev-ref HEAD)'

osm() {
  telnet mapscii.me
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

  # rbenv
  export RBENV_ROOT=/usr/local/var/rbenv
  eval "$(rbenv init -)"

fi

if [ $LINUX ]; then
  alias open=xdg-open
fi

if [ $WORK ]; then

  function gcert() {
      if [[ -n $TMUX ]]; then
          eval $(tmux show-environment -s)
      fi
      command gcert "$@"
  }

  function tmx() {
      tmx2 new -A -s work
  }

  # connect to cloudtop in background
  CLOUDTOP_SOCKET=~/.ssh/cloudtop
  CLOUDTOP_REMOTE=$USER.c.googlers.com
  DESKTOP_REMOTE=$USER.zrh.corp.google.com
  function cloudtop_connect() {
      ssh -S "$CLOUDTOP_SOCKET" "$CLOUDTOP_REMOTE" $*
  }
  function cloudtop_master() {
      cloudtop_connect -MNf
  }
  function cloudtop_attach() {
      cloudtop_connect -t "cd '$(pwd)'; zsh" $*
  }
  alias ca=cloudtop_attach

  function goodmorning() {
      # uses go/roadwarrior
      AUTH_SSH_CERTIFICATION=false
      if [ $MACOS ]; then
          rw "$DESKTOP_REMOTE" "$CLOUDTOP_REMOTE" --no_prodssh --command zsh
      else # linux
          rw "$CLOUDTOP_REMOTE" --no_prodssh --nossh_interactively
          cloudtop_master
      fi
  }

  if [ $LINUX ]; then

    function workspace() {
        g4d $1 &&
            tmux split-window -hb -p 64 -c "$(pwd)" &&
            tmux rename-window $1 &&
            [ $(print -P %M) = $CLOUDTOP_REMOTE ] || cloudtop_attach
    }
    alias w=workspace

    function cl() {
        CL=$(hg ll -r . | head -n1 | awk '{print $4}')
        open "http://${CL}"
    }

    # WORK-shortcuts
    jeval='java/com/google/lens/eval'
    jevals='java/com/google/lens/eval/evalservice'
    jteval='javatests/com/google/lens/eval'
    jtevals='javatests/com/google/lens/eval/evalservice'
    vvsl='vision/visualsearch/server/lens'

    source /etc/bash_completion.d/g4d
    alias intellij=/opt/intellij-ce-stable/bin/idea.sh

    alias gaiamint='/google/data/ro/projects/gaiamint/bin/get_mint  --type=loas --text --endusercreds --scopes=77900  --out=/tmp/auth.txt'

    unalias h
    alias hx='hg xl'
    alias hs='hg st'
    alias hy='hg sync'
    alias hu='hg ut'
    alias hd='hg diff'
    alias hpd='hg pdiff'
    alias ht='hg checkout tip'
    alias hh='hg checkout p4head'

    export LANGUAGE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    # Setup go/hi #!>>HI<<!#
    source /etc/bash.bashrc.d/shell_history_forwarder.sh #!>>HI<<!#
  fi

else # non-work

  alias octave="octave --no-gui"

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

  remarkable_backup(){
      rsync -auhP --rsync-path=/opt/bin/rsync \
          --exclude='*.cache' \
          --exclude='*.highlights' \
          --exclude='*.textconversion' \
          --exclude='*.thumbnails' \
          --exclude='*.pagedata' \
          'root@remarkable:/home/root/.local/share/remarkable/xochitl/*' \
          /Volumes/Huluk/remarkable-backup/files/
      }
  # if rsync -rv -zz --rsync-path=$remarkable_rsync_path --exclude='*.cache' --exclude='*.highlights' --exclude='*.textconversion' --exclude='*.thumbnails' --exclude='*.pagedata' $hostname:$remarkable_data_dir $local_backup_dir ; then

fi

# Setup go/hi #!>>HI<<!#
source /etc/bash.bashrc.d/shell_history_forwarder.sh #!>>HI<<!#
