#!/usr/bin/env bash
# ~/.config/bash.d/common-apps.bash

# https://wiki.postmarketos.org/wiki/Installing_pmbootstrap
if [ "$(command -v register-python-argcomplete)" ];then
    eval "$(register-python-argcomplete pmbootstrap)"
fi
