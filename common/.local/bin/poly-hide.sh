#!/bin/sh
# Check if xdo is installed
xdo_path=$(which xdo)
if [ $? -ne 0 ]; then
    echo "Cannot find \`xdo\` command."
    exit 1
fi
# Obtain bar's window id
ids=( $(xdo id -N "Polybar") )
# Toggle bar visibility
for id in ${ids[*]};do
    if xprop -id $id | grep -q "Normal"; then
        xdo hide $id
    else
        #xdo show $id
        ~/.local/bin/polybar-${DISTRO:-common}-top &
    fi
done
