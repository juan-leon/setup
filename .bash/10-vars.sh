export EDITOR='/usr/bin/emacsclient --alternate-editor /usr/bin/emacs'
if test -f ~/.domainname; then
    declare -x EMAIL
    EMAIL="juanleon.lahoz@$(cat ~/.domainname)"
fi

PATH=/home/juanleon/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/juanleon/.local/bin
GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=34:fn=35:ln=32:bn=32:se=36"

if test -e /usr/share/virtualenvwrapper/virtualenvwrapper.sh; then
    export WORKON_HOME=~/.envs
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

REPODIR=/home/juanleon/www
export DEBFULLNAME=juanleon
export DEBEMAIL=$EMAIL

# eval $(ssh-agent)
