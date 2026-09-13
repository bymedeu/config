-- Programs started once per Hyprland session.
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/autostart.sh")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- Mirror highlighted text (the Wayland primary selection) to the regular
    -- clipboard so it is available through Ctrl-V in other applications.
    hl.exec_cmd("wl-paste --primary --watch wl-copy")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

-- Waybar can miss an output while the startup/hotplug layout is settling.
-- Recreate its bars after the last monitor change, preserving toggle-off.
local bar_timer = hl.timer(function()
    hl.exec_cmd("~/.config/hypr/scripts/restore-waybar.sh")
end, { timeout = 1500, type = "oneshot" })
local function refresh_bars()
    bar_timer:set_timeout(1500)
    bar_timer:set_enabled(true)
end
hl.on("monitor.added", refresh_bars)
hl.on("monitor.removed", refresh_bars)
hl.on("hyprland.start", refresh_bars)

hl.env("HYPRCURSOR_THEME", "VolantesCursors")
hl.env("XCURSOR_THEME", "VolantesCursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
