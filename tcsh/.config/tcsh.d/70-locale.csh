#!/usr/bin/env tcsh
# ~/.config/tcsh.d/70-locale.sh
# set locale if not defined

[ -z "${LANG}" ] && setenv LANG en_US.UTF-8
[ -z "${MM_CHARSET}" ] && setenv MM_CHARSET en_US.UTF-8
