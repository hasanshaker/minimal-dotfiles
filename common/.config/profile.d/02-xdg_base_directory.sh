# ~/.config/profile.d/02-xdg_base_directory.sh
# XDG Base Directory specification
# https://wiki.archlinux.org/index.php/XDG_BASE_Directory_support

# try to be more POSIX
if test -z "$XDG_CONFIG_HOME"; then
    if test -d "$HOME/.config"; then
        mkdir -p $HOME/.config
    fi
    XDG_CONFIG_HOME=$HOME/.config
fi

if test -z "$XDG_CACHE_HOME"; then
    if test -d "$HOME/.cache"; then
        mkdir -p $HOME/.cache
    fi
    XDG_CACHE_HOME=$HOME/.cache
fi

if test -z "$XDG_DATA_HOME"; then
    if test -d "$HOME/.local/share"; then
        mkdir -p $HOME/.local/share
    fi
    XDG_DATA_HOME=$HOME/.local/share
fi

if [ -z "$XDG_RUNTIME_DIR" ] || [ "$XDG_RUNTIME_DIR" != "/run/user/$(id -u)" ]; then
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
    mkdir -pv $XDG_RUNTIME_DIR
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS
