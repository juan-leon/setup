PS1='\[\033[01;30m\][\[\033[00m\]\[\033[35m\]\w\[\033[00m\]\[\033[01;30m\]]\[\033[00m\]: '

export EMAIL="juanleon.lahoz@gmail.com"
export EDITOR='/usr/bin/emacsclient --alternate-editor /usr/bin/emacs'

psgrep()
{
  local name
  for name in $* ; do 
    ps ax | grep $name | grep -v grep
  done
}

pskill()
{
  local pid name
  for name in $* ; do 
    pid=$(ps ax | grep $name | grep -v grep | awk '{ print $1 }' | tr "\n" " " )
    echo -n "killing $name (process $pid)..."
    kill -9 $pid
    echo "killed."
  done
}

alias setgrep="set | grep"

alias lrt='ls -lrt'
alias emacs='emacs -mm'
alias e='emacsclient --alternate-editor /usr/bin/emacs'
alias down='http_proxy="http://localhost:3129/" wget -S -x --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:22.0) Gecko/20130328 Firefox/22.0"'
alias downc='http_proxy="http://localhost:3129/" wget -S -x --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:22.0) Gecko/20130328 Firefox/22.0" --header="Accept-Encoding: gzip"'
alias downt='http_proxy="http://localhost:3129/" wget -S -x'
alias downp='http_proxy="http://10.0.3.151:3129" wget -S -x'
alias screen='screen "-e^Xx"'
#alias sssh='screen ssh'
alias arc=/home/juanleon/bin/arcanist/arcanist/bin/arc
alias iats='g iats code'

mkcd()
{
  mkdir -p $1
  cd $1
}



function cd() { builtin cd "$@" && printf '\033k%s\033\\' `git rev-parse --show-toplevel 2>/dev/null | rev | cut -d/ -f-1 | rev | grep [a-zA-Z]  || basename $PWD`; }

go() {
   select branch in $(git branch | awk -F ' +' '! /\(no branch\)/ {print $2}') ; do git checkout  ${branch:=HEAD} ; git submodule update; break ; done
}


g()
{
  if [ -d $REPODIR/$1/$2 ] ; then
    cd $REPODIR/$1/$2
  else
    cd $REPODIR/$1
  fi
}

REPODIR=~/www/

[ -d "$REPODIR" ] &&
_repodir()
{
    local cur prev

    COMPREPLY=()
    _get_comp_words_by_ref cur prev

    # don't complete past 2nd token
    [ $COMP_CWORD -gt 2 ] && return 0

    if [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $( compgen -W '`ls -p $REPODIR/$prev/ | grep / | sed "s|/||"`' -- "$cur" ) )
    else
    [ -d "$REPODIR" ] && \
        COMPREPLY=( $( compgen -W '`ls -p $REPODIR | grep / | sed "s|/||"`' -- "$cur" ) )
    fi
    return 0
} &&
complete -F _repodir g

