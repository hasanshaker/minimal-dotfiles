# ~/.config/profile.d/90-defaults.sh
# set default environment variables if not already exists,
# these variables can be override 

# editors
[ -z "${ALTERNATE_EDITORS}" ] && export ALTERNATE_EDITOR="emacsclient -t"
[ -z "${EDITOR}" ] && export EDITOR="emacsclient -c"
[ -z "${VISUAL}" ] && export VISUAL="emacsclient -c"

# from https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
[ -z "${GPG_TTY}" ] && export GPG_TTY="$(tty)"

# https://wiki.gentoo.org/wiki/GnuPG#Automatically_starting_the_GPG_agent
if [[ -n "$SSH_CONNECTION" ]] ;then
    export PINENTRY_USER_DATA="USE_CURSES=1"
fi

# Terminal apps
# prioritize xterm above others
if [ $(command -v xterm 2>/dev/null) ];then
    export TERMINAL="xterm"
elif [ $(command -v urxvt 2>/dev/null) ];then
    export TERMINAL="urxvt"
elif [ $(command -v gnome-terminal 2>/dev/null) ];then
    export TERMINAL="gnome-terminal"
fi

# Browser
if [ $(command -v brave-bin 2>/dev/null) ];then
    # brave browser
    # https://brave.com
    export BROWSER="brave-bin"
elif
    [ $(command -v brave 2>/dev/null) ];then
    # brave browser
    # https://brave.com
    export BROWSER="brave"
elif [ $(command -v firefox 2>/dev/null) ];then
    # firefox
    export BROWSER="firefox"
else
    export BROWSER="elinks"
fi

# file manager
[ -z "$FILE" ] && export FILE="diredfm"

# Window Manager
# set priority of wm's if more than 1 is available
if [ $(command -v openbox-session) ];then
    export _WM=openbox
elif [ $(command -v i3) ];then
    export _WM=i3
fi

