#!/bin/sh
# ~/.config/profile.d/05-common_apps.sh
# Variables for common *nix apps

# elinks
# move elinks config directory
if [ "$(command -v elinks 2>/dev/null)" ]; then
    if [ ! -d "${XDG_CONFIG_HOME}/elinks" ]; then
        if [ -d "${HOME}/.elinks" ]; then
            mv "${HOME}/.elinks" "${XDG_CONFIG_HOME}/elinks"
        else
            mkdir -p "${XDG_CONFIG_HOME}/elinks"
        fi
    fi
    export ELINKS_CONFDIR="${XDG_CONFIG_HOME}/elinks"
fi

# screen
if [ "$(command -v screen 2>/dev/null)" ]; then
    if [ ! -d "${XDG_CONFIG_HOME}/screen" ]; then
        if [ -d "${HOME}/.screen" ]; then
            mv "${HOME}/.screen" "${XDG_CONFIG_HOME}/screen"
        else
            mkdir -p "${XDG_CONFIG_HOME}/screen"
        fi
    fi
    export SCREENDIR="${XDG_CONFIG_HOME}/screen"
    chmod 700 "${SCREENDIR}"
    export SCREENRC="${SCREENDIR}/config"
fi

# nano
# see https://nano-editor.org
if [ "$(command -v nano 2>/dev/null)" ]; then
    if [ ! -d "${XDG_CONFIG_HOME}/nano" ]; then
        mkdir -p "${XDG_CONFIG_HOME}/nano"
        if [ -f "${HOME}/.nanorc" ]; then
            mv "${HOME}/.nanorc" "${XDG_CONFIG_HOME}/nanorc"
        fi
    else
        if [ -f "${HOME}/.nanorc" ]; then
            mv "${HOME}/.nanorc" "${XDG_HOME_CONFIG}/nanorc.bak"
        fi
    fi
    # backups
    mkdir -p "${XDG_CONFIG_HOME}/nano/backups"
fi

# ccache
if [ "$(command -v ccache 2>/dev/null)" ]; then
    if [ -d "/usr/lib/ccache/bin" ]; then
        if [ "${SHELL}" != "/bin/sh" ]; then
          pathprepend /usr/lib/ccache/bin
        else
          export PATH=/usr/lib/ccache/bin:"${PATH}"
        fi
    fi
    case "${DISTRO}" in
        "gentoo")
            [ -d /var/cache/ccache ] &&
                export CCACHE_DIR="/var/cache/ccache"
            ;;
    esac
fi

# ruby
if [ "$(command -v ruby 2>/dev/null)" ];then
    export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

# node
if [ "$(command -v npm 2>/dev/null)" ];then
    export PATH="$HOME/.node_modules/bin:$PATH"
    export npm_config_prefix=~/.node_modules
fi

if [ -d "$HOME/.cargo/bin" ];then
    export PATH=$HOME/.cargo/bin:$PATH
fi

# https://wiki.postmarketos.org/wiki/Installing_pmbootstrap
if [ "$(command -v register-python-argcomplete)" ];then
    eval "$(register-python-argcomplete pmbootstrap)"
fi

# ssh-askpass
# https://wiki.archlinux.org/index.php/SSH_keys#Calling_x11-ssh-askpass_with_ssh-add
if [ -f /usr/lib/ssh/x11-ssh-askpass ] && [ ! -L ~/.local/bin/ssh-askpass ];then
    ln -sv /usr/lib/ssh/x11-ssh-askpass ~/.local/bin/ssh-askpass
fi

# Necessary directories
if [ ! -d ~/.config/mpd/playlists ];then
    mkdir -p ~/.config/mpd/playlists
fi
if [ ! -d ~/Music/.lyrics ];then
    mkdir -p ~/Music/.lyrics
fi
if [ ! -d ~/Pictures/Screenshots ];then
    mkdir -p ~/Pictures/Screenshots
fi

# mpd's systemd unit file
# check if the global unit file exist
if [ -f /usr/lib/systemd/user/mpd.service ];then
    MPD_SYSTEM_UNIT_FILE=/usr/lib/systemd/user/mpd.service
elif [ -f /lib/systemd/user/mpd.service ];then
    MPD_SYSTEM_UNIT_FILE=/lib/systemd/user/mpd.service
fi
mkdir -p "${HOME}"/.config/systemd/user/default.target.wants
MPD_USER_UNIT_FILE="${HOME}/.config/systemd/user/default.target.wants/mpd.service"
if [ "${MPD_SYSTEM_UNIT_FILE}" ];then
    if [ ! -L  "${MPD_USER_UNIT_FILE}" ];then
        ln -s "${MPD_SYSTEM_UNIT_FILE}" "${MPD_USER_UNIT_FILE}"
    fi
fi
unset MPD_SYSTEM_UNIT_FILE MPD_USER_UNIT_FILE

# flexget systemd unit file
if [ -f /usr/lib/systemd/user/flexget.service ];then
    FLEXGET_SYSTEM_UNIT_FILE=/usr/lib/systemd/user/flexget.service
elif [ -f /lib/systemd/user/flexget.service ];then
    FLEXGET_SYSTEM_UNIT_FILE=/lib/systemd/user/flexget.service
fi
mkdir -p "$HOME/.config/systemd/user/default.target.wants"
FLEXGET_USER_UNIT_FILE="${HOME}/.config/systemd/user/default.target.wants/flexget.service"
if [ "${FLEXGET_SYSTEM_UNIT_FILE}" ];then
    if [ ! -L  "${FLEXGET_USER_UNIT_FILE}" ];then
        ln -s "${FLEXGET_SYSTEM_UNIT_FILE}" "${FLEXGET_USER_UNIT_FILE}"
    fi
fi
unset FLEXGET_SYSTEM_UNIT_FILE FLEXGET_USER_UNIT_FILE

# dirmngr systemd unit file
if [ -f /usr/lib/systemd/user/dirmngr.socket ];then
    DIRMNGR_SYSTEM_UNIT_FILE=/usr/lib/systemd/user/dirmngr.socket
elif [ -f /lib/systemd/user/dirmngr.socket ];then
    DIRMNGR_SYSTEM_UNIT_FILE=/lib/systemd/user/dirmngr.socket
fi
DIRMNGR_USER_UNIT_FILE="${HOME}/.config/systemd/user/sockets.target.wants/dirmngr.socket"
mkdir -p "${HOME}/.config/systemd/user/sockets.target.wants"
if [ "${DIRMNGR_SYSTEM_UNIT_FILE}" ];then
    if [ ! -L  "${DIRMNGR_USER_UNIT_FILE}" ];then
        ln -s "${DIRMNGR_SYSTEM_UNIT_FILE}" "${DIRMNGR_USER_UNIT_FILE}"
    fi
fi
unset DIRMNGR_SYSTEM_UNIT_FILE DIRMNGR_USER_UNIT_FILE
