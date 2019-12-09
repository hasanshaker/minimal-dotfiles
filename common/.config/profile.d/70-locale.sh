#!/bin/sh
# ~/.config/profile.d/70-locale.sh
# set locale if not defined

[ -z "${LANG}" ] && LANG=en_US.UTF-8
[ -z "${MM_CHARSET}" ] && MM_CHARSET=en_US.UTF-8

export LANG MM_CHARSET
