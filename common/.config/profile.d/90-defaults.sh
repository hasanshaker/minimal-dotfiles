# ~/.config/profile.d/90-defaults.sh
# set default environment variables if not already exists,
# these variables can be override 

# editors
[ -z "${ALTERNATE_EDITORS}" ] && export ALTERNATE_EDITOR="emacsclient -t"
[ -z "${EDITOR}" ] && export EDITOR="emacsclient -c"
[ -z "${VISUAL}" ] && export VISUAL="emacsclient -c"

# from https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
[ -z "${GPG_TTY}" ] && export GPG_TTY="$(tty)"
