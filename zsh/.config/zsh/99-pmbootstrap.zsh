#!/usr/bin/env zsh
# ~/.config/zsh/99-pmbootstrap.zsh
# pmbootstrap zsh tab completion
# https://wiki.postmarketos.org/wiki/Installing_pmbootstrap

#autoload bashcompinit
#bashcompinit
if (( $+command[register-python-argcomplete] )) then
   eval "$(register-python-argcomplete pmbootstrap)"
fi
