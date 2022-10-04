--- @module mvp

--- Shortcut for `mvp.themes.GetColor`
-- @realm shared
-- @tparam string colorName The name of the color
-- @treturn Color The color
function mvp.Color(colorName)
    return mvp.themes.GetColor(colorName)
end