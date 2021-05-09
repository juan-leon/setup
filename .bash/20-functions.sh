function v_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window -t $TMUX_PANE "#[bg=yellow,fg=black]$1"
    fi
    vagrant ssh $1
    cd .
}

function l_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window -t $TMUX_PANE "#[bg=yellow,fg=black]$1"
    fi
    lxc exec $1 bash
    cd .
}

function r_ssh {
    if [[ ! "$1" =~ ^- ]]; then
        if test "$TERM" = "screen-256color"; then
            tmux rename-window -t $TMUX_PANE "#[bg=green]$1"
        fi
    fi
    /usr/bin/ssh "$@"
    cd .
}

function d_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window -t $TMUX_PANE "#[bg=green]$1"
    fi
    docker exec -ti $1 bash
}

function bail {
    tail -100f "$1" | bat -l log --paging never
}

function g {
    cd $REPODIR/$1
}

function v {
    workon $1 && cd $REPODIR/$1
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
    for name in $*; do
        ps auxf | grep -v grep | grep --color=auto -A 8 $name;
    done
}

function psgrep {
    local name;
    for name in $*; do
        ps ax | grep -v grep | grep --color=auto $name;
    done
}

function pskill {
    local pid name;
    for name in $*; do
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
    [ $COMP_CWORD -gt 1 ] && return 0;
    [ -d "$REPODIR" ] || return 0
    COMPREPLY=($( compgen -W '`ls -p $REPODIR | grep / | sed "s|/||"`' -- "$cur" ));
}
complete -F _repodir g

function _v_ {
    local cur prev;
    COMPREPLY=();
    _get_comp_words_by_ref cur prev;
    [ $COMP_CWORD -gt 1 ] && return 0;
    [ -d "$REPODIR" ] || return 0
    COMPREPLY=($( compgen -W '`ls -p $WORKON_HOME | grep / | sed "s|/||"`' -- "$cur" ));
}
complete -F _v_ v

function tiempo {
    curl wttr.in/Madrid?FQ v2.wttr.in/Madrid?F
}
