#!/bin/sh

if [ $(whoami) != root ]; then
    echo "Please run this script as root"
    echo "-> sudo $0"
    echo
    sudo $0
    exit $?
fi

apps_path=/usr/share/applications

rm $apps_path/codium.desktop
sed -i "s/Name=VSCodium - Wayland/Name=VSCodium/g" $apps_path/codium-wayland.desktop

echo "- Done"
exit 0
