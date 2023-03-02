--- @module mvp

local weightToName = {
    [100] = 'Proxima Nova Th',
    [200] = 'Proxima Nova Lt',
    [300] = 'Proxima Nova Lt',
    [400] = 'Proxima Nova Rg',
    [500] = 'Proxima Nova Rg',
    [600] = 'Proxima Nova Semibold',
    [700] = 'Proxima Nova Bold',
    [800] = 'Proxima Nova Extrabold',
    [900] = 'Proxima Nova Bl'
}

--- Shortcut for `mvp.fonts.Get`
-- @realm client
-- @tparam number size The size of the font.
-- @tparam[opt=400] number weight The font weight
-- @treturn string The created font. Name will follow this format: `mvp_<size>_<font>_<weight>`
function mvp.Font(size, weight)
    local font = weightToName[weight] or 'Proxima Nova Rg'
    return mvp.fonts.Get(size, font, weight)
end