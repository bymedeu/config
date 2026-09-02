local colors = require(os.getenv("HOME") .. "/.config/colors/hyprland")

hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 1,
        border_size = 1,
        col = {
            active_border = colors.active,
            inactive_border = colors.inactive,
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 4,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.layer_rule({
    name = "layerrule-1",
    blur = true,
    match = { namespace = "waybar" },
})
hl.layer_rule({
    name = "layerrule-2",
    blur = true,
    ignore_alpha = 0.5,
    match = { namespace = "swaync-control-center" },
})
hl.layer_rule({
    name = "layerrule-3",
    blur = true,
    ignore_alpha = 0.5,
    match = { namespace = "swaync-notification-window" },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easeInOutExpo", { type = "bezier", points = { { 0.87, 0 }, { 0.13, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })

hl.window_rule({
    name = "windowrule-1",
    match = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name = "windowrule-2",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
hl.window_rule({
    name = "windowrule-3",
    match = { class = "^(albert)$" },
    border_size = 0,
    no_blur = true,
    no_shadow = true,
    float = true,
    stay_focused = true,
    no_dim = true,
})
hl.window_rule({
    name = "windowrule-4",
    match = { class = "(org.prismlauncher.PrismLauncher)" },
    pseudo = true,
})
hl.window_rule({
    name = "windowrule-5",
    match = {
        class = "(org.prismlauncher.PrismLauncher)",
        title = "^(Prism Launcher .*)$",
    },
    size = "(monitor_w*0.65) (monitor_h*0.7)",
})
hl.window_rule({
    name = "windowrule-6",
    match = { class = "(org.gnome.Nautilus)" },
    pseudo = true,
})
hl.window_rule({
    name = "windowrule-7",
    match = {
        class = "(org.gnome.Nautilus)",
        initial_title = "^(Loading…)$",
    },
    size = "(monitor_w*0.65) (monitor_h*0.7)",
})
hl.window_rule({
    name = "windowrule-8",
    match = { class = "(ui-PlanAhead)" },
    float = true,
    center = true,
})
hl.window_rule({
    name = "windowrule-9",
    match = {
        class = "(ui-PlanAhead)",
        title = "^(win0)$",
    },
    size = "397 295",
})
hl.window_rule({
    name = "windowrule-10",
    match = { class = "(Vivado)" },
    tile = true,
})
