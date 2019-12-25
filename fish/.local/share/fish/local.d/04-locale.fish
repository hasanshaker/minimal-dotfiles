#!/usr/bin/env fish
# ~/.local/share/fish/local.d/04-locale.fish
# set locale if not defined

[ -z "$LANG" ] && set --global --export LANG en_US.UTF-8
[ -z "$MM_CHARSET" ] && set --global --export MM_CHARSET en_US.UTF-8
