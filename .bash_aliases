# -*- mode: sh -*-

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dc='cd'
alias down='http_proxy="http://localhost:3129/" wget -S -x --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:22.0) Gecko/20130328 Firefox/22.0"'
alias downc='http_proxy="http://localhost:3129/" wget -S -x --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:22.0) Gecko/20130328 Firefox/22.0" --header="Accept-Encoding: gzip"'
alias downp='http_proxy="http://10.0.3.151:3129" wget -S -x'
alias downt='http_proxy="http://localhost:3129/" wget -S -x'
alias e='emacsclient --alternate-editor /usr/bin/emacs'
alias s='git status'
alias eb='emacsclient -n --alternate-editor /usr/bin/emacs'
alias egrep='egrep --color=auto'
alias emacs='emacs -mm'
alias fgrep='fgrep --color=auto'
alias gls='git --no-pager ls -6 ; echo'
alias grep='grep --color=auto'
alias iats='g iats code'
alias jscore='cd $HOME/www/iats/code/jscore'
alias l='ls -CF'
alias la='ls -A'
alias lrt='ls -lrt'
alias phpcore='cd $HOME/www/iats/code/jscore/phpcore'
alias screen='screen "-e^Xx"'
alias setgrep='set | grep'
alias wire-log='multitail -n 500 -cS wire /var/log/wire/wire.log'
alias wlog='multitail -n 500 -CS wire'

export EDITOR='/usr/bin/emacsclient --alternate-editor /usr/bin/emacs'
if test -f ~/.domainname; then
    export EMAIL=juanleon.lahoz@$(cat ~/.domainname)
fi

PATH=/home/juanleon/bin/git/bin:/home/juanleon/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/lightdm/lightdm:/home/juanleon/.local/bin

function highlight_exit_code {
    local exit_code=$1
    if test "$TERM" != "dumb" && test $exit_code -ne 0; then
        echo -n '\[\e[01;31m\]'" [$exit_code]"'\[\e[00m\]'
    fi
}

function print_virtualenv {
    if test -v VIRTUAL_ENV; then
        echo -n "($(basename $VIRTUAL_ENV)) "
    fi
}

function write_tmux_title {
    local title
    title="$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)"
    tmux rename-window "$(basename "$title")"
    #printf '\033k%s\033\\' "$(basename "$title")"
}

function set_bash_prompt_old {
    local exit_code=$?
    if test "$TERM" = "screen-256color"; then
        write_tmux_title
    fi
    PS1="\[\e[01;30m\][\[\e[00m\e[35m\]$(print_virtualenv)\w\[\e[00m\e[01;30m\]]\[\e[00m\]$(highlight_exit_code $exit_code): "
}


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

function set_bash_prompt {
    local exit_code=$?
    local open_bracket="$color_bold_black[$no_color"
    local close_bracket="$color_bold_black]$no_color"
    trap '' DEBUG
    if test "$TERM" == dumb; then
        PS1='[\w]: '
        return
    elif test -z "$last_cmd"; then
        PS1="$open_bracket$color_purple\w$no_color$close_bracket: "
        return
    fi
    local virtualenv=''
    local extended=${EXTENDED_PROMPT:-''}
    local branch=''
    local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    if test "$TERM" = "screen-256color"; then
        tmux rename-window "$(basename "${repo:-$PWD}")"
    fi
    if test $exit_code -ne 0; then
        exit_code=" $color_bold_red"["$exit_code"]"$no_color"
    else
        exit_code=''
    fi
    if test -v VIRTUAL_ENV; then
        virtualenv="$open_bracket$color_yellow($(basename $VIRTUAL_ENV))$no_color$close_bracket"
    fi
    if test -n "$extended"; then
        if test -n "$repo"; then
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
            branch="$open_bracket$color_blue<$branch>$no_color$close_bracket"
        fi
        PS1="$open_bracket$color_green\d \t$no_color$close_bracket"
        PS1="$PS1$branch$virtualenv"
        PS1="$PS1$open_bracket$color_purple\w$no_color$close_bracket$exit_code:"
        PS1="$PS1\n$open_bracket$color_purple\w$no_color$close_bracket: "
    else
        PS1="$virtualenv$open_bracket$color_purple\w$no_color$close_bracket$exit_code: "
    fi
    last_cmd=
    trap trap_dbg DEBUG
}

