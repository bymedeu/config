#!/bin/sh

# Default to visible on a fresh checkout; respect an explicit toggle off.
waybar_status="$HOME/.config/hypr/status/waybar"
mkdir -p "${waybar_status%/*}"
if [ -f "$waybar_status" ] && [ "$(cat "$waybar_status")" = "off" ]; then
    exit 0
fi

# Reload existing bars so they discover the current outputs.
if pgrep -x waybar >/dev/null; then
    pkill -USR2 -x waybar
else
    nohup waybar >"${waybar_status}.log" 2>&1 &
fi
