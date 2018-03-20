# Auto-completion & Key bindings
if [[ $- == *i* ]] && test "$TERM" != "dumb" && command -v fzf &>/dev/null; then
    source "/home/juanleon/.fzf/shell/completion.bash" 2> /dev/null
    source "/home/juanleon/.fzf/shell/key-bindings.bash"
    export FZF_COMPLETION_TRIGGER='**'
    export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

function is_in_git_repo {
  git rev-parse HEAD &>/dev/null
}

function fzf-up {
  fzf-tmux -u 60% "$@"
}

# Mod files
function gf {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-up -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -100' |
  cut -c4- | sed 's/.* -> //'
}

# Branches
function gb {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-up --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

# Tags
function gt {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-up --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

# Log
function gh {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-up --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

function egf {
    $EDITOR $(gf)
}

function ee {
    file="$(fd --type f "$@" | fzf-up)"
    if test -n "$file"; then
        $EDITOR "$file"
    fi
}

function r {
    local candidate=${1:-}
    local query=''
    if test -n "$candidate"; then
        query="--query $candidate"
    fi
    cd ~/www
    cd $(FZF_DEFAULT_COMMAND='fd --type d -d 1' fzf-up -1 $query)
}

alias g=r

if test "$TERM" != dumb; then
    bind '"\C-g\C-f": "$(gf)\e\C-e"'
    bind '"\C-g\C-b": "$(gb)\e\C-e"'
    bind '"\C-g\C-h": "$(gh)\e\C-e"'
    bind '"\C-g\C-t": "$(gt)\e\C-e"'
fi

fi
