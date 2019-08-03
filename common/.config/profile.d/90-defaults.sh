# ~/.config/profile.d/90-defaults.sh
# set default environment variables if not already exists,
# these variables can be override 

# editors
[ -z "${ALTERNATE_EDITORS}" ] && export ALTERNATE_EDITOR="emacsclient -t"
[ -z "${EDITOR}" ] && export EDITOR="emacsclient -c"
[ -z "${VISUAL}" ] && export VISUAL="emacsclient -c"

# from https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
[ -z "${GPG_TTY}" ] && export GPG_TTY="$(tty)"

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
if [ $(command -v brave 2>/dev/null) ];then
    # brave browser
    # https://brave.com
    export BROWSER="brave"
elif [ $(command -v firefox 2>/dev/null) ];then
    # firefox
    export TERMINAL="firefox"
else
    export TERMINAL="elinks"
fi

# file manager
[ -z "$FILE" ] && export FILE="emacsclient -c --eval '(dired %f)'"
