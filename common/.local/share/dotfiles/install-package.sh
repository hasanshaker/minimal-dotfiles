#!/usr/bin/env bash
# install packages
set -e

function _install_yay (){
    printf "installing yay\n"
    mkdir -p ~/.cache/aur
    git clone https://aur.archlinux.org/yay.git ~/.cache/aur/yay
    cd ~/.cache/aur/yay
    makepkg -si
    cd -
}

if [ -z ${package_list} ];then
    . ~/.local/share/dotfiles/packages.sh
fi

case ${DISTRO} in
    "arch")
        # possible conflicts
        if [ $(pacman -Qq | grep "^vim$") ];then
            printf "we'll replace vim with gvim\n"
            sudo pacman -R --noconfirm vim 2>/dev/null
        fi
        sudo pacman -Sqq --noconfirm --needed ${package_list}
        if ! $(command -v yay 2>/dev/null);then
            _install_yay
        fi
        # install aur_list
        yay -Sqq --needed --noconfirm --pacman "--needed --noconfirm" ${aur_list} 2>/dev/null
        ;;
    "FreeBSD")
        sudo pkg install ${package_list}
        ;;
esac

# install hubflow
# https://github.com/datasift/gitflow
if [ ! -f /usr/local/bin/git-hf ];then
    git clone git@github.com:datasift/gitflow.git ~/.local/share/gitflow
    sudo sh ~/.local/share/gitflow/install.sh
fi
