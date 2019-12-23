#!/usr/bin/env tcsh
# ~/.config/tcsh.d/03-distro.csh
# set distro environment

# set DISTRO and DISTROVER
if ( -f /etc/os-release ) then
    # freedesktop.org and systemd
    setenv DISTRO `gawk '/^ID/{print substr($0,index($0,"=")+1)}' /etc/os-release`
    setenv DISTROVER `gawk '/^VERSION_ID/{print substr($0,index($0,"=")+1)}' /etc/os-release`
else if ( `command -v lsb_release >/dev/null` ) then
    # linuxbase.org
    setenv DISTRO "`lsb_release -si`"
    setenv DISTROVER "`lsb_release -sr`"
else if ( -f /etc/lsb-release ) then
    setenv DISTRO `gawk '/^DISTRIB_ID/{print substr($0,index($0,"=")+1)}' /etc/lsb-release`
    setenv DISTROVER `gawk '/^DISTRIB_RELEASE/{print substr($0,index($0,"=")+1)}' /etc/lsb-release`
else if ( -f /etc/debian_version ) then
    # Older Debian/Ubuntu/etc.
    setenv DISTRO Debian
    setenv DISTROVER "`cat /etc/debian_version`"
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    setenv DISTRO "`uname -s`"
    setenv DISTROVER "`uname -r`"
endif
