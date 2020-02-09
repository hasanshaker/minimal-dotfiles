#!/bin/sh
# ~/.config/profile.d/90-defaults.sh
# set default environment variables if not already exists,
# these variables can be override

# editors
[ -z "${ALTERNATE_EDITOR}" ] && export ALTERNATE_EDITOR="emacsclient -t"
[ -z "${EDITOR}" ] && export EDITOR="emacsclient --alternate-editor= -t"
[ -z "${VISUAL}" ] && export VISUAL="emacsclient -c"

# from https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
[ -z "${GPG_TTY}" ] && export GPG_TTY="$(tty)"

# https://wiki.gentoo.org/wiki/GnuPG#Automatically_starting_the_GPG_agent
if [ -n "$SSH_CONNECTION" ] ;then
    export PINENTRY_USER_DATA="USE_CURSES=1"
fi

# gpg-agent FreeBSD
case "${DISTRO}" in
    FreeBSD)
        if [ ! "$(pgrep -x gpg-agent)" ];then
            /usr/local/bin/gpg-agent --enable-ssh-support \
                                     --pinentry-program /usr/local/bin/pinentry \
                                     --daemon "$@"
            if [ -f "${HOME}/.gpg-agent-info" ];then
                . "${HOME}/.gpg-agent-info"
                export GPG_AGENT_INFO SSH_AUTH_SOCK
            fi
        fi
        ;;
    *)
        # append pinentry-program since its location varied for each distro
        gpg-agent --pinentry-program $(command -v pinentry)
        ;;
esac

# keychain
# https://wiki.gentoo.org/wiki/Keychain
if [ "$(command -v keychain)" ];then
    [ -z "${HOSTNAME}" ] && HOSTNAME="$(uname -n)"
    keychain --quiet --agents "gpg,ssh"
    [ -f "${HOME}/.keychain/${HOSTNAME}-sh" ] && \
        . "${HOME}/.keychain/${HOSTNAME}-sh"
    [ -f "${HOME}/.keychain/${HOSTNAME}-sh-gpg" ] && \
        . "${HOME}/.keychain/${HOSTNAME}-sh-gpg"
fi

# Terminal apps
# prioritize xterm above others
if [ "$(command -v xterm 2>/dev/null)" ];then
    export TERMINAL="xterm"
elif [ "$(command -v urxvt 2>/dev/null)" ];then
    export TERMINAL="urxvt"
elif [ "$(command -v gnome-terminal 2>/dev/null)" ];then
    export TERMINAL="gnome-terminal"
fi

# Browser
if [ "$(command -v brave-bin 2>/dev/null)" ];then
    # brave browser
    # https://brave.com
    export BROWSER="brave-bin"
elif
    [ "$(command -v brave 2>/dev/null)" ];then
    # brave browser
    # https://brave.com
    export BROWSER="brave"
elif [ "$(command -v firefox 2>/dev/null)" ];then
    # firefox
    export BROWSER="firefox"
elif [ "$(command -v chromium 2>/dev/null)" ];then
    export BROWSER="chromium"
else
    export BROWSER="elinks"
fi

# file manager
[ -z "$FILE" ] && export FILE="diredfm"

# Window Manager
# set priority of wm's if more than 1 is available, 'games' user
# set to mate
case ${USER} in
    games)
        export _WM=mate
        ;;
    *)
        if [ "$(command -v openbox-session 2>/dev/null)" ];then
            export _WM=openbox
        elif [ "$(command -v i3 2>/dev/null)" ];then
            export _WM=i3
        elif [ "$(command -v mate-session 2>/dev/null)" ];then
            export _WM=mate
        elif [ "$(command -v awesome 2>/dev/null)" ];then
            export _WM=awesome
        fi
        ;;
esac

export WLAN_IFACE="$(ifconfig|awk '/^wl*/{print $1}'|sed 's/\://')"

ETH1="$(ifconfig|awk '/^enp*/{print $1}'|sed 's/\://')"
ETH2="$(ifconfig|awk '/^eth*/{print $1}'|sed 's/\://')"
if [ -n "${ETH1}" ];then
    export ETH_IFACE="${ETH1}"
elif [ -n "${ETH2}" ];then
    export ETH_IFACE="${ETH2}"
fi
unset ETH1 ETH2

case "$TERM" in
"dumb")
    export PS1="> "
    ;;
esac

# org-directory
if [ -z ${ORG_DIR} ];then
    # use my default
    [ ! -d "${HOME}/Projects/org-mode" ] &&
        mkdir -p ${HOME}/Projects/org-mode
fi

#
if [ $(command -v dbus-update-activation-environment) ] &&
       [ $(command -v systemctl) ];then
    dbus-update-activation-environment --systemd --all
fi
