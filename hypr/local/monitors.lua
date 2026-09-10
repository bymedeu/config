-- Desk layout: Iiyama (left), Samsung (main), laptop (right, normally off).
local main = "Samsung Electric Company LC24RG50 H4LRC04222"
local secondary = "Iiyama North America PL2474H 1166900301295"

hl.monitor({
    output = "desc:" .. main,
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

-- Iiyama PL2474H to the left of the main screen.
hl.monitor({
    output = "desc:Iiyama North America PL2474H 1166900301295",
    mode = "1920x1080@60",
    position = "-1920x0",
    scale = 1,
})

hl.config({ cursor = { default_monitor = "desc:" .. main } })
hl.workspace_rule({ workspace = "1", monitor = "desc:" .. main })
hl.workspace_rule({ workspace = "2", monitor = "desc:" .. main, default = true })
hl.workspace_rule({ workspace = "3", monitor = "desc:" .. secondary, default = true })

local laptop_override = nil
local last_layout = nil
local last_laptop_rule = nil

local function update_laptop()
    local has_main, has_secondary, external_count = false, false, 0
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name ~= "eDP-1" then
            external_count = external_count + 1
        end
        has_main = has_main or monitor.description == main
        has_secondary = has_secondary or monitor.description == secondary
    end

    local layout = tostring(has_main) .. ":" .. tostring(has_secondary) .. ":" .. external_count
    if layout ~= last_layout then
        laptop_override = nil
        last_layout = layout
    end
    local enabled = not (has_main and has_secondary)
    if laptop_override ~= nil then enabled = laptop_override end
    -- Never leave an undocked laptop without a usable screen.
    if external_count == 0 then enabled = true end
    local position = has_main and "1920x0" or "0x0"
    local rule = tostring(enabled) .. ":" .. position
    if rule == last_laptop_rule then return end
    last_laptop_rule = rule
    hl.monitor({
        output = "eDP-1",
        mode = "2880x1920@120",
        position = position,
        scale = 2,
        disabled = not enabled,
    })
end

-- Defer until hotplug processing finishes; unchanged rules are not reapplied.
local layout_timer = hl.timer(update_laptop, { timeout = 300, type = "oneshot" })
hl.on("monitor.layout_changed", function()
    layout_timer:set_timeout(300)
    layout_timer:set_enabled(true)
end)
hl.on("hyprland.start", update_laptop)

local function toggle_laptop()
    laptop_override = hl.get_monitor("eDP-1") == nil
    update_laptop()
end
hl.bind("SUPER + SHIFT + P", toggle_laptop, { description = "Toggle laptop screen on the right" })

update_laptop()

hl.monitor({
    output = "*",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

return { toggle_laptop = toggle_laptop }