export last_cmd=
trap trap_dbg DEBUG

PROMPT_COMMAND=set_bash_prompt

# PS1="[\D{%Y-%m-%d} \t] \u@\h:\w\a \${?##0} \$ "
# For root: PS1='\[\e[01;30m\][\[\e[00m\e[01;07;31m\]ROOT:\[\e[00m\e[31m\]\w\[\e[00m\e[01;30m\]]\[\e[00m\]: '

GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=34:fn=35:ln=32:bn=32:se=36"


if test -e /usr/local/bin/virtualenvwrapper.sh; then
    export WORKON_HOME=~/.envs
    source /usr/local/bin/virtualenvwrapper.sh
fi


REPODIR=/home/juanleon/www

function cd2 {
    if test "$TERM" = "screen-256color"; then
        builtin cd "$@" && printf '\033k%s\033\\' "$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)")"
    else
        builtin cd "$@"
    fi
}

function v_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window "#[bg=yellow,fg=black]$1"
    fi
    vagrant ssh $1
    cd .
}

function l_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window "#[bg=yellow,fg=black]$1"
    fi
    lxc exec $1 bash
    cd .
}

function r_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window "#[bg=green]$1"
    fi
    /usr/bin/ssh "$@"
    cd .
}

alias ssh=r_ssh

# For virtuals: printf '\033k%s\033\\' $(hostname)

function g {
    if [ -d $REPODIR/$1/$2 ]; then
        cd $REPODIR/$1/$2
    else
        cd $REPODIR/$1
    fi
}

function git-find-merge {
    git rev-list $1..$2 --ancestry-path | grep --color=auto -f <(git rev-list $1..$2 --first-parent --merges) | tail -1
}

function i {
    cd /var/www/vhosts/iatsSites/$1;
}

function mkcd {
    mkdir -p $1;
    cd $1
}

function ppgrep {
    pgrep "$@" | xargs -r ps fp
}

function pschilds {
    local name;
    for name in $*;
    do
        ps auxf | grep -v grep | grep --color=auto -A 8 $name;
    done
}

function psgrep {
    local name;
    for name in $*;
    do
        ps ax | grep -v grep | grep --color=auto $name;
    done
}

function pskill {
    local pid name;
    for name in $*;
    do
        pid=$(ps ax | grep $name | grep -v grep | awk '{ print $1 }' | tr "\n" " " );
        echo -n "killing $name (process $pid)...";
        kill -9 $pid;
        echo "killed.";
    done
}

function _repodir {
    local cur prev;
    COMPREPLY=();
    _get_comp_words_by_ref cur prev;
    [ $COMP_CWORD -gt 2 ] && return 0;
    if [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=($( compgen -W '`ls -p $REPODIR/$prev/ | grep / | sed "s|/||"`' -- "$cur" ));
    else
        [ -d "$REPODIR" ] && COMPREPLY=($( compgen -W '`ls -p $REPODIR | grep / | sed "s|/||"`' -- "$cur" ));
    fi;
    return 0
}
complete -F _repodir g


function revagrant {
    vagrant destroy -f "$1" && vagrant up "$1" | tee "$1-up.log" ; notify-send "VAGRANT FINISHED"
}

function reprovision {
    vagrant provision "$1" | tee "$1-provision.log" ; notify-send "VAGRANT FINISHED"
}


function ç {
    fc -s $(history | sort -nr | peco | awk '{print $1}')
}
