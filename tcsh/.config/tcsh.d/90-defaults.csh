#!/usr/bin/env tcsh
# ~/.config/tcsh.d/90-defaults.sh
# set default environment variables if not already exists,
# these variables can be override

# editors
[ "$?ALTERNATE_EDITOR" ] && setenv ALTERNATE_EDITOR "emacsclient -t"
[ "$?EDITOR" ] && setenv EDITOR "emacsclient --alternate-editor= -t"
[ "$?VISUAL" ] && setenv VISUAL "emacsclient -c"

# from https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
[ "$?GPG_TTY" ] && setenv GPG_TTY `tty`

# gpg-agent FreeBSD
switch (${DISTRO})
case FreeBSD:
        if ( ! `pgrep -x gpg-agent` ) then
            /usr/local/bin/gpg-agent --enable-ssh-support \
                                     --pinentry-program /usr/local/bin/pinentry \
                                     --daemon "$@"
        endif
        breaksw
case gentoo:
    # https://wiki.gentoo.org/wiki/GnuPG#Automatically_starting_the_GPG_agent
    if ( ! $?SSH_CONNECTION ) then
        setenv PINENTRY_USER_DATA "USE_CURSES=1"
    endif
    breaksw
endsw

# keychain
# https://wiki.gentoo.org/wiki/Keychain
if ( `where keychain` != "" ) then
    if ( ! $?HOSTNAME ) then
        setenv HOSTNAME `uname -n`
    endif
    keychain --quiet --agents "gpg,ssh"
    [ -f "${HOME}/.keychain/${HOSTNAME}-csh" ] && \
        source "${HOME}/.keychain/${HOSTNAME}-csh"
    [ -f "${HOME}/.keychain/${HOSTNAME}-csh-gpg" ] && \
        source "${HOME}/.keychain/${HOSTNAME}-csh-gpg"
endif

# Terminal apps
# prioritize xterm above others
if (! "$?TERMINAL" ) then
    if ( `where xterm` != "" ) then
        setenv TERMINAL "xterm"
    else if ( `where urxvt` != "") then
        setenv TERMINAL "urxvt"
    else if ( `where gnome-terminal` != "") then
        setenv TERMINAL "gnome-terminal"
    endif
endif

# Browser
if (! "?$BROWSER" ) then
    if ( `where brave-bin` != "" ) then
        # brave browser
        # https://brave.com
        setenv BROWSER "brave-bin"
    else if ( `where brave` != "" ) then
        # brave browser
        # https://brave.com
        setenv BROWSER "brave"
    else if ( `where firefox` != "" ) then
        # firefox
        setenv BROWSER "firefox"
    else if ( `where chromium` != "" ) then
        setenv BROWSER "chromium"
    else
        setenv BROWSER "elinks"
    endif
endif

# file manager
[ "$?FILE" ] && setenv FILE "diredfm"

# Window Manager
# set priority of wm's if more than 1 is available
if (! "$?_WM" ) then
    if ( `where openbox-session` != "" ) then
        setenv _WM openbox
    else if ( `where i3` != "" ) then
        setenv _WM i3
    else if ( `where mate-session` != "" ) then
        setenv _WM mate
    else if ( `where awesome` != "" ) then
        setenv _WM awesome
    endif
endif

setenv WLAN_IFACE `ifconfig|awk '/^wl*/{print $1}'|sed 's/\://'`

setenv ETH1 `ifconfig|awk '/^enp*/{print $1}'|sed 's/\://'`
setenv ETH2 `ifconfig|awk '/^eth*/{print $1}'|sed 's/\://'`
if ( "${ETH1}" != "" ) then
    setenv ETH_IFACE "${ETH1}"
else if ( "${ETH2}" != "" ) then
    setenv ETH_IFACE "${ETH2}"
endif
unset ETH1 ETH2
