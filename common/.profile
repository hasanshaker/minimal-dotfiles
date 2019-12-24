#!/bin/sh
# ~/.profile
# Environment and startup programs.

# source /etc/profile if exist.
[ -f /etc/profile ] && . /etc/profile

# this goes first in case others needs it.
if [ -d "${HOME}/bin" ] ; then
    export PATH="${HOME}/bin:${PATH}"
fi
if [ -d "$HOME/.local/bin" ];then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

# Loads user profiles if exists. Should be in ~/.profile.d
# but let's not pollute ~ anymore.

if [ -d "${HOME}/.config/profile.d" ]; then
    for profile in "${HOME}"/.config/profile.d/*.sh; do
        . "${profile}"
    done
    unset profile
fi

if [ -n "${PATH}" ]; then
    old_PATH=${PATH}:; PATH=
    while [ -n "${old_PATH}" ]; do
        x=${old_PATH%%:*}       # the first remaining entry
        case ${PATH}: in
            *:"$x":*) ;;         # already there
            *) PATH=${PATH}:$x;;    # not there yet
        esac
        old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
fi

# if running bash
if [ -n "${BASH_VERSION}" ]; then
    # include .bashrc if it exists
    if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi

# if running zsh
if [ -n "${ZSH_VERSION}" ];then
    if [ -f "${HOME}/.zshrc" ];then
        . "${HOME}/.zshrc"
    fi
fi
