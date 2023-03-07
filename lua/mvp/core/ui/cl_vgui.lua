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

local scrH = ScrH
local max = math.max
function mvp.ui.Scale(value)
    return max(value * (scrH() / 1080), 1)
end

--- Table of sound keys and their paths.
-- @table SoundKeys
-- @realm client
-- @field click `terminal/ui/click.ogg` The click sound.
-- @field hover `terminal/ui/hover.ogg` The hover sound.
local sounds = {
    ["click"] = "terminal/ui/click.ogg",
    ["hover"] = "terminal/ui/hover.ogg"
}

--- Plays a sound.
-- @realm client
-- @tparam string soundName The name of the sound to play from `SoundKeys`.
function mvp.ui.Sound(soundName)
    if not sounds[soundName] then
        return 
    end

    surface.PlaySound(sounds[soundName])
end