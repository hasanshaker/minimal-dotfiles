# Begin ~/.bashrc
# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f "/etc/bashrc" ] ; then
    source /etc/bashrc
elif [ -f "/etc/bash.bashrc" ]; then
    source /etc/bash.bashrc
fi

# setup directory for everything bash-related
BASH_DIR=$XDG_CONFIG_HOME/bash.d
BASH_DATA=$XDG_DATA_HOME/bash

[ ! -d $BASH_DIR ] && mkdir -p $BASH_DIR
[ ! -d $BASH_DATA ] && mkdir -p $BASH_DATA

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# $BASH_DIR/bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f "$BASH_DIR/bash_aliases" ]; then
    . $BASH_DIR/bash_aliases
fi

if [[ -z "$BASH_COMPLETION_VERSINFO" ]];then
    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    elif [ -f /usr/share/bash_completion/bash_completion ] && ! shopt -oq posix; then
        . /usr/share/bash_completion/bash_completion
    elif [ -f /usr/local/share/bash_completion/bash_completion ] && ! shopt -oq posix; then
        . /usr/local/share/bash_completion/bash_completion
    fi
fi

# user completion files
if [ -d "$BASH_DIR/bash_completion.d" ]; then
  for i in $BASH_DIR/bash_completion.d/*.bash; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

# color prompt, this is gentoo bashrc file
[[ -f "$BASH_DIR/colors.bash" ]] && . $BASH_DIR/colors.bash

# history
if [ -f "$BASH_DIR/history.bash" ]; then
    . $BASH_DIR/history.bash
fi

# End ~/.bashrc
