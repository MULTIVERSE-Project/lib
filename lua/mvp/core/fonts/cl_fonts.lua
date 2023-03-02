mvp.fonts = mvp.fonts or {}

mvp.fonts.cachedFonts = mvp.fonts.cachedFonts or {}

--- Creates a new font. Or returns a cached one if it has been created before.
-- @realm client
-- @tparam number size The name of the font.
-- @tparam string font The font to use
-- @tparam[opt=400] number weight The font weight
-- @treturn string The created font. Name will follow this format: `mvp_<size>_<font>_<weight>`
-- @usage
-- local font = mvp.fonts.GetFont(12, "Roboto", 400)
-- 
-- print(font) -- "mvp_12_Roboto_400"
function mvp.fonts.Get(size, font, weight)
    size = mvp.ui.Scale(size)

    weight = weight or 400
    local fontName = 'mvp_' .. size .. '_' .. font .. '_' .. weight

    if mvp.fonts.cachedFonts[fontName] then
        return fontName
    end

    surface.CreateFont(fontName, {
        size = size,
        weight = weight,
        font = font,
        extended = true
    })

    mvp.fonts.cachedFonts[fontName] = true

    return fontName
end

--- Creates a new unscaled font or returns a cached one if it has been created before.
-- @realm client
-- @tparam number size The name of the font.
-- @tparam string font The font to use
-- @tparam[opt=400] number weight The font weight
-- @treturn string The created font. Name will follow this format: `mvp_<size>_<font>_<weight>`
function mvp.fonts.GetUnscaled(size, font, weight)   
    weight = weight or 400
    local fontName = 'mvp_' .. size .. '_' .. font .. '_' .. weight

    if mvp.fonts.cachedFonts[fontName] then
        return fontName
    end

    surface.CreateFont(fontName, {
        size = size,
        weight = weight,
        font = font,
        extended = true
    })

    mvp.fonts.cachedFonts[fontName] = true

    return fontName
end

--- Gets all registered fonts.
-- @realm client
-- @treturn table The registered fonts.
-- @usage 
-- local fonts = mvp.fonts.GetRegisteredFonts()
--
-- for k, v in pairs(fonts) do
--     print(k, v)
-- end
--
-- > 1 mvp_16_Roboto_400
-- > 2 mvp_16_Roboto_500
-- > 3 mvp_16_Roboto_700
-- > 4 mvp_16_Roboto_900
function mvp.fonts.GetAll()
    local t = {}
    for k, _ in pairs(mvp.fonts.cachedFonts) do
        table.insert(t, k)
    end

    return t
end