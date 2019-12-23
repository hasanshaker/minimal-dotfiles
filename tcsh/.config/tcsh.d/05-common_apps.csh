#!/usr/bin/env tcsh
# ~/.config/tcsh.d/05-common_apps.sh
# Variables for common *nix apps

# elinks
# move elinks config directory
if ( `where elinks` != "" ) then
    if ( ! -d "${XDG_CONFIG_HOME}/elinks" ) then
        if ( -d "${HOME}/.elinks" ) then
            mv "${HOME}/.elinks" "${XDG_CONFIG_HOME}/elinks"
        else
            mkdir -p "${XDG_CONFIG_HOME}/elinks"
        endif
    endif
    setenv ELINKS_CONFDIR "${XDG_CONFIG_HOME}/elinks"
endif

# screen
if ( `where screen` != "" ) then
    if ( ! -d "${XDG_CONFIG_HOME}/screen" ) then
        if ( -d "${HOME}/.screen" ) then
            mv "${HOME}/.screen" "${XDG_CONFIG_HOME}/screen"
        else
            mkdir -p "${XDG_CONFIG_HOME}/screen"
        endif
    endif
    setenv SCREENDIR "${XDG_CONFIG_HOME}/screen"
    chmod 700 "${SCREENDIR}"
    setenv SCREENRC "${SCREENDIR}/config"
endif

# nano
# see https://nano-editor.org
if ( `where nano` != "" ) then
    if ( ! -d "${XDG_CONFIG_HOME}/nano" ) then
        mkdir -p "${XDG_CONFIG_HOME}/nano"
        if ( -f "${HOME}/.nanorc" ) then
            mv "${HOME}/.nanorc" "${XDG_CONFIG_HOME}/nanorc"
        endif
    else
        if ( -f "${HOME}/.nanorc" ) then
            mv "${HOME}/.nanorc" "${XDG_HOME_CONFIG}/nanorc.bak"
        endif
    endif
    # backups
    mkdir -p "${XDG_CONFIG_HOME}/nano/backups"
endif

# ccache
if ( `where ccache` != "" ) then
    if ( -d "/usr/lib/ccache/bin" ) then
        if ( "${SHELL}" != "/bin/sh" ) then
          pathprepend /usr/lib/ccache/bin
        else
          setenv PATH /usr/lib/ccache/bin:"${PATH}"
        endif
    endif
    switch (${DISTRO})
    case "gentoo":
            [ -d /var/cache/ccache ] &&
                setenv CCACHE_DIR "/var/cache/ccache"
            breaksw
    endsw
endif

# ruby
if ( `where ruby` != "" ) then
    setenv PATH "`ruby -e 'print Gem.user_dir'`/bin:${PATH}"
endif

# node
if ( `where npm` != "") then
    setenv PATH "$HOME/.node_modules/bin:$PATH"
    setenv npm_config_prefix ~/.node_modules
endif

if ( -d "$HOME/.cargo/bin" ) then
    setenv PATH $HOME/.cargo/bin:$PATH
endif

# https://wiki.postmarketos.org/wiki/Installing_pmbootstrap
if ( `where register-python-argcomplete` != "" ) then
    eval "$(register-python-argcomplete pmbootstrap)"
endif

# ssh-askpass
# https://wiki.archlinux.org/index.php/SSH_keys#Calling_x11-ssh-askpass_with_ssh-add
if ( -f /usr/lib/ssh/x11-ssh-askpass ) then
    ln -sf /usr/lib/ssh/x11-ssh-askpass ~/.local/bin/ssh-askpass
endif

# Necessary directories
if ( ! -d ~/.config/mpd/playlists ) then
    mkdir -p ~/.config/mpd/playlists
endif
if ( ! -d ~/Music/.lyrics ) then
    mkdir -p ~/Music/.lyrics
endif
if ( ! -d ~/Pictures/Screenshots ) then
    mkdir -p ~/Pictures/Screenshots
endif

# mpd's systemd unit file
# check if the global unit file exist
if ( `where systemd` != "") then
if ( -f /usr/lib/systemd/user/mpd.service ) then
    setenv MPD_SYSTEM_UNIT_FILE /usr/lib/systemd/user/mpd.service
else if ( -f /lib/systemd/user/mpd.service ) then
    setenv MPD_SYSTEM_UNIT_FILE /lib/systemd/user/mpd.service
endif
mkdir -p "${HOME}"/.config/systemd/user/default.target.wants
setenv MPD_USER_UNIT_FILE "${HOME}/.config/systemd/user/default.target.wants/mpd.service"
if ( "${MPD_SYSTEM_UNIT_FILE}" ) then
    if ( ! -L "${MPD_USER_UNIT_FILE}" ) then
        ln -s "${MPD_SYSTEM_UNIT_FILE}" "${MPD_USER_UNIT_FILE}"
    endif
endif

# flexget systemd unit file
if ( -f /usr/lib/systemd/user/flexget.service ) then
    setenv FLEXGET_SYSTEM_UNIT_FILE /usr/lib/systemd/user/flexget.service
else if ( -f /lib/systemd/user/flexget.service ) then
    setenv FLEXGET_SYSTEM_UNIT_FILE /lib/systemd/user/flexget.service
endif
mkdir -p "$HOME/.config/systemd/user/default.target.wants"
setenv FLEXGET_USER_UNIT_FILE "${HOME}/.config/systemd/user/default.target.wants/flexget.service"
if ( "${FLEXGET_SYSTEM_UNIT_FILE}" ) then
    if ( ! -L  "${FLEXGET_USER_UNIT_FILE}" ) then
        ln -s "${FLEXGET_SYSTEM_UNIT_FILE}" "${FLEXGET_USER_UNIT_FILE}"
    endif
endif

# dirmngr systemd unit file
if ( -f /usr/lib/systemd/user/dirmngr.socket ) then
    setenv DIRMNGR_SYSTEM_UNIT_FILE /usr/lib/systemd/user/dirmngr.socket
else if ( -f /lib/systemd/user/dirmngr.socket ) then
    setenv DIRMNGR_SYSTEM_UNIT_FILE /lib/systemd/user/dirmngr.socket
endif
setenv DIRMNGR_USER_UNIT_FILE "${HOME}/.config/systemd/user/sockets.target.wants/dirmngr.socket"
mkdir -p "${HOME}/.config/systemd/user/sockets.target.wants"
if ( "${DIRMNGR_SYSTEM_UNIT_FILE}" ) then
    if ( ! -L  "${DIRMNGR_USER_UNIT_FILE}" ) then
        ln -s "${DIRMNGR_SYSTEM_UNIT_FILE}" "${DIRMNGR_USER_UNIT_FILE}"
    endif
endif
endif
