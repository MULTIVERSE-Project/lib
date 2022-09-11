--- UI helper functions.
-- @module mvp.ui
mvp.ui = mvp.ui or {}

--- Registers a new panel, and make sure it's can be reloded using concommand. Uses `vgui.Register` internally.
-- @realm client
-- @tparam string name The name of the panel.
-- @tparam Panel panel The panel to register.
-- @tparam string basePanel The base panel to use.
function mvp.ui.Register(name, panel, basePanel)
    -- hook.Add('MVP:LoadUI', 'Load:' .. name, function()
        vgui.Register(name, panel, basePanel)
    -- end)
end