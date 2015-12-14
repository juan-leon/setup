#!/bin/bash -eu

readonly FILES="
  .bash_aliases
  .gitconfig
  .gitignore.global
  .screenrc
  .tmux.conf
  bin/bt
  bin/wm.py
  .emacs.d/init.el
  .emacs.d/init-loader
  .emacs.d/packages
"

for file in $FILES; do
    cp -r $HOME/$file $file
done

