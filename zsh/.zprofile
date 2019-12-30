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
