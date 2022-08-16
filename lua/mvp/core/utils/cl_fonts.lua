--- A bunch of utility functions for the rest of the codebase
-- @module mvp.utils
mvp.utils = mvp.utils or {}

mvp.utils.cachedFonts = mvp.utils.cachedFonts or {}

--- Creates a new font. Or returns a cached one if it has been created before.
-- @realm client
-- @tparam number size The name of the font.
-- @tparam string font The font to use
-- @tparam[opt=400] number weight The font weight
-- @treturn string The created font. Name will follow this format: `mvp_<size>_<font>_<weight>`
-- @usage
-- local font = mvp.utils.GetFont(12, "Roboto", 400)
-- 
-- print(font) -- "mvp_12_Roboto_400"
function mvp.utils.GetFont(size, font, weight)
    weight = weight or 400
    local fontName = 'mvp_' .. size .. '_' .. font .. '_' .. weight

    if mvp.utils.cachedFonts[fontName] then
        return fontName
    end

    surface.CreateFont(fontName, {
        size = size,
        weight = weight,
        font = font,
        extended = true
    })

    mvp.utils.cachedFonts[fontName] = true

    return fontName
end

--- Gets all registered fonts.
-- @realm client
-- @treturn table The registered fonts.
-- @usage 
-- local fonts = mvp.utils.GetRegisteredFonts()
--
-- for k, v in pairs(fonts) do
--     print(k, v)
-- end
--
-- > 1 mvp_16_Roboto_400
-- > 2 mvp_16_Roboto_500
-- > 3 mvp_16_Roboto_700
-- > 4 mvp_16_Roboto_900
function mvp.utils.GetAllFonts()
    local t = {}
    for k, _ in pairs(mvp.utils.cachedFonts) do
        table.insert(t, k)
    end

    return t
end