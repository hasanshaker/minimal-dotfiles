#!/usr/bin/env tcsh
# ~/.config/tcsh.d/03-distro.csh
# set distro environment

# set DISTRO and DISTROVER
if ( -f /etc/os-release ) then
    # freedesktop.org and systemd
    source /etc/os-release
    setenv DISTRO "${ID}"
    setenv DISTROVER "${VERSION_ID}"
else if ( `command -v lsb_release >/dev/null` ) then
    # linuxbase.org
    setenv DISTRO "`lsb_release -si`"
    setenv DISTROVER "`lsb_release -sr`"
else if ( -f /etc/lsb-release ) then
    # For some versions of Debian/Ubuntu without lsb_release command
    source /etc/lsb-release
    setenv DISTRO "${DISTRIB_ID}"
    setenv DISTROVER "${DISTRIB_RELEASE}"
else if ( -f /etc/debian_version ) then
    # Older Debian/Ubuntu/etc.
    setenv DISTRO Debian
    setenv DISTROVER "`cat /etc/debian_version`"
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    setenv DISTRO "`uname -s`"
    setenv DISTROVER "`uname -r`"
endif
