#!/usr/bin/env zsh
# ~/.zprofile
# Initial setup file for only interactive zsh.
# This file is read after .zshenv file is read befere .zshrc when you login.
# Not read in for subsequent shells.
# For setting up terminal and global environment characteristics.

# source ~/.profile
if [ -f ~/.profile ];then
    emulate sh -c 'source ${HOME}/.profile'
fi

# Terminal background color settings
# http://yskwkzhr.blogspot.jp/2012/12/set-background-color-of-vim-with-environment-variable.html
# Default dark
export COLORFGBG='15;0'
if [ -n "${(M)ITERM_PROFILE#light}" ]; then
  export COLORFGBG='0;15'
elif [ -n "${(M)COLORTERM#gnome-terminal}" ]; then
  export COLORFGBG='0;15'
fi
