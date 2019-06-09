# ~/.config/profile.d/01-functions.sh

# dari /etc/profile lfs

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)

if [ -z "$(typeset -f pathremove)" ] ; then
    pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
            if [ "$DIR" != "$1" ] ; then
                NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
            fi
        done
        export $PATHVARIABLE="$NEWPATH"
    }
    [ -n "$BASH" ] && export -f pathremove
fi

if [ -z "$(typeset -f pathprepend)" ] ; then
    pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
    }
    [ -n "$BASH" ] && export -f pathprepend
fi

if [ -z "$(typeset -f pathappend)" ] ; then
    pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
    }
    [ -n "$BASH" ] && export -f pathappend
fi
