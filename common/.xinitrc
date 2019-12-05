#!/bin/sh
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

# $DISTRO is set by "~/.profile"
if [ "$DISTRO" = "ubuntu" ]; then
    sysresources=/etc/X11/xinit/Xresources
    sysmodmap=/etc/X11/xinit/Xmodmap
else
    sysresources=/etc/X11/xinit/.Xresources
    sysmodmap=/etc/X11/xinit/.Xmodmap
fi

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

openrc_ck(){
    if [ "$(command -v openrc 2>/dev/null)" ];then
        exec ck-launch-session dbus-launch --sh-syntax --exit-with-session "$@"
    else
        exec "$@"
    fi
}

case "${_WM}" in
    "i3")
        # start i3-wm
        case "${DISTRO}" in
            "arch")
                mkdir -p "${XDG_DATA_HOME}"/i3
                exec i3 -V >> "${XDG_DATA_HOME}"/i3/i3-"$(date +%F_%H-%M-%S)"
                ;;
            "FreeBSD")
                exec i3
                ;;
            "gentoo")
                openrc_ck i3
        esac
        ;;
    "gnome")
        case "$DISTRO" in
            "arch")
                export GDK_BACKEND=x11
                exec gnome-session
                ;;
        esac
        ;;
    "openbox")
        case "${DISTRO}" in
            "gentoo")
                openrc_ck openbox-session
                ;;
            "arch")
                exec openbox-session
                ;;
        esac
        ;;
    "mate")
        exec mate-session
        ;;
esac
