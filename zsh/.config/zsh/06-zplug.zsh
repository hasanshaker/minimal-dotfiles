#!/usr/bin/env zsh
# ~/.config/zsh/06-zplug.zsh
# https://github.com/zplug/zplug

# Ensure zplug is installed
if [[ ! -d "$ZPLUG_HOME" ]]; then
    if $(ping -q -w1 -c1 google.com &>/dev/null);then
        git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
        source "$ZPLUG_HOME/init.zsh" && zplug --self-manage
    fi
else
    source "$ZPLUG_HOME/init.zsh"
fi

# zplug basics:
# - `zplug status` to see if packages are up to date
# - `zplug update` to update packages
# - `zplug list` to see currently managed packages
# - `zplug clean` to clear out now unmanaged packages
# - `zplug 'owner/repo'` to use a plugin from https://github.com/$owner/$repo
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
# "zsh-syntax-highlighting" Fish shell-like syntax highlighting for Zsh.
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# zsh-history-substring-search
# This is a clean-room implementation of the Fish shell's history search
# feature, where you can type in any part of any command from history and
# then press chosen keys, such as the UP and DOWN arrows, to cycle through
# matches.
# (defer:3 means history-substring search gets loaded after syntax-highlighting)
zplug 'zsh-users/zsh-history-substring-search', defer:3 # (like fish)

# Fish-like autosuggestions for zsh
# depth: The number of commits to include in the cloned repository.
# 0 means the whole history.
zplug 'zsh-users/zsh-completions', depth:1 # more completions

# bunch of git aliases, see https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git
zplug 'plugins/git', from:oh-my-zsh

# Automatically fetches all changes from all remotes while you are
# working in git-initialized directory.
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-auto-fetch
zplug 'plugins/git-auto-fetch', from:oh-my-zsh
export GIT_AUTO_FETCH_INTERVAL=1200 #in seconds

# https://jeffkreeftmeijer.com/git-flow/
# only do 'zplug' if git-flow installed
# https://github.com/petervanderdoes/gitflow-avh#installing-git-flow
if [ -f /usr/local/bin/git-flow ];then
    # adds completion for the git-flow (AVH Edition).
    # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-flow-avh
    zplug 'plugins/git-flow-avh', from:oh-my-zsh
fi

# http://datasift.github.io/gitflow/index.html
# only do 'zplug' if git-hf installed
if [ -f /usr/local/bin/git-hf ];then
    # adds completion for HubFlow (GitFlow for GitHub), as well as some aliases for common commands
    # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-hubflow
    zplug 'plugins/git-hubflow', from:oh-my-zsh
fi

# https://github.com/github/hub#installation
if [ "$(command -v hub 2>/dev/null)" ] ||
       [ "$(command -v github 2>/dev/null)" ];then
    # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/github
    # # supports working with GitHub from the command line
    zplug 'plugins/github', from:oh-my-zsh
fi

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gnu-utils
# Load if "if" tag returns true
zplug 'plugins/gnu-utils', from:oh-my-zsh, if:"[[ $DISTRO == FreeBSD ]]"

# completion for the Rust build tool cargo.
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/cargo
zplug 'plugins/cargo', from:oh-my-zsh

# adds colors to man pages.
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages
zplug 'plugins/colored-man-pages', from:oh-my-zsh

# helpful shortcut aliases for many commonly used commands.
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/common-aliases
zplug 'plugins/common-aliases', from:oh-my-zsh

# automatically starts fbterm if on a real TTY (/dev/tty*).
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fbterm
zplug 'plugins/fbterm', from:oh-my-zsh

# Load theme file
zplug 'dracula/zsh', as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    if $(ping -q -w1 -c1 google.com &>/dev/null);then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
