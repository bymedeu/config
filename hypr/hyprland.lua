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

require("config.appearance")
require("config.plugins")
