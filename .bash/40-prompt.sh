color_black='\[\e[0;30m\]'
color_red='\[\e[0;31m\]'
color_green='\[\e[0;32m\]'
color_yellow='\[\e[0;33m\]'
color_blue='\[\e[0;34m\]'
color_purple='\[\e[0;35m\]'
color_cyan='\[\e[0;36m\]'
color_white='\[\e[0;37m\]'
color_bold_black='\[\e[1;30m\]'
color_bold_red='\[\e[1;31m\]'
color_bold_green='\[\e[1;32m\]'
color_bold_yellow='\[\e[1;33m\]'
color_bold_blue='\[\e[1;34m\]'
color_bold_purple='\[\e[1;35m\]'
color_bold_cyan='\[\e[1;36m\]'
color_bold_white='\[\e[1;37m\]'
color_back_black='\[\e[40m\]'
color_back_red='\[\e[41m\]'
color_back_green='\[\e[42m\]'
color_back_yellow='\[\e[43m\]'
color_back_blue='\[\e[44m\]'
color_back_purple='\[\e[45m\]'
color_back_cyan='\[\e[46m\]'
color_back_white='\[\e[47m\]'
no_color='\[\e[0m\]'
EXTENDED_PROMPT=true

function trap_dbg {
    # This is a dirty trick to avoid additional prompt lines when hitting ENTER.
    # I did not find any more straight-forward way of doing that.
    local command="$BASH_COMMAND"
    if test "$command" != "set_bash_prompt"; then
        last_cmd="$command"
    fi
}

# This shall be refactored in mini functions!
function set_bash_prompt {
    local exit_code=$?
    local w
    local hostname=''
    local open_bracket="$color_bold_black[$no_color"
    local close_bracket="$color_bold_black]$no_color"
    trap '' DEBUG
    if test $exit_code -ne 0; then
        exit_code=" $color_bold_red[$exit_code]$no_color"
    else
        exit_code=''
    fi
    if test -d /vagrant; then
        hostname="$open_bracket$color_bold_blue@$(hostname -s)$close_bracket"
        w="$open_bracket$color_green\w$close_bracket"
    else
        w="$open_bracket$color_purple\w$close_bracket"
    fi
    if test "$TERM" == dumb; then
        PS1='[\w]: '
        return
    elif test "$EUID" = 0; then
        PS1="$open_bracket${color_back_red}ROOT:$color_red\w$close_bracket$exit_code: "
        return
    elif test -z "$last_cmd"; then
        PS1="$hostname$w: "
        return
    fi
    local repo
    local virtualenv=''
    local extended=${EXTENDED_PROMPT:-''}
    local branch=''
    repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    if test "$TERM" = "screen-256color"; then
        tmux rename-window "$(basename "${repo:-$PWD}")" &>/dev/null
    fi
    if test -v VIRTUAL_ENV; then
        virtualenv="$open_bracket$color_yellow($(basename $VIRTUAL_ENV))$no_color$close_bracket"
    fi
    if test -n "$extended"; then
        if test -n "$repo"; then
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
            branch="$open_bracket$color_blue<$branch>$close_bracket"
        fi
        PS1="$open_bracket$color_green\d \t$close_bracket"
        if test -n "$hostname"; then
            PS1+="$hostname"
        fi
        PS1+="$branch$virtualenv"
        PS1+="$open_bracket$color_purple\w$close_bracket$exit_code:"
        PS1+="\n$hostname$w$no_color: "
    else
        PS1="$virtualenv$w$no_color$close_bracket$exit_code: "
    fi
    last_cmd=
    trap trap_dbg DEBUG
}

export last_cmd=
trap trap_dbg DEBUG

PROMPT_COMMAND=set_bash_prompt

# For root: PS1='\[\e[01;30m\][\[\e[00m\e[01;07;31m\]ROOT:\[\e[00m\e[31m\]\w\[\e[00m\e[01;30m\]]\[\e[00m\]: '
