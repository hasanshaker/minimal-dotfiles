#!/usr/bin/env tcsh
# ~/.config/tcsh.d/02-xdg_base_directory.csh
# XDG Base Directory specification
# https://wiki.archlinux.org/index.php/XDG_BASE_Directory_support

if  (! "$?XDG_CONFIG_HOME" ) then
    if ( -d "${HOME}/.config" ) then
            mkdir -p "${HOME}/.config"
    endif
    setenv XDG_CONFIG_HOME "${HOME}/.config"
endif

if (! "$?XDG_CACHE_HOME" ) then
    if ( -d "${HOME}/.cache" ) then
        mkdir -p "${HOME}/.cache"
    endif
    setenv XDG_CACHE_HOME "${HOME}/.cache"
endif

if (! "$?XDG_DATA_HOME" ) then
    if ( -d "${HOME}/.local/share" ) then
        mkdir -p "${HOME}/.local/share"
    endif
    setenv XDG_DATA_HOME "${HOME}/.local/share"
endif

if (! "$?XDG_RUNTIME_DIR" ) then
    switch ("${DISTRO}")
    case "gentoo":
            setenv XDG_RUNTIME_DIR "/tmp/${UID}-runtime-dir"
            if ( ! -d "${XDG_RUNTIME_DIR}" ) then
                mkdir -p "${XDG_RUNTIME_DIR}"
                chmod 0700 "${XDG_RUNTIME_DIR}"
            endif
            breaksw
    case "arch":
            setenv XDG_RUNTIME_DIR "/run/user/`id -u`"
            if ( ! -d "${XDG_RUNTIME_DIR}" ) then
                mkdir -p "${XDG_RUNTIME_DIR}"
                chmod 0700 "${XDG_RUNTIME_DIR}"
            endif
            breaksw
    case "FreeBSD":
            setenv XDG_RUNTIME_DIR "/tmp/`id -u`-runtime-dir"
            if ( ! -d "${XDG_RUNTIME_DIR}" ) then
                mkdir -p "${XDG_RUNTIME_DIR}"
                chmod 0700 "${XDG_RUNTIME_DIR}"
            endif
            breaksw
    endsw
endif

if (! "$?DBUS_SESSION_BUS_ADDRESS" ) then
    setenv DBUS_SESSION_BUS_ADDRESS "unix:path=${XDG_RUNTIME_DIR}/bus"
endif

# XDG User Directories
# https://wiki.archlinux.org/index.php/XDG_user_directories
[ "$?XDG_DESKTOP_DIR" ] && setenv XDG_DESKTOP_DIR "${HOME}/Desktop"
[ "$?XDG_DOWNLOAD_DIR" ] && setenv XDG_DOWNLOAD_DIR "${HOME}/Downloads"
[ "$?XDG_TEMPLATES_DIR" ] && setenv XDG_TEMPLATES_DIR "${HOME}/Templates"
[ "$?XDG_PUBLICSHARE_DIR" ] && setenv XDG_PUBLICSHARE_DIR "${HOME}/Public"
[ "$?XDG_DOCUMENTS_DIR" ] && setenv XDG_DOCUMENTS_DIR "${HOME}/Documents"
[ "$?XDG_MUSIC_DIR" ] && setenv XDG_MUSIC_DIR "${HOME}/Music"
[ "$?XDG_PICTURES_DIR" ] && setenv XDG_PICTURES_DIR "${HOME}/Pictures"
[ "$?XDG_VIDEOS_DIR" ] && setenv XDG_VIDEOS_DIR "${HOME}/Videos"

foreach dir ("${XDG_DESKTOP_DIR}" "${XDG_DOWNLOAD_DIR}" "${XDG_TEMPLATES_DIR}" \
                              "${XDG_PUBLICSHARE_DIR}" "${XDG_DOCUMENTS_DIR}" "${XDG_MUSIC_DIR}" \
                              "${XDG_PICTURES_DIR}" "${XDG_VIDEOS_DIR}")
    if ( ! -d "${dir}" ) then
        mkdir -p "${dir}" 2>/dev/null
    endif
end
