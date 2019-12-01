# ~/.config/profile.d/03-distro.sh
# set distro environment

# set DISTRO and DISTROVER
if test -f /etc/os-release; then
    # freedesktop.org and systemd
    . /etc/os-release
    DISTRO="$ID"
    DISTROVER="$VERSION_ID"
elif test lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    DISTRO="$(lsb_release -si)"
    DISTROVER="$(lsb_release -sr)"
elif test -f /etc/lsb-release; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    DISTRO="$DISTRIB_ID"
    DISTROVER="$DISTRIB_RELEASE"
elif test -f /etc/debian_version; then
    # Older Debian/Ubuntu/etc.
    DISTRO=Debian
    DISTROVER="$(cat /etc/debian_version)"
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    DISTRO="$(uname -s)"
    DISTROVER="$(uname -r)"
fi

export DISTRO DISTROVER
