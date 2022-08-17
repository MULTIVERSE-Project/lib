--- A bunch of utility functions for the rest of the codebase
-- @module mvp.utils
mvp.utils = mvp.utils or {}

--- Checks if `color` is really color.
-- @realm shared
-- @tparam any color Color to check.
-- @treturn bool True if `color` is color, false otherwise.
function mvp.utils.IsColor(color)
    return type(color) == 'table' and color.r and color.g and color.b and color.a
end

--- Converts hex to rgb and returns `Color`.
-- @realm shared
-- @tparam string hex Hex value to convert. This can be `#fff` or `fff` or `#ffffff` or `ffffff`.
-- @treturn Color Converted color.
function mvp.utils.HexToRGB(hex)
    hex = hex:gsub('#', '')

    if hex:len() == 3 then
        return Color(tonumber('0x' .. hex:sub(1, 1) * 17), tonumber('0x' .. hex:sub(2, 2)) * 17, tonumber('0x' .. hex:sub(3, 3)) * 17)
    else
        return Color(tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6)))
    end
end

--- Lerps between two colors.
-- @realm shared
-- @tparam number fract Fraction to lerp between `from` and `to`.
-- @tparam Color from Color to lerp from.
-- @tparam Color to Color to lerp to.
-- @treturn Color Lerped color.
function mvp.utils.LerpColor(fract, from, to)
    return Color(
        Lerp(fract, from.r or 255, to.r or 255),
		Lerp(fract, from.g or 255, to.g or 255),
		Lerp(fract, from.b or 255, to.b or 255),
		Lerp(fract, from.a or 255, to.a or 255)
	)
end