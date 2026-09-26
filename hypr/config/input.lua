local programs = require("config.programs")
local main_mod = "SUPER"

local function bind(keys, dispatcher, description, options)
    local bind_options = {}
    for name, value in pairs(options or {}) do
        bind_options[name] = value
    end
    bind_options.description = description
    hl.bind(keys, dispatcher, bind_options)
end

hl.config({
    input = {
        -- Framework built-in keyboard: standard Canadian French QWERTY.
        kb_layout = "ca",
        kb_variant = "fr",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        numlock_by_default = true,
        follow_mouse = 1,
        sensitivity = 0.1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = false,
        },
    },
    gestures = {
        workspace_swipe_touch = true,
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- AJAZZ AK820 Pro over Bluetooth: physical US QWERTY.
hl.device({
    name = "ak820-5.1-1-keyboard",
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
})

-- Main desktop controls.
bind(main_mod .. " + Q", hl.dsp.window.close(), "Close the focused window")
bind(main_mod .. " + R", hl.dsp.exec_cmd(programs.menu), "Open the application launcher")
bind(main_mod .. " + D", hl.dsp.exec_cmd(programs.menu), "Open the application launcher")
bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"), "Lock the session")
bind(main_mod .. " + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-waybar.sh"), "Toggle Waybar")
bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/reload.sh"), "Reload the desktop configuration")
bind(main_mod .. " + F11", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"), "Toggle game mode")
bind(main_mod .. " + SHIFT + M", hl.dsp.exit(), "Exit Hyprland")
bind(main_mod .. " + SHIFT + slash", hl.dsp.exec_cmd("~/.config/hypr/scripts/show-keybinds.sh"), "Show all keybindings")

-- Application shortcuts.
bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(programs.terminal), "Open a terminal")
bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(programs.menu), "Open the application launcher")
bind(main_mod .. " + E", hl.dsp.exec_cmd(programs.file_manager), "Open the file manager")
bind(main_mod .. " + A", hl.dsp.exec_cmd(programs.notification_manager), "Toggle notifications")
bind("XF86Launch1", hl.dsp.exec_cmd("kitty vim ~/.config/hypr/config"), "Edit the Hyprland configuration", { locked = true, repeating = true })

-- Focus and layout.
bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }), "Focus the window to the left")
bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }), "Focus the window to the right")
bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }), "Focus the window above")
bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }), "Focus the window below")
bind(main_mod .. " + F", hl.dsp.window.fullscreen(), "Toggle fullscreen")
bind(main_mod .. " + V", hl.dsp.layout("togglesplit"), "Toggle the split direction")
bind(main_mod .. " + T", hl.dsp.window.float(), "Toggle floating mode")
bind(main_mod .. " + H", hl.dsp.window.pseudo(), "Toggle pseudotiling")

-- Both configured layouts are QWERTY and have an unshifted number row.
for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }), "Switch to workspace " .. workspace)
    bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }), "Move the focused window to workspace " .. workspace)
end

bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"), "Toggle the scratchpad")

-- Preserve the existing scratchpad-based minimize sequence.
bind(main_mod .. " + N", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end, "Hide the focused window in the scratchpad")

bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Switch to the next workspace")
bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Switch to the previous workspace")
bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), "Move the focused window", { mouse = true })
bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), "Resize the focused window", { mouse = true })

-- Volume.
local repeat_locked = { locked = true, repeating = true }
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), "Increase volume", repeat_locked)
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), "Decrease volume", repeat_locked)
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), "Toggle audio mute", repeat_locked)
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), "Toggle microphone mute", repeat_locked)

-- Brightness.
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), "Increase brightness by 5%", repeat_locked)
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), "Decrease brightness by 5%", repeat_locked)
bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 1%+"), "Increase brightness by 1%", repeat_locked)
bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 1%-"), "Decrease brightness by 1%", repeat_locked)

-- Media controls.
local locked = { locked = true }
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "Play the next track", locked)
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "Pause or resume media", locked)
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "Play or pause media", locked)
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "Play the previous track", locked)

-- Screenshots and utilities. These include the user's current uncommitted
-- replacement for SUPER+SHIFT+S.
bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"), "Copy an area screenshot")
bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --fullscreen"), "Copy a fullscreen screenshot")
bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot-temp.sh"), "Copy a temporary area screenshot")
bind(main_mod .. " + CONTROL + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot-temp.sh --save"), "Save an area screenshot")
bind(main_mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), "Pick a screen color")
bind("SUPER + CONTROL + XF86TouchpadToggle", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-touchpad.sh"), "Toggle the touchpad")
