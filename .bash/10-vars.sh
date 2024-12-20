export EDITOR='emacs.emacsclient --alternate-editor emacs'
if test -f ~/.domainname; then
    declare -x EMAIL
    EMAIL="juanleon.lahoz@$(cat ~/.domainname)"
fi

PATH=/home/juanleon/bin:/snap/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/juanleon/.local/bin:/usr/local/go/bin/
GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=34:fn=35:ln=32:bn=32:se=36"

REPODIR=/home/juanleon/www
export DEBFULLNAME=juanleon
export DEBEMAIL=$EMAIL

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# eval $(ssh-agent)

# snap/alacritty sets a weird XDG_CACHE_HOME
export XDG_CACHE_HOME=/home/juanleon/.cache
export PEX_ROOT=/home/juanleon/.cache/pex
export TS_WORK_ON_ALL_REPOS=true
# export NODE_OPTIONS=--no-experimental-fetch
