#!/usr/bin/env fish
# ~/.local/share/fish/local.d/04-locale.fish
# set locale if not defined

if [ -z "$LANG" ]
    if [ -n "$XDG_CONFIG_HOME"  -a -r "$XDG_CONFIG_HOME/locale.conf" ]
        set --global --export LANG (gawk '/^LANG/{print substr($0,index($0,"=")+1)}' "$XDG_CONFIG_HOME/locale.conf")
    else if [ -n "$HOME" -a -r "$HOME/.config/locale.conf" ]
        set --global --export LANG (gawk '/^LANG/{print substr($0,index($0,"=")+1)}' "$HOME/.config/locale.conf")
    else if [ -r /etc/locale.conf ]
        set --global --export LANG (gawk '/^LANG/{print substr($0,index($0,"=")+1)}' "/etc/locale.conf")
    end
end
set --query LANG; or set --global --export LANG "C"

[ -z "$MM_CHARSET" ] && set --global --export MM_CHARSET en_US.UTF-8
