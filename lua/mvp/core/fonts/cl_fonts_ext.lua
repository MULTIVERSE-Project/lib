--- @module mvp

--- Shortcut for `mvp.fonts.Get`
-- @realm client
-- @tparam number size The size of the font.
-- @tparam[opt=400] number weight The font weight
-- @treturn string The created font. Name will follow this format: `mvp_<size>_<font>_<weight>`
function mvp.Font(size, weight)
    return mvp.fonts.Get(size, 'Proxima Nova Rg', weight)
end