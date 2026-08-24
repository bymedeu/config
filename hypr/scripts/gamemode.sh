#!/usr/bin/env sh

# From Hyprland documentation - https://wiki.hyprland.org/0.41.2/Configuring/Uncommon-tips--tricks/#toggle-animationsbluretc-hotkey

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    killall waybar
    hyprctl notify 1 2000 0 "Enabled game mode"
    exit
fi 

hyprctl reload
~/.config/hypr/scripts/restore-waybar.sh
hyprctl notify 1 2000 0 "Disabled game mode"
