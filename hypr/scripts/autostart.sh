#!/bin/sh

# This script is launched on every hyprland startup
# Please note that it is intended for desktop related programs ONLY, as it will be called every time you reload the desktop
# If you want to add your own applications you may rather want to use exec-once in the environment.conf file

hyprpaper &
hyprpm reload &
albert &
swaync &
systemctl --user start hyprpolkitagent &
~/.config/hypr/scripts/restore-waybar.sh
