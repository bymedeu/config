#!/bin/sh

if [ $(whoami) != root ]; then
    echo "Please run this script as root"
    echo "-> sudo $0"
    echo
    sudo $0
    exit $?
fi

apps_path=/usr/share/applications

rm $apps_path/avahi-discover.desktop
rm $apps_path/bvnc.desktop
rm $apps_path/bssh.desktop

echo "- Done"
exit 0
