#!/usr/bin/env bash
# install packages

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
        sudo pacman -Sqq ${package_list}
        if ! $(command -v yay 2>/dev/null);then
            _install_yay
        fi
        ;;
esac
