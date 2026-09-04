local programs = require("config.programs")
local main_mod = "SUPER"

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
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(programs.menu))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd(programs.menu))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-waybar.sh"))
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/reload.sh"))
hl.bind(main_mod .. " + F11", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"))
hl.bind(main_mod .. " + SHIFT + M", hl.dsp.exit())

-- Application shortcuts.
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(programs.terminal))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(programs.menu))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(programs.file_manager))
hl.bind(main_mod .. " + A", hl.dsp.exec_cmd(programs.notification_manager))
hl.bind("XF86Launch1", hl.dsp.exec_cmd("kitty vim ~/.config/hypr/config"), { locked = true, repeating = true })

-- Focus and layout.
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + V", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + T", hl.dsp.window.float())
hl.bind(main_mod .. " + H", hl.dsp.window.pseudo())

-- Both configured layouts are QWERTY and have an unshifted number row.
for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Preserve the existing scratchpad-based minimize sequence.
hl.bind(main_mod .. " + N", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume.
local repeat_locked = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), repeat_locked)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), repeat_locked)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), repeat_locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), repeat_locked)

-- Brightness.
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), repeat_locked)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), repeat_locked)
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 1%+"), repeat_locked)
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 1%-"), repeat_locked)

-- Media controls.
local locked = { locked = true }
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)

-- Screenshots and utilities. These include the user's current uncommitted
-- replacement for SUPER+SHIFT+S.
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh --fullscreen"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot-temp.sh"))
hl.bind(main_mod .. " + CONTROL + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot-temp.sh --save"))
hl.bind(main_mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + CONTROL + XF86TouchpadToggle", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-touchpad.sh"))
