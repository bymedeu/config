-- Hyprland configuration entry point.
-- See https://wiki.hypr.land/Configuring/Start/

-- Prefer the machine-local monitor overlay, but keep a portable fallback for
-- a fresh clone where the gitignored overlay has not been created yet.
local local_config_ok = pcall(require, "local.hyprland")
if not local_config_ok then
    require("config.monitors.default")
end

require("config.environment")
require("config.input")

-- The keyboard-layout helper stores which set of number-row bindings is
-- active. Default to QWERTY when the runtime status file does not exist.
local binding_layout = "us"
local status_file = io.open(os.getenv("HOME") .. "/.config/hypr/status/kb_layout", "r")
if status_file then
    local saved_layout = status_file:read("*l")
    status_file:close()
    if saved_layout == "fr" then
        binding_layout = "fr"
    end
end
require("config.kb_layouts." .. binding_layout)

require("config.appearance")
require("config.plugins")

-- Keep the final input override from the previous Hyprlang entry point.
hl.config({
    input = {
        kb_layout = "ca, us",
        kb_variant = "fr",
        kb_options = "grp:alt_space_toggle",
    },
})
