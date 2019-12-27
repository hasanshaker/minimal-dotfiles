#!/usr/bin/env fish
# ~/.local/share/fish/local.d/03-common_apps.fish
# Variables for common *nix apps

# elinks
# move links config directory
if command --quiet --search elinks
    if [ -d "$HOME/.elinks" ]
        mv "$HOME/.elinks" "$XDG_CONFIG_HOME/elinks"
    else
        mkdir -p "$XDG_CONFIG_HOME/elinks"
    end
    set --global --export ELINKS_CONFDIR "$XDG_CONFIG_HOME/elinks"
end

# screen
if command --quiet --search screen
    if [ ! -d "$XDG_CONFIG_HOME/screen" ]
        if [ -d "$HOME/.screen" ]
            mv "$HOME/.screen" "$XDG_CONFIG_HOME/screen"
        else
            mkdir -p "$XDG_CONFIG_HOME/screen"
        end
    end
    set --global --export SCREENDIR "$XDG_CONFIG_HOME/screen"
    chmod 700 "$SCREENDIR"
    set --global --export SCREENRC "$SCREENDIR/config"
end

# nano
# see https://nano-editor.org
if command --search --quiet nano then
    if  [ ! -d "$XDG_CONFIG_HOME/nano" ]
        mkdir -p "$XDG_CONFIG_HOME/nano"
        if [ -f "$HOME/.nanorc" ]
            mv "$HOME/.nanorc" "$XDG_CONFIG_HOME/nanorc"
        end
    else
        if [ -f "$HOME/.nanorc" ]
            mv "$HOME/.nanorc" "$XDG_HOME_CONFIG/nanorc.bak"
        end
    end
    # backups
    mkdir -p "$XDG_CONFIG_HOME/nano/backups"
end
# ccache
if command --search --quiet ccache
    if [ -d "/usr/lib/ccache/bin" ]
        set --global --export PATH /usr/lib/ccache/bin "$PATH"
    end
    switch $DISTRO
        case gentoo
            if [ -d /var/cache/ccache ]
                set --global --export CCACHE_DIR "/var/cache/ccache"
            end
    end
end

# ruby
if command --search --quiet ruby
    set --global --export PATH "(ruby -e 'print Gem.user_dir')/bin" "$PATH"
end

# node
if command --search --quiet npm
    set --global --export PATH "$HOME/.node_modules/bin" "$PATH"
    set --global --export npm_config_prefix ~/.node_modules
end

if [ -d "$HOME/.cargo/bin" ]
    set --global --export PATH "$HOME/.cargo/bin" "$PATH"
end

# https://wiki.postmarketos.org/wiki/Installing_pmbootstrap
if command --search --quiet register-python-argcomplete
    eval (register-python-argcomplete pmbootstrap)
end

# ssh-askpass
# https://wiki.archlinux.org/index.php/SSH_keys#Calling_x11-ssh-askpass_with_ssh-add
if [ -f /usr/lib/ssh/x11-ssh-askpass ]
    ln -sf /usr/lib/ssh/x11-ssh-askpass ~/.local/bin/ssh-askpass
end

# Necessary directories
if [ ! -d ~/.config/mpd/playlists ]
    mkdir -p ~/.config/mpd/playlists
end
if [ ! -d ~/Music/.lyrics ]
    mkdir -p ~/Music/.lyrics
end
if [ ! -d ~/Pictures/Screenshots ]
    mkdir -p ~/Pictures/Screenshots
end

# mpd's systemd unit file
# check if the global unit file exist
if command --search --quiet systemd
    if [ -f /usr/lib/systemd/user/mpd.service ]
        set --local MPD_SYSTEM_UNIT_FILE /usr/lib/systemd/user/mpd.service
    else if [ -f /lib/systemd/user/mpd.service ]
        set --local MPD_SYSTEM_UNIT_FILE /lib/systemd/user/mpd.service
    end
    mkdir -p "$HOME"/.config/systemd/user/default.target.wants
    set --local MPD_USER_UNIT_FILE "$HOME/.config/systemd/user/default.target.wants/mpd.service"
    if [ "$MPD_SYSTEM_UNIT_FILE" ]
        if [ ! -L "$MPD_USER_UNIT_FILE" ]
            ln -s "$MPD_SYSTEM_UNIT_FILE" "$MPD_USER_UNIT_FILE"
        end
    end

    # flexget systemd unit file
    if [ -f /usr/lib/systemd/user/flexget.service ]
        set --local FLEXGET_SYSTEM_UNIT_FILE /usr/lib/systemd/user/flexget.service
    else if [ -f /lib/systemd/user/flexget.service ]
        set --local FLEXGET_SYSTEM_UNIT_FILE /lib/systemd/user/flexget.service
    end
    mkdir -p "$HOME/.config/systemd/user/default.target.wants"
    set --local FLEXGET_USER_UNIT_FILE "$HOME/.config/systemd/user/default.target.wants/flexget.service"
    if [ "$FLEXGET_SYSTEM_UNIT_FILE" ]
        if [ ! -L  "$FLEXGET_USER_UNIT_FILE" ]
            ln -s "$FLEXGET_SYSTEM_UNIT_FILE" "$FLEXGET_USER_UNIT_FILE"
        end
    end

        # dirmngr systemd unit file
        if [ -f /usr/lib/systemd/user/dirmngr.socket ]
            set --local DIRMNGR_SYSTEM_UNIT_FILE /usr/lib/systemd/user/dirmngr.socket
        else if [ -f /lib/systemd/user/dirmngr.socket ]
            set --local DIRMNGR_SYSTEM_UNIT_FILE /lib/systemd/user/dirmngr.socket
        end
        set --local DIRMNGR_USER_UNIT_FILE "$HOME/.config/systemd/user/sockets.target.wants/dirmngr.socket"
        mkdir -p "$HOME/.config/systemd/user/sockets.target.wants"
        if [ "$DIRMNGR_SYSTEM_UNIT_FILE" ]
            if [ ! -L  "$DIRMNGR_USER_UNIT_FILE" ]
                ln -s "$DIRMNGR_SYSTEM_UNIT_FILE" "$DIRMNGR_USER_UNIT_FILE"
            end
        end
end

# extrapaths
if [ -d "$HOME/.local/bin" ]
    set --global --export PATH "$HOME/.local/bin/" "$PATH"
end

# doom emacs bin
if [ -d "HOME/.emacs.d/bin" ]
    set --global --export PATH "$HOME/.emacs.d/bin/" "$PATH"
end
