#!/bin/bash -eu

readonly FILES="
  .bash_aliases
  .gitconfig
  .gitignore.global
  .tmux.conf
  .multitailrc
  bin/bt
  bin/wm.py
  bin/test-file
  bin/pyrev
  bin/pwatch
  bin/juanleon-gitlab-utils
  bin/juanleon-keyboard
  .bash
  .emacs.d/init.el
  .emacs.d/init-loader
  .emacs.d/packages
  hacks/templates
"

if test "$(git rev-parse --show-toplevel)" != "$(pwd)"; then
    echo This command has to be executed from top level repo directory.
    exit 1
fi

readonly command=${1:-noop}

if test $command == repo; then
    for file in $FILES; do
        rm -rf $file
        cp -r $HOME/$file $file
    done
elif test $command == env; then
    mkdir -p .backup
    for file in $FILES; do
        if test -e $HOME/$file; then
            mv $HOME/$file .backup
        fi
        cp -r $file $HOME/$file
    done
else
    echo 'Wrong operation (ops are "repo" or "env")'
    exit 1
fi
