export EDITOR='/usr/bin/emacsclient --alternate-editor /usr/bin/emacs'
if test -f ~/.domainname; then
    export EMAIL=juanleon.lahoz@$(cat ~/.domainname)
fi

PATH=/home/juanleon/bin/git/bin:/home/juanleon/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/lightdm/lightdm:/home/juanleon/.local/bin
GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=34:fn=35:ln=32:bn=32:se=36"

if test -e /usr/local/bin/virtualenvwrapper.sh; then
    export WORKON_HOME=~/.envs
    source /usr/local/bin/virtualenvwrapper.sh
fi


REPODIR=/home/juanleon/www
