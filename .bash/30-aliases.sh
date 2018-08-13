# Mispelling I like to make
alias dc='cd'

alias e='emacsclient --alternate-editor /usr/bin/emacs'
alias eb='emacsclient -n --alternate-editor /usr/bin/emacs'
alias emacs='emacs -mm'

alias l='ls -CF'
alias la='ls -A'
alias lrt='ls -lrt'
alias lrtt='ls -lrt | tail'

alias s='git status'
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
