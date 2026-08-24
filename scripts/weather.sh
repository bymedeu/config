#!/bin/sh

# Keep the last successful location and forecast so a temporary network or
# wttr.in failure does not replace useful weather information with an error.
cache_root=${XDG_CACHE_HOME:-"$HOME/.cache"}/waybar
location_cache=$cache_root/weather-location
weather_cache=$cache_root/weather.json

umask 077
mkdir -p "$cache_root" 2>/dev/null || true

# IP geolocation changes rarely. Refresh it daily, and never overwrite a good
# cached value when the lookup fails.
if [ ! -s "$location_cache" ] || [ -n "$(find "$location_cache" -mmin +1440 -print -quit 2>/dev/null)" ]; then
    fresh_location=$(curl -fsS --max-time 8 https://ipinfo.io/loc 2>/dev/null | tr -d '\r\n')
    if [ -n "$fresh_location" ]; then
        printf '%s\n' "$fresh_location" > "$location_cache"
    fi
fi

weather_location=$(sed -n '1p' "$location_cache" 2>/dev/null)

if [ -n "$weather_location" ]; then
    raw_weather=$(timeout 25s wttrbar \
        --custom-indicator '{ICON} {temp_C}°' \
        --location "$weather_location" \
        --date-format '%d/%m' \
        --hide-conditions \
        --nerd \
        --lang fr \
        --observation-time 2>/dev/null)
else
    # wttr.in can locate the request itself if the geolocation service is down.
    raw_weather=$(timeout 25s wttrbar \
        --custom-indicator '{ICON} {temp_C}°' \
        --date-format '%d/%m' \
        --hide-conditions \
        --nerd \
        --lang fr \
        --observation-time 2>/dev/null)
fi

formatted_weather=$(printf '%s' "$raw_weather" | jq -c '
    select(type == "object" and (.text | type == "string"))
    | if (.text | test("^[^[:space:]]+[[:space:]]+")) then
        .text = (.text
            | capture("^(?<icon>[^[:space:]]+)[[:space:]]+(?<value>.+)$")
            | .icon + "\n<span size=\"small\">" + .value + "</span>")
      else . end
    | .tooltip = (.tooltip // "") + "\n\nCliquer pour actualiser"
' 2>/dev/null)

if [ -n "$formatted_weather" ]; then
    weather_tmp=$weather_cache.$$
    printf '%s\n' "$formatted_weather" > "$weather_tmp" \
        && mv "$weather_tmp" "$weather_cache"
    printf '%s\n' "$formatted_weather"
elif [ -s "$weather_cache" ]; then
    jq -c '
        .class = "stale"
        | .tooltip = "⚠ Données météo mises en cache\n\n" + (.tooltip // "")
    ' "$weather_cache"
else
    printf '%s\n' '{"text":"","tooltip":"Météo indisponible","class":"error"}'
fi
