#!/usr/bin/env fish
# ~/.local/share/fish/local.d/02-xdg_base_directory.fish
# https://wiki.archlinux.org/index.php/XDG_BASE_Directory_support

if [ -z "{$XDG_CONFIG_HOME}" -a -d "{$HOME}/.config" ]
    mkdir -p "{$HOME}/.config"
end
set --global --export XDG_CONFIG_HOME "{$HOME}/.config"

if [ -z "{$XDG_CACHE_HOME}" -a -d "{$HOME}/.cache"]
    mkdir -p "{$HOME}/.cache"
end
set --global --export XDG_CACHE_HOME "{$HOME}/.cache"

if [ -z "{$XDG_DATA_HOME}" -a -d "{$HOME}/.local/share" ]
    mkdir -p "{$HOME}/.local/share"
end
set --global --export XDG_DATA_HOME "{$HOME}/.local/share"

if [ -z "{$XDG_RUNTIME_DIR}" ]
    switch $DISTRO
        case gentoo
            set --global --export XDG_RUNTIME_DIR "/tmp/(id -u)-runtime-dir"
        case arch
            set --global --export XDG_RUNTIME_DIR "/run/user/(id -u)"
        case FreeBSD
            set --global --export XDG_RUNTIME_DIR "/tmp/(id -u)-runtime-dir"
    end
    if [ ! -d $XDG_RUNTIME_DIR ]
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 0700 "$XDG_RUNTIME_DIR"
    end
end
