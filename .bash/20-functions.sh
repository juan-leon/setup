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
    if [[ ! "$1" =~ ^- ]]; then
        if test "$TERM" = "screen-256color"; then
            tmux rename-window "#[bg=green]$1"
        fi
    fi
    /usr/bin/ssh "$@"
    cd .
}

function d_ssh {
    if test "$TERM" = "screen-256color"; then
        tmux rename-window "#[bg=green]$1"
    fi
    docker exec -ti $1 bash
}

function g {
    if [ -d $REPODIR/$1/$2 ]; then
        cd $REPODIR/$1/$2
    else
        cd $REPODIR/$1
    fi
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
