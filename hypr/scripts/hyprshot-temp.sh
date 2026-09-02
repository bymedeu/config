#!/usr/bin/env bash

set -euo pipefail

temp_dir="/tmp/hyprshot-${UID}"
latest_screenshot="${temp_dir}/latest.png"

notify() {
    notify-send --app-name=Hyprshot "$1" "$2"
}

if [[ "${1:-}" == "--save" ]]; then
    if [[ ! -f "${latest_screenshot}" ]]; then
        notify "Screenshot not saved" "Take a screenshot with Win+Shift+S first."
        exit 1
    fi

    pictures_dir="$(xdg-user-dir PICTURES)"
    mkdir -p "${pictures_dir}"

    saved_screenshot="${pictures_dir}/hyprshot-$(date +'%Y-%m-%d-%H%M%S-%N').png"
    cp -- "${latest_screenshot}" "${saved_screenshot}"
    notify "Screenshot saved" "${saved_screenshot}"
    exit 0
fi

mkdir -p "${temp_dir}"
chmod 700 "${temp_dir}"
exec hyprshot -m region -o "${temp_dir}" -f "$(basename "${latest_screenshot}")"
