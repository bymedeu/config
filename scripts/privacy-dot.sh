#!/bin/sh

join_unique_names() {
    awk '
        NF && !seen[$0]++ {
            if (joined != "") joined = joined ", "
            joined = joined $0
        }
        END { printf "%s", joined }
    '
}

pipewire_dump=$(pw-dump 2>/dev/null)

stream_rows=$(printf '%s' "$pipewire_dump" | jq -r '
    .[]
    | select(.type == "PipeWire:Interface:Node")
    | select(.info.state == "running")
    | (.info.props // {}) as $properties
    | ($properties["media.class"] // "") as $media_class
    | select($media_class == "Stream/Input/Audio" or $media_class == "Stream/Input/Video")
    | [
        (if $media_class == "Stream/Input/Audio" then "microphone" else "camera" end),
        ($properties["application.name"]
            // $properties["application.process.binary"]
            // $properties["media.name"]
            // "Unknown application")
      ]
    | @tsv
' 2>/dev/null)

pipewire_microphone_apps=$(printf '%s\n' "$stream_rows" \
    | awk -F '\t' '$1 == "microphone" { print $2 }' \
    | join_unique_names)

pipewire_camera_apps=$(printf '%s\n' "$stream_rows" \
    | awk -F '\t' '$1 == "camera" { print $2 }' \
    | join_unique_names)

# Also catch native applications that open an ALSA capture device directly.
direct_microphone_apps=$(
    for capture_device in /dev/snd/pcm*C*c; do
        [ -e "$capture_device" ] || continue
        microphone_pids=$(fuser "$capture_device" 2>/dev/null || true)
        for microphone_pid in $microphone_pids; do
            microphone_pid=$(printf '%s' "$microphone_pid" | tr -cd '0-9')
            [ -n "$microphone_pid" ] || continue
            microphone_process=$(ps -p "$microphone_pid" -o comm= 2>/dev/null | sed -n '1p')
            [ -n "$microphone_process" ] && printf '%s\n' "$microphone_process"
        done
    done | join_unique_names
)

# Some native applications open V4L2 devices directly instead of going
# through PipeWire, so check those handles as a camera fallback.
direct_camera_apps=$(
    for camera_device in /dev/video*; do
        [ -e "$camera_device" ] || continue
        camera_pids=$(fuser "$camera_device" 2>/dev/null || true)
        for camera_pid in $camera_pids; do
            camera_pid=$(printf '%s' "$camera_pid" | tr -cd '0-9')
            [ -n "$camera_pid" ] || continue
            camera_process=$(ps -p "$camera_pid" -o comm= 2>/dev/null | sed -n '1p')
            [ -n "$camera_process" ] && printf '%s\n' "$camera_process"
        done
    done | join_unique_names
)

microphone_apps=$(printf '%s\n%s\n' "$pipewire_microphone_apps" "$direct_microphone_apps" \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | join_unique_names)

camera_apps=$(printf '%s\n%s\n' "$pipewire_camera_apps" "$direct_camera_apps" \
    | tr ',' '\n' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | join_unique_names)

microphone_active=0
camera_active=0
[ -n "$microphone_apps" ] && microphone_active=1
[ -n "$camera_apps" ] && camera_active=1

if [ "$microphone_active" = 0 ] && [ "$camera_active" = 0 ]; then
    printf '%s\n' '{"text":"","tooltip":"","class":"inactive"}'
    exit 0
fi

privacy_tooltip=
privacy_class=

if [ "$microphone_active" = 1 ]; then
    privacy_tooltip="Microphone in use: $microphone_apps"
    privacy_class=microphone
fi

if [ "$camera_active" = 1 ]; then
    [ -n "$privacy_tooltip" ] && privacy_tooltip="$privacy_tooltip
"
    privacy_tooltip="${privacy_tooltip}Camera in use: $camera_apps"
    if [ "$microphone_active" = 1 ]; then
        privacy_class=microphone-camera
    else
        privacy_class=camera
    fi
fi

if [ "$microphone_active" = 1 ] && [ "$camera_active" = 1 ]; then
    privacy_text="󰍬 󰄀"
elif [ "$microphone_active" = 1 ]; then
    privacy_text="󰍬"
else
    privacy_text="󰄀"
fi

jq -cn \
    --arg text "$privacy_text" \
    --arg tooltip "$privacy_tooltip" \
    --arg class "$privacy_class" \
    '{text: $text, tooltip: $tooltip, class: $class}'
