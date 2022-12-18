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

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub('.', function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return '\n' .. char
        end

        return char
    end)

    return text, totalWidth
end

function mvp.utils.TextWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end