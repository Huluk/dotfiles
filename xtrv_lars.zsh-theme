# theme based on extravagant.zsh-theme
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    echo '≫' # orig: ➔
}

function dir_info {
    git branch >/dev/null 2>/dev/null && echo 'git '
    hg root >/dev/null 2>/dev/null && echo '☿ '
}

function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

function thetime {
    date '+%H:%M:%S'
}

function hostname {
    [ $WORK ] && [ $LINUX ] && echo '%3m' || echo '%m'
}

PROMPT='
%{$fg_no_bold[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}$(hostname)%{$reset_color%} in %{$fg[blue]%}$(dir_info)%{$fg_bold[red]%}$(collapse_pwd)%{$reset_color%}
%{$fg[cyan]%}$(virtualenv_info)$(prompt_char)%{$reset_color%} '

RPROMPT='$(battery_charge) %{$fg_no_bold[green]%}[$(thetime)]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
