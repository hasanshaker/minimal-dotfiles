#!/usr/bin/env fish
# ~/.local/share/fish/local.d/05-defaults.fish
# set default environment variables if not already exists,
# these variables can be override

# editors
[ -z "$ALTERNATE_EDITOR" ] && set --global --export ALTERNATE_EDITOR "emacsclient -t"
[ -z "$EDITOR" ] && set --global --export EDITOR "emacsclient --alternate-editor= -t"
[ -z "$VISUAL" ] && set --global --export VISUAL "emacsclient -c"

# from https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
[ -z "$GPG_TTY" ] && set --global GPG_TTY (tty)

# gpg-agent FreeBSD
switch $DISTRO
    case FreeBSD
        if [ ! (pgrep -x gpg-agent) ]
            /usr/local/bin/gpg-agent --enable-ssh-support \
            --pinentry-program /usr/local/bin/pinentry \
            --daemon "$argv"
        end
    case gentoo
    # https://wiki.gentoo.org/wiki/GnuPG#Automatically_starting_the_GPG_agent
        if [ ! $SSH_CONNECTION ]
            set --global --export PINENTRY_USER_DATA "USE_CURSES=1"
        end
end

# keychain
# https://wiki.gentoo.org/wiki/Keychain
if command --search --quiet keychain
    if [ ! $HOSTNAME ]
        set --global --export HOSTNAME (uname -n)
    end
    keychain --quiet --agents "gpg,ssh"
    [ -f "$HOME/.keychain/$HOSTNAME-fish" ] && \
        source "$HOME/.keychain/$HOSTNAME-fish"
    [ -f "$HOME/.keychain/$HOSTNAME-fish-gpg" ] && \
        source "$HOME/.keychain/$HOSTNAME-fish-gpg"
end

# Terminal apps
# prioritize xterm above others
if command --search --quiet xterm
    set --global --export TERMINAL "xterm"
else if command --search --quiet urxvt
    set --global --export TERMINAL "urxvt"
else if command --search --quiet gnome-terminal
    set --global --export TERMINAL "gnome-terminal"
end

# Browser
if command --quiet --search brave-bin
    # brave browser
    # https://brave.com
    set --global --export BROWSER "brave-bin"
else if command --search --quiet brave
    # brave browser
    # https://brave.com
    set --global --export BROWSER "brave"
else if command --search --quiet firefox
    # firefox
    set --global --export BROWSER "firefox"
else if command --search --quiet chromium
    set --global --export BROWSER "chromium"
else
    set --global --export BROWSER "elinks"
end

# file manager
[ -z "$FILE" ] && set --global --export FILE "pcmanfm"

# Window Manager
# set priority of wm's if more than 1 is available
if command --search --quiet openbox-session
    set --global --export _WM openbox
else if command --search --quiet i3
    set --global --export _WM i3
else if command --search --quiet mate-session
    set --global --export _WM mate
else if command --search --quiet awesome
    set --global --export _WM awesome
end

set --global --export WLAN_IFACE (ifconfig|awk '/^wl*/{print $1}'|sed 's/\://')

set --local ETH1 (ifconfig|awk '/^enp*/{print $1}'|sed 's/\://')
set --local ETH2 (ifconfig|awk '/^eth*/{print $1}'|sed 's/\://')
if [ "$ETH1" ]
    set --global --export ETH_IFACE "$ETH1"
else if [ "$ETH2" ]
    set --global --export ETH_IFACE "$ETH2"
end
