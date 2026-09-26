#!/bin/sh

keybind_list=$(mktemp --tmpdir="${XDG_RUNTIME_DIR:-/tmp}" keybinds.XXXXXX) || exit 1
trap 'rm -f "$keybind_list"' EXIT HUP INT TERM

{
    printf 'HYPRLAND KEYBINDINGS\n\n'
    hyprctl binds -j | jq -r '
    def has_modifier($value): ((.modmask / $value | floor) % 2) == 1;
    def shortcut:
        ([
            if has_modifier(64) then "Super" else empty end,
            if has_modifier(4) then "Ctrl" else empty end,
            if has_modifier(8) then "Alt" else empty end,
            if has_modifier(1) then "Shift" else empty end,
            .key
        ] | join(" + "));

    map({
        shortcut: shortcut,
        description: (if .has_description then .description else "No description" end)
    })
    | unique_by(.shortcut, .description)
    | sort_by(.shortcut)
    | .[]
    | [.shortcut, .description]
        | @tsv
    ' | awk -F '\t' '{ printf "%-34s %s\n", $1, $2 }'
    printf '\nPress q to close.\n'
} > "$keybind_list"

kitty \
    --class hypr-keybinds \
    --title "Hyprland keybindings" \
    sh -c 'less -R "$1"' sh "$keybind_list"
