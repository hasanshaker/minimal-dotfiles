#!/bin/sh

function run(){
    if [ ! "$(pgrep -f $1)" ];then
        "$@"&
    fi
}

[ -n "$(command -v compton)" ] &&
    run compton -b --config ${HOME}/.config/compton/compton.conf
