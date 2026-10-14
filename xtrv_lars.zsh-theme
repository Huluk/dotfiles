# theme based on extravagant.zsh-theme

# dir_info: cheap VCS indicator with a zstat-based cache.
#
# The cache is refreshed in a precmd hook and the prompt reads
# $_dir_info_cache directly, avoiding a subshell per prompt.
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

PROMPT='
%{$fg_no_bold[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg[blue]%}${_dir_info_cache}%{$fg_bold[red]%}%~%{$reset_color%}
%{$fg[cyan]%}${VIRTUAL_ENV:+(${VIRTUAL_ENV:t}) }≫%{$reset_color%} '

RPROMPT='%{$fg_no_bold[green]%}[%D{%H:%M:%S}]%{$reset_color%}'
