local main_mod = "SUPER"

hl.config({
    input = {
        kb_layout = "fr",
        kb_variant = "us",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
    },
})

for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end
