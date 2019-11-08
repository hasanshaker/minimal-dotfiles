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

if [[ -z "$XDG_RUNTIME_DIR" ]]; then
    case $DISTRO in
        gentoo)
            export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
            if [[ ! -d $XDG_RUNTIME_DIR ]];then
                mkdir -p $XDG_RUNTIME_DIR
                chmod 0700 $XDG_RUNTIME_DIR
            fi
            ;;
        *)
            export XDG_RUNTIME_DIR="/run/user/$(id -u)"
            if [[ ! -d $XDG_RUNTIME_DIR ]];then
                mkdir -p $XDG_RUNTIME_DIR
                chmod 0700 $XDG_RUNTIME_DIR
            fi
    esac
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

# XDG User Directories
# https://wiki.archlinux.org/index.php/XDG_user_directories
[ -z $XDG_DESKTOP_DIR ] && export XDG_DESKTOP_DIR="$HOME/Desktop"
[ -z $XDG_DOWNLOAD_DIR ] && export XDG_DOWNLOAD_DIR="$HOME/Downloads"
[ -z $XDG_TEMPLATES_DIR ] && export XDG_TEMPLATES_DIR="$HOME/Templates"
[ -z $XDG_PUBLICSHARE_DIR ] && export XDG_PUBLICSHARE_DIR="$HOME/Public"
[ -z $XDG_DOCUMENTS_DIR ] && export XDG_DOCUMENTS_DIR="$HOME/Documents"
[ -z $XDG_MUSIC_DIR ] && export XDG_MUSIC_DIR="$HOME/Music"
[ -z $XDG_PICTURES_DIR ] && export XDG_PICTURES_DIR="$HOME/Pictures"
[ -z $XDG_VIDEOS_DIR ] && export XDG_VIDEOS_DIR="$HOME/Videos"

for dir in $XDG_DESKTOP_DIR $XDG_DOWNLOAD_DIR $XDG_TEMPLATES_DIR \
                            $XDG_PUBLICSHARE_DIR $XDG_DOCUMENTS_DIR $XDG_MUSIC_DIR \
                            $XDG_PICTURES_DIR $XDG_VIDEOS_DIR;do
    if [ ! -d $dir ] || [ ! -L $dir ];then
        mkdir -p $dir 2>/dev/null
    fi
done
unset dir

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS
