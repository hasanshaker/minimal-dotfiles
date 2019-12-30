#!/usr/bin/env zsh
################################################################################
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin
################################################################################

# all the heavy-lifting is done by zplug
() {
    for config_file ($ZSH/*.zsh) source $config_file
}
