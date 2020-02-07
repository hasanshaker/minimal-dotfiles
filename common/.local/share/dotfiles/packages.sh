#!/usr/bin/env sh
# list of packages needed by this dotfiles
# TODO: avoid metapackages

case ${DISTRO} in
    "arch")
        package_list="dmenu elinks emacs feh firefox gnupg i3-gaps i3lock \
            i3status keychain htop lsof strace rofi screen stow \
            sxhkd gvim x11-ssh-askpass xorg-xinit xterm ffmpeg mpv \
            youtube-dl awesome noto-fonts-emoji mpd mpc dunst libnotify \
            xorg-xwininfo xorg-fonts arandr calcurse compton xorg-xprop sxiv \
            ncmpcpp alsa-utils maim socat unclutter unrar unzip xclip xdotool \
            xorg-xdpyinfo zathura zathura-pdf-mupdf poppler mediainfo atool highlight \
            pavucontrol byzanz transmission-cli ttf-font-awesome texlive-most"
        aur-list="ts polybar transmission-remote-cli-git screenkey-git"
        ;;
esac
