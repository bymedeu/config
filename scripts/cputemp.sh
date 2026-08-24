#!/bin/sh

temperature_raw=

# Prefer the package sensor, then the laptop firmware's CPU sensors.
for preferred_type in x86_pkg_temp TCPU TCPU_PCI; do
    for thermal_zone_dir in /sys/class/thermal/thermal_zone*; do
        [ -r "$thermal_zone_dir/type" ] || continue
        thermal_zone_type=$(sed -n '1p' "$thermal_zone_dir/type")
        if [ "$thermal_zone_type" = "$preferred_type" ]; then
            temperature_raw=$(sed -n '1p' "$thermal_zone_dir/temp")
            break 2
        fi
    done
done

case $temperature_raw in
    ''|*[!0-9]*)
        printf '%s\n' '{"text":"?°","tooltip":"CPU temperature unavailable","class":"error"}'
        exit 0
        ;;
esac

temperature_c=$(( (temperature_raw + 500) / 1000 ))

if [ "$temperature_c" -ge 95 ]; then
    temperature_class=critical
elif [ "$temperature_c" -ge 80 ]; then
    temperature_class=warning
else
    temperature_class=normal
fi

jq -cn \
    --arg text "${temperature_c}°" \
    --arg tooltip "CPU package: ${temperature_c}°C · Click to open htop" \
    --arg class "$temperature_class" \
    '{text: $text, tooltip: $tooltip, class: $class}'
