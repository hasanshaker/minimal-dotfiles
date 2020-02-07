#!/usr/bin/env bash
# install packages
set -e

function _install_yay (){
    printf "installing yay\n"
    mkdir -p ~/.cache/aur
    git clone https://aur.archlinux.org/yay.git ~/.cache/aur/yay
    cd ~/.cache/aur/yay
    makepkg -si
}

case ${DISTRO} in
    "arch")
        if [ -z ${package_list} ];then
            . ~/.local/share/dotfiles/packages.sh
        fi
        # possible conflicts
        if [ $(pacman -Qq vim 2>/dev/null) ];then
            printf "we'll replace vim with gvim\n"
            sudo pacman -Rqq --noconfirm vim 2>/dev/null
        fi
        sudo pacman -Sqq --noconfirm ${package_list}
        if ! $(command -v yay 2>/dev/null);then
            _install_yay
        fi
        ;;
esac
