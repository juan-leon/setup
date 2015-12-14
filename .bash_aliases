alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dc='cd'
alias down='http_proxy="http://localhost:3129/" wget -S -x --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:22.0) Gecko/20130328 Firefox/22.0"'
alias downc='http_proxy="http://localhost:3129/" wget -S -x --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:22.0) Gecko/20130328 Firefox/22.0" --header="Accept-Encoding: gzip"'
alias downp='http_proxy="http://10.0.3.151:3129" wget -S -x'
alias downt='http_proxy="http://localhost:3129/" wget -S -x'
alias e='emacsclient --alternate-editor /usr/bin/emacs'
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
alias revagrant='vagrant destroy -f && vagrant up | tee up.log ; notify-send "VAGRANT FINISHED"'

export EDITOR='/usr/bin/emacsclient --alternate-editor /usr/bin/emacs'
export EMAIL=juanleon.lahoz@gmail.com

PATH=/home/juanleon/bin/git/bin:"$PATH"
PS1='\[\e[01;30m\][\[\e[00m\e[35m\]\w\[\e[00m\e[01;30m\]]\[\e[00m\]: '


REPODIR=/home/juanleon/www

cd ()
{
    builtin cd "$@" && printf '\033k%s\033\\' `git rev-parse --show-toplevel 2>/dev/null | rev | cut -d/ -f-1 | rev | grep [a-zA-Z]  || basename "$PWD"`
}

g ()
{
    if [ -d $REPODIR/$1/$2 ]; then
        cd $REPODIR/$1/$2;
    else
        cd $REPODIR/$1;
    fi
}

git-find-merge ()
{
    git rev-list $1..$2 --ancestry-path | grep --color=auto -f <(git rev-list $1..$2 --first-parent --merges) | tail -1
}

gob ()
{
    select branch in $(git branch | awk -F ' +' '! /\(no branch\)/ {print $2}');
    do
        git checkout ${branch:=HEAD};
        git submodule update;
        break;
    done
}

i ()
{
    local instance_dir=/var/www/vhosts/iatsSites;
    local instance=${1:-/};
    cd $instance_dir/$1
}

mkcd ()
{
    mkdir -p $1;
    cd $1
}

ppgrep ()
{
    pgrep "$@" | xargs -r ps fp
}

pschilds ()
{
    local name;
    for name in $*;
    do
        ps auxf | grep --color=auto -v grep | grep --color=auto -A 8 $name;
    done
}

psgrep ()
{
    local name;
    for name in $*;
    do
        ps ax | grep --color=auto $name | grep --color=auto -v grep;
    done
}

pskill ()
{
    local pid name;
    for name in $*;
    do
        pid=$(ps ax | grep $name | grep -v grep | awk '{ print $1 }' | tr "\n" " " );
        echo -n "killing $name (process $pid)...";
        kill -9 $pid;
        echo "killed.";
    done
}

_repodir ()
{
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
