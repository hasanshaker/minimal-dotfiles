#!/usr/bin/env zsh
#  initial setup file for both interactive and noninteractive zsh
#
# Read config sequence (except /etc/*)
#
#  login shell
#    $ZDOTDIR/.zshenv
#    $ZDOTDIR/.zprofile
#    $ZDOTDIR/.zshrc
#    $ZDOTDIRA/.zlogin
#
#  interactive zsh
#    $ZDOTDIR/.zshenv
#    $ZDOTDIR/.zshrc
#
#  shell scripts
#    $ZDOTDIR/.zshenv
#
#  remoteley noninteractive zsh (e.x ssh hostname command)
#    $ZDOTDIR/.zshenv
#
#  logout:
#    $ZDOTDIR/.zlogout
#    /etc/zlogout
# This file needs to be also sourceable from a POSIX shell.

if [ -z "$ZSH_VERSION" ]; then
    eval $(zsh -c 'typeset -gpx PATH')
    return
fi

# Setup ZDOTDIR.
# The directory to search for shell startup files (.zshrc, etc).
# If ZDOTDIR is unset, HOME is used instead.
#
#ZDOTDIR=$HOME/.config/zsh
ZSH=$HOME/.config/zsh

# Keep only the first occurrence of each duplicated value.
typeset -U path

# Compute a PATH without duplicates. This could have been done with
# "typeset -aU" but this some paths are equal, like /usr/bin and /bin
# in some cases.
() {
    local -a wanted savedpath
    local p
    wanted=(/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
            /usr/local/games /usr/games)
    savedpath=($path)
    path=()
    for p in $savedpath; do
    (( ${${wanted[(r)$p]}:+1} )) || (( ${${path[(r)${p:A}]}:+1} )) || {
        [ -d ${p:A} ] && path=($path $p)
    }
    done
    for p in $wanted; do
    (( ${${path[(r)${p:A}]}:+1} )) || {
        [ -d ${p:A} ] && path=($path $p)
    }
    done

    export PATH
}

# Maximum size of a core dump.
# Limit coredump.
limit coredumpsize 0
