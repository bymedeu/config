#!/bin/sh

current=$(brightnessctl -d intel_backlight get 2>/dev/null) || exit 1
maximum=$(brightnessctl -d intel_backlight max 2>/dev/null) || exit 1
[ "$maximum" -gt 0 ] || exit 1
percent=$((current * 100 / maximum))

if [ "$percent" -lt 15 ]; then icon=""
elif [ "$percent" -lt 30 ]; then icon=""
elif [ "$percent" -lt 45 ]; then icon=""
elif [ "$percent" -lt 60 ]; then icon=""
elif [ "$percent" -lt 75 ]; then icon=""
elif [ "$percent" -lt 90 ]; then icon=""
else icon=""
fi

jq -cn --arg text "$icon" --arg tooltip "Laptop brightness: $percent%" \
	'{text: $text, tooltip: $tooltip}'
