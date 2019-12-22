# Begin ~/.bash_profile
# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.  System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

[ -f /etc/profile ]         && source /etc/profile

# in the actual startup sequences, "~/.bash_profile" is invoked
# before "~/.profile" so we need to source "~/.profile" first.

[ -f $HOME/.profile ]       && source $HOME/.profile
[ -f $HOME/.bashrc ]        && source $HOME/.bashrc

case ${USER} in
    games)
        if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
            exec startx
        fi
        ;;
esac

# End ~/.bash_profile
