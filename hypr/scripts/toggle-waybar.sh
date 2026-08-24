#!/bin/sh

pidof waybar # Check if waybar is running

if [ $? = 0 ]; then 
    # If running, stop it 
    killall waybar & echo "off" > ~/.config/hypr/status/waybar
else 
    # Else, run it
    waybar & echo "on" > ~/.config/hypr/status/waybar
fi
