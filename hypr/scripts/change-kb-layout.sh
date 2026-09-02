#!/bin/sh

status_dir="$HOME/.config/hypr/status"
status_file="$status_dir/kb_layout"

mkdir -p "$status_dir"

fr_to_en() {
    printf "en" > "${status_file}"
    hyprctl notify 1 2000 0 "Keyboard set to QWERTY"
    hyprctl reload config-only
}

en_to_fr() {
    printf "fr" > "${status_file}"
    hyprctl notify 1 2000 0 "Keyboard set to AZERTY"
    hyprctl reload config-only
}

if ! [ -f "${status_file}" ]; then
    hyprctl notify 3 3000 0 "Status file missing"
    hyprctl notify 2 6000 0 "Use Mod + Ctrl + Space to change keyboard layout"
    en_to_fr
else
    if [ "$(cat "${status_file}")" = "fr" ]; then
        fr_to_en
    elif [ "$(cat "${status_file}")" = "en" ]; then
        en_to_fr
    fi
fi
