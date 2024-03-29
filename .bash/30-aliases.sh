# Mispelling I like to make
alias dc='cd'

alias e='emacsclient --alternate-editor /usr/bin/emacs'
alias eb='emacsclient -n --alternate-editor /usr/bin/emacs'
alias emacs='emacs -mm'
alias magit='emacsclient -nw -e \(magit-status\)'

alias l='ls -CF'
alias la='ls -A'
alias lrt='ls -lrt'
alias lrtt='ls -lrt --color | tail'

alias s='git status -sb'
alias gls='git --no-pager ls -6; echo'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias setgrep='set | grep'

alias iats='cd ~/www/iats/code'
alias jscore='cd $HOME/www/iats/code/jscore'
alias phpcore='cd $HOME/www/iats/code/jscore/phpcore'
alias wire-log='multitail -n 500 -cS wire /var/log/wire/wire.log'
alias wlog='multitail -n 500 -CS wire'

alias ssh=r_ssh

export EXA_COLORS="uu=0;36"
alias ll='exa -l'
alias lrt='exa -lsnew'
alias lrtt='exa -lsnew --color=always | tail'

alias tz='TZ_LIST="America/Argentina/Buenos_Aires;ARG,UTC" tz -q'

alias switch='TS_WORK_ON_ALL_REPOS=true ts switch'
