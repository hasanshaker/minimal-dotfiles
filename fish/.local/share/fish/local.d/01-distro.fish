#!/usr/bin/env fish
# ~/.local/share/fish/local.d/01-distro.fish
# set distro environment

if [ -f /etc/os-release ]
    # freedesktop.org and systemd
    set --export --global DISTRO (gawk '/^ID/{print substr($0,index($0,"=")+1)}' /etc/os-release)
    set --export --global DISTROVER (gawk '/^VERSION_ID/{print substr($0,index($0,"=")+1)}' /etc/os-release)
else if command --quiet --search lsb_release
    # linuxbase.org
    set --export --global DISTRO (lsb_release -si)
    set --export --global DISTROVER (lsb_release -sr)
else if [ -f /etc/lsb-release ]
    set --export --global DISTRO (gawk '/^DISTRIB_ID/{print substr($0,index($0,"=")+1)}' /etc/lsb-release)
    set --export --global DISTROVER (gawk '/^DISTRIB_RELEASE/{print substr($0,index($0,"=")+1)}' /etc/lsb-release)
else if [ -f /etc/debian_version ]
    # Older Debian/Ubuntu/etc.
    set --export --global DISTRO Debian
    set --export --global DISTROVER (cat /etc/debian_version)
else
    set --export --global DISTRO (uname -s)
    set --export --global DISTROVER (uname -r)
end
