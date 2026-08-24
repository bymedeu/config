#!/bin/sh

device=znt0001:00-14e5:650e-touchpad
toggle_variable="device[${device}]:enabled"

hyprctl keyword "${toggle_variable}" true

status_file="$HOME/.config/hypr/status/touchpad"

enable_touchpad() {
  printf "on" > "${status_file}"

  hyprctl notify 1 2000 0 "Enabled touchpad"

  hyprctl keyword "${toggle_variable}" true
}

disable_touchpad() {
  printf "off" > "${status_file}"

  hyprctl notify 0 2000 0 "Disabled Touchpad"

  hyprctl keyword "${toggle_variable}" false
}

if ! [ -f "${status_file}" ]; then
  hyprctl notify 3 3000 0 "Status file missing"
  enable_touchpad
else
  if [ $(cat "${status_file}") = "on" ]; then
    disable_touchpad
  elif [ $(cat "${status_file}") = "off" ]; then
    enable_touchpad
  fi
fi
