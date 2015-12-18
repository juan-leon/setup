#!/bin/bash -eu

readonly FILES="
  .bash_aliases
  .gitconfig
  .gitignore.global
  .screenrc
  .tmux.conf
  .multitailrc
  bin/bt
  bin/wm.py
  .emacs.d/init.el
  .emacs.d/init-loader
  .emacs.d/packages
"

if test "$(git rev-parse --show-toplevel)" != $(pwd); then
    echo This command has to be executed from top level repo directory.
    exit 1
fi

for file in $FILES; do
    rm -rf $file
    cp -r $HOME/$file $file
done

