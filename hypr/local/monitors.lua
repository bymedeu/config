-- Desk layout: Iiyama (left), Samsung (middle), laptop (main, right).
local middle = "Samsung Electric Company LC24RG50 H4LRC04222"
local left = "Iiyama North America PL2474H 1166900301295"

hl.monitor({
	output = "desc:" .. middle,
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
})

-- Iiyama PL2474H to the left of the main screen.
hl.monitor({
	output = "desc:" .. left,
	mode = "1920x1080@60",
	position = "-1920x0",
	scale = 1,
})

-- Keep the laptop in the layout. DPMS blanks it without changing the layout;
-- only the explicit shortcut should wake it again.
hl.monitor({
	output = "eDP-1",
	mode = "2880x1920@120",
	position = "1920x0",
	scale = 2,
})

hl.config({
	cursor = { default_monitor = "eDP-1" },
	misc = { mouse_move_enables_dpms = false },
})
local initial_workspace_rules = {
	hl.workspace_rule({ workspace = "2", monitor = "desc:" .. left, default = true }),
	hl.workspace_rule({ workspace = "1", monitor = "desc:" .. middle, default = true }),
	hl.workspace_rule({ workspace = "10", monitor = "eDP-1", default = true }),
}

-- Use the monitor rules only to establish the initial layout. Afterwards the
-- workspaces remain movable between monitors.
local function unlock_initial_workspaces()
	for _, rule in ipairs(initial_workspace_rules) do
		rule:set_enabled(false)
	end
end
local workspace_unlock_timer = nil
local function schedule_workspace_unlock()
	if workspace_unlock_timer ~= nil then
		workspace_unlock_timer:set_enabled(false)
	end
	for _, rule in ipairs(initial_workspace_rules) do
		rule:set_enabled(true)
	end
	workspace_unlock_timer = hl.timer(unlock_initial_workspaces, { timeout = 1500, type = "oneshot" })
end
schedule_workspace_unlock()
hl.on("hyprland.start", schedule_workspace_unlock)

local dpms_toggle_timer = nil

local function toggle_laptop_dpms()
	local laptop = hl.get_monitor("eDP-1")
	if laptop == nil then
		return
	end
	local action = laptop.dpms_status and "disable" or "enable"
	dpms_toggle_timer = hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ monitor = "eDP-1", action = action }))
	end, { timeout = 100, type = "oneshot" })
end
hl.bind("SUPER + SHIFT + P", toggle_laptop_dpms, {
	description = "Toggle the laptop screen",
})

hl.monitor({
	output = "*",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

return { toggle_laptop_dpms = toggle_laptop_dpms }
