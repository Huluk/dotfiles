# theme based on extravagant.zsh-theme
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    echo '≫' # orig: ➔
}

# dir_info: cheap VCS indicator with a zstat-based cache.
#
# The prompt calls `$(dir_info)`, which runs in a subshell, so any cache
# state assigned inside dir_info would be lost.  Instead we refresh the
# cache in a precmd hook (main shell) and dir_info just echoes.
#
# The cache key is $PWD plus the mtime of the first VCS marker found in
# $PWD (.jj/.git/.hg).  As long as that key is unchanged we skip the slow
# probes.  The cache self-invalidates when:
#   - $PWD changes
#   - a marker is created in $PWD (e.g. `git init` / `jj init`)
#   - a marker is removed from $PWD (e.g. `rm -rf .git`)
#   - a marker's mtime changes (e.g. `jj git init` on top of a git repo)
# For subdirectories of a repo the key is `nomarker:$PWD`, so the slow
# fallback (jj root / git rev-parse / hg root) runs at most once per cd.
zmodload -F zsh/stat b:zstat
autoload -Uz add-zsh-hook
_dir_info_cache=''
_dir_info_key=''

function _dir_info_update {
    # jj repos often have a git backing store, so check jj first
    local key found marker
    local -a mtime
    for marker in .jj .git .hg; do
        if [[ -e $marker ]]; then
            zstat -A mtime +mtime -- $marker 2>/dev/null
            key="$PWD:$marker:$mtime[1]"
            found=$marker
            break
        fi
    done
    : ${key:="nomarker:$PWD"}
    [[ $key == $_dir_info_key ]] && return
    _dir_info_key=$key
    case $found in
        .jj)  _dir_info_cache='jj ' ;;
        .git) _dir_info_cache='git ' ;;
        .hg)  _dir_info_cache='☿ ' ;;
        *)  # no marker in $PWD - fall back to slow walk-up probes
            if jj root >/dev/null 2>/dev/null; then
                _dir_info_cache='jj '
            elif git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null; then
                _dir_info_cache='git '
            elif hg root >/dev/null 2>/dev/null; then
                _dir_info_cache='☿ '
            else
                _dir_info_cache=''
            fi ;;
    esac
}
add-zsh-hook precmd _dir_info_update
_dir_info_update  # initial populate for the first prompt

function dir_info {
    echo $_dir_info_cache
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

PROMPT='
%{$fg_no_bold[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg[blue]%}$(dir_info)%{$fg_bold[red]%}$(collapse_pwd)%{$reset_color%}
%{$fg[cyan]%}$(virtualenv_info)$(prompt_char)%{$reset_color%} '

RPROMPT='$(battery_charge) %{$fg_no_bold[green]%}[%D{%H:%M:%S}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
