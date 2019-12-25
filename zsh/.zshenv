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

# language settings (read in /etc/environment before /etc/default/locale as
# the latter one is the default on Debian nowadays)
# no xsource() here because it's only created in zshrc! (which is good)
[[ -r /etc/environment ]] && source /etc/environment

# set environment variables (important for autologin on tty)
export HOSTNAME=${HOSTNAME:-$(hostname)}

# make sure /usr/bin/id is available
if [[ -x /usr/bin/id ]] ; then
    [[ -z "$USER" ]]          && export USER=$(/usr/bin/id -un)
    [[ $LOGNAME == LOGIN ]] && LOGNAME=$(/usr/bin/id -un)
fi

# workaround for live-cd mode as $HOME is not set via rungetty
if [[ -f /etc/grml_cd ]] ; then
    if (( EUID == 0 )); then
        export HOME=/root
    else
        export HOME=/home/$USER
    fi
fi

# less (:=pager) options:
#  export LESS=C
typeset -a lp; lp=( ${^path}/lesspipe(N) )
if (( $#lp > 0 )) && [[ -x $lp[1] ]] ; then
    export LESSOPEN="|lesspipe %s"
elif [[ -x /usr/bin/lesspipe.sh ]] ; then
    export LESSOPEN="|lesspipe.sh %s"
fi
unset lp

export READNULLCMD=${PAGER:-/usr/bin/pager}

# allow zeroconf for distcc
export DISTCC_HOSTS="+zeroconf"

# MAKEDEV should be usable on udev as well by default:
export WRITE_ON_UDEV=yes
