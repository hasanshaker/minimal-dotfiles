# ~/.config/profile.d/05-common_apps.sh
# Variables for common *nix apps

# elinks
# move elinks config directory
if test -n "$(command -v elinks)"; then
    if test ! -d "$XDG_CONFIG_HOME/elinks"; then
        if test -d "$HOME/.elinks"; then
            mv $HOME/.elinks $XDG_CONFIG_HOME/elinks
        else
            mkdir -p $XDG_CONFIG_HOME/elinks
        fi
    fi
    export ELINKS_CONFDIR=$XDG_CONFIG_HOME/elinks
fi

# screen
if test -n "$(command -v screen)"; then
    if test ! -d "$XDG_CONFIG_HOME/screen"; then
        if test -d "$HOME/.screen"; then
            mv $HOME/.screen $XDG_CONFIG_HOME/screen
        else
            mkdir -p $XDG_CONFIG_HOME/screen
        fi
    fi
    export SCREENDIR=$XDG_CONFIG_HOME/screen
    chmod 700 $SCREENDIR
    export SCREENRC=$SCREENDIR/config
fi

# nano
# see https://nano-editor.org
if test -n "$(command -v nano)"; then
    if test ! -d "$XDG_CONFIG_HOME/nano"; then
        mkdir -p $XDG_CONFIG_HOME/nano
        if test -f "$HOME/.nanorc"; then
            mv $HOME/.nanorc $XDG_CONFIG_HOME/nanorc
        fi
    else
        if test -f "$HOME/.nanorc"; then
            mv $HOME/.nanorc $XDG_HOME_CONFIG/nanorc.bak
        fi
    fi
    # 
    mkdir -p $XDG_CONFIG_HOME/nano/backups
fi

# ccache
if test -n "$(command -v ccache)"; then
    if test -d "/usr/lib/ccache"; then
        pathprepend /usr/lib/ccache
    fi
fi

if [ -d "$HOME/.node" ];then
    PATH=$(ruby -e 'print Gem.user_dir')/bin:$HOME/.node_modules/bin:$PATH
    export npm_config_prefix=$HOME/.node_modules
    export GEM_HOME=$HOME/.gem
fi

if [ -d "$HOME/.cargo/bin" ];then
    export PATH=$HOME/.cargo/bin:$PATH
fi

# ssh-askpass
# https://wiki.archlinux.org/index.php/SSH_keys#Calling_x11-ssh-askpass_with_ssh-add
if [ -f /usr/lib/ssh/x11-ssh-askpass ];then
    ln -sv /usr/lib/ssh/x11-ssh-askpass ~/.local/bin/ssh-askpass
fi
