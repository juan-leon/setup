if test -v SUDO_USER; then
    if test -e /home/$SUDO_USER/.sudo_bash_aliases; then
        source /home/$SUDO_USER/.sudo_bash_aliases
    fi
fi

color_red='\[\e[0;31m\]'
color_green='\[\e[0;32m\]'
color_yellow='\[\e[0;33m\]'
color_blue='\[\e[0;34m\]'
color_purple='\[\e[0;35m\]'
color_bold_black='\[\e[1;30m\]'
color_bold_red='\[\e[1;31m\]'
color_bold_blue='\[\e[1;34m\]'
color_back_red='\[\e[41m\]'
no_color='\[\e[0m\]'

PROMPT_HOST=${PROMPT_HOST:-$(hostname)}

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
    trap '' DEBUG
    if test "$TERM" == dumb; then
        if test "$EUID" = 0; then
            PS1="[ROOT@$PROMPT_HOST:\w]# "
        else
            PS1="[\u@$PROMPT_HOST:\w]\$ "
        fi
        return
    fi
    if test $exit_code -ne 0; then
        exit_code=" $color_bold_red[$exit_code]$no_color"
    else
        exit_code=''
    fi
    local open_bracket="$color_bold_black[$no_color"
    local close_bracket="$no_color$color_bold_black]$no_color"
    local host="$open_bracket$color_bold_blue@$PROMPT_HOST$close_bracket"

    if test "$EUID" = 0; then
        local user="$open_bracket${color_back_red}ROOT$close_bracket"
        local single_line_ps1="$user$host$open_bracket$color_red\W$close_bracket# "
    else
        local user="$open_bracket$color_yellow\u$close_bracket"
        local single_line_ps1="$user$host$open_bracket$color_purple\W$close_bracket$ "
    fi
    if test -z "$last_cmd"; then
        PS1="$single_line_ps1"
        return
    fi
    local branch=''
    local dir="$open_bracket$color_purple\w$close_bracket"
    if git rev-parse --show-toplevel &>/dev/null; then
        branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        branch="$open_bracket$color_blue<$branch>$close_bracket"
    fi

    PS1="$open_bracket$color_green\d \t$close_bracket"
    PS1+="$branch$dir"
    PS1+="$exit_code\n$single_line_ps1"
    last_cmd=
    trap trap_dbg DEBUG
}

export last_cmd=
trap trap_dbg DEBUG

PROMPT_COMMAND=set_bash_prompt
