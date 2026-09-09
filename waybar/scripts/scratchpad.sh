#!/bin/sh

workspaces=$(hyprctl -j workspaces 2>/dev/null) || exit 1
if ! printf '%s\n' "$workspaces" | jq -e 'any(.[]; .name == "special:magic" and .windows > 0)' >/dev/null; then
  printf '%s\n' '{"text":""}'
  exit 0
fi

hyprctl -j monitors 2>/dev/null | jq -c '
  {
    text: "",
    tooltip: "Scratchpad · magic (Win+S)",
    class: (if any(.[]; .specialWorkspace.name == "special:magic")
            then "active" else "hidden" end)
  }
'
