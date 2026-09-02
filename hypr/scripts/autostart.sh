#!/bin/sh

# This script is launched once at the start of each Hyprland session.
# It is intended for desktop-related programs only.
# If you want to add your own applications, prefer the hyprland.start handler
# in config/environment.lua.

hyprpaper &
hyprpm reload &
albert &
swaync &
systemctl --user start hyprpolkitagent &
~/.config/hypr/scripts/restore-waybar.sh
