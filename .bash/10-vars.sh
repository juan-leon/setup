export EDITOR='/usr/bin/emacsclient --alternate-editor /usr/bin/emacs'
if test -f ~/.domainname; then
    declare -x EMAIL
    EMAIL="juanleon.lahoz@$(cat ~/.domainname)"
fi

PATH=/home/juanleon/bin:/snap/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/juanleon/.local/bin:/usr/local/go/bin/
GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=34:fn=35:ln=32:bn=32:se=36"

if test -e /usr/share/virtualenvwrapper/virtualenvwrapper.sh; then
    export WORKON_HOME=~/.envs
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

REPODIR=/home/juanleon/www
export DEBFULLNAME=juanleon
export DEBEMAIL=$EMAIL

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# eval $(ssh-agent)

export PEX_ROOT=/home/juanleon/.cache/pex
export TS_WORK_ON_ALL_REPOS=true
export NODE_OPTIONS=--no-experimental-fetch
