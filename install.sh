#!/bin/bash

# Let people know that we're destroying everything they hold dear
set -x

# Spacemacs
rm -rf $HOME/.emacs.d
rm $HOME/.spacemacs
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
ln -s $PWD/$(dirname $0)/.spacemacs $HOME/.spacemacs

# Bash Prompt
rm ~/.bashrc
ln -s $PWD/$(dirname $0)/.bashrc $HOME/.bashrc

# ... And that's it.
