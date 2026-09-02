-- Plugin options are only valid after their plugin has been loaded. Keeping
-- this guard makes the base configuration valid on machines without it.
for _, plugin in ipairs(hl.get_loaded_plugins()) do
    if plugin.name == "overview" then
        hl.config({
            plugin = {
                overview = {
                    reverseSwipe = true,
                    overrideGaps = false,
                    gapsIn = 10,
                    gapsOut = 20,
                },
            },
        })
        break
    end
end
