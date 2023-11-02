# Path to your oh-my-zsh configuration
export ZSH=$HOME/.oh-my-zsh

typeset -U PATH

[[ -e /google ]] && export WORK=true
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
# old plugins: plugins=(github heroku osx ruby vi-mode ruby rvm rbenv irb vi-mode)
plugins=(macos history pass git wd common-aliases brew colored-man-pages colorize history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'

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
          rw "$CLOUDTOP_REMOTE" --no_prodssh --command zsh
      else # linux
          rw --no_prodssh --nossh_interactively
      fi
  }

  if [ $LINUX ]; then

    function workspace() {
        g4d $1 &&
            tmux split-window -hb -p 64 -c "$(pwd)" &&
            tmux rename-window $1
    }
    alias w=workspace

    function cl() {
        open "http://cl/$(hg exportedcl)"
    }

    # WORK-shortcuts
    jeval='java/com/google/lens/eval'
    jevals='java/com/google/lens/eval/evalservice'
    jteval='javatests/com/google/lens/eval'
    jtevals='javatests/com/google/lens/eval/evalservice'
    vvsl='vision/visualsearch/server/lens'

    source /etc/bash_completion.d/g4d
    alias intellij='/opt/intellij-ce-stable/bin/idea.sh'

    alias gaiamint='/google/data/ro/projects/gaiamint/bin/get_mint  --type=loas --text --endusercreds --scopes=77900  --out=/tmp/auth.txt'

    alias jarvis_cli='/google/bin/releases/ke-graph-exp/tools/jarvis_cli'
    alias bs2='/google/bin/releases/blobstore2/tools/bs2/bs2'

    unalias h
    alias h="raku $HOME/hidden/dotfiles/version_control.raku"
    alias hx='chg xl'
    alias hl='chg ll'
    alias hs='chg st'

    alias hy='chg sync'
    alias hsy='chg sync'

    alias hu='chg upload'
    alias hut='chg upload tree'

    alias ha='chg amend'
    alias hau='chg amend && chg upload'
    alias haut='chg amend && chg upload tree'
    alias haeut='chg amend && chg evolve && chg upload tree'
    alias hay='chg amend && chg sync'
    alias hayu='chg amend && chg sync && chg upload'
    alias hayut='chg amend && chg sync && chg upload tree'
    alias hyu='chg sync && chg upload'
    alias hyu='chg sync && chg upload tree'

    alias hd='chg diff'
    alias hpd='chg pdiff'
    alias hdp='chg pdiff'
    alias hdu='chg diffexported'
    alias hdsnap='chg diffexported'

    alias hc='chg checkout'
    alias hct='chg checkout tip'
    alias hch='chg checkout p4head'
    function hcparent() {
      # TODO support parameter to go to grandparents etc.
      chg checkout 'p1(p1())' && chg log --rev 'p1()' | echo
    }

    export LANGUAGE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    # Setup go/hi #!>>HI<<!#
    source /etc/bash.bashrc.d/shell_history_forwarder.sh #!>>HI<<!#
  fi

else # non-work

  alias octave="octave --no-gui"

  export ANDROID_HOME=/Users/huluk/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

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
          /Volumes/kEb8ASeZOpEE/remarkable-backup/files/
      }
  # if rsync -rv -zz --rsync-path=$remarkable_rsync_path --exclude='*.cache' --exclude='*.highlights' --exclude='*.textconversion' --exclude='*.thumbnails' --exclude='*.pagedata' $hostname:$remarkable_data_dir $local_backup_dir ; then

fi
