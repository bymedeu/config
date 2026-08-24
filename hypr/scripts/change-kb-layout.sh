#!/bin/sh

status_file="$HOME/.config/hypr/status/kb_layout"
hyprland_cfg_file="$HOME/.config/hypr/hyprland.conf"


fr_to_en() {
    printf "en" > "${status_file}"

    hyprctl notify 1 2000 0 "Keyboard set to QWERTY"

    sed -i 's/kb_layouts\/fr/kb_layouts\/us/g' "$hyprland_cfg_file"
}

en_to_fr() {
    printf "fr" > "${status_file}"

    hyprctl notify 1 2000 0 "Keyboard set to AZERTY"

    sed -i 's/kb_layouts\/us/kb_layouts\/fr/g' "$hyprland_cfg_file"
}

if ! [ -f "${status_file}" ]; then
    hyprctl notify 3 3000 0 "Status file missing"
    hyprctl notify 2 6000 0 "Use Mod + Ctrl + Space to change keyboard layout"
    en_to_fr
else
    if [ $(cat "${status_file}") = "fr" ]; then
        fr_to_en
    elif [ $(cat "${status_file}") = "en" ]; then
        en_to_fr
    fi
fi
