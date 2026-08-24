#!/bin/sh

# Launch waybar depending on the last status
waybar_status=~/.config/hypr/status/waybar
if [ "$(cat $waybar_status)" == "on" ]; then
    killall waybar
    waybar &
elif [ "$(cat $waybar_status)" != "off" ]; then
    hyprctl notify 0 3000 0 Failed to retrieve waybar status
fi
