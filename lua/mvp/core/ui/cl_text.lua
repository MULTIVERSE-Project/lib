--- @module mvp.ui
mvp.ui = mvp.ui or {}

--- Draws text with color support
-- @realm client
-- @tparam table textTab Table of strings and colors
-- @tparam string font Font to use
-- @tparam number x X position
-- @tparam number y Y position
-- @tparam Color startColor Color to start with
-- @tparam number xalign Horizontal alignment
-- @tparam number yalign Vertical alignment
-- @treturn number Width of the text
-- @treturn number Height of the text
-- @usage
-- mvp.ui.DrawColoredText( {Color(255, 0, 0), 'Hello ', Color(0, 255, 0), 'World!'}, 'DermaDefault', 0, 0, nil, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
function mvp.ui.DrawColoredText( textTab, font, x, y, startColor, xalign, yalign )
	text = ''
	font = font or "DermaDefault"
	x = x or 0
	y = y or 0
	xalign = xalign	or TEXT_ALIGN_LEFT
	yalign = yalign	or TEXT_ALIGN_TOP

    for k, v in pairs(textTab) do
        if mvp.utils.IsColor(v) then 
            continue 
        end

        if mvp.utils.GetTypeFromValue(v) ~= mvp.type.string then continue end

        text = text .. v
    end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x - w / 2
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x - w
	end

	if ( yalign == TEXT_ALIGN_CENTER ) then
		y = y - h / 2
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
		y = y - h
	end

	surface.SetTextPos( math.ceil( x ), math.ceil( y ) )

    if mvp.utils.IsColor(startColor) then
        surface.SetTextColor(startColor)
    else
        surface.SetTextColor(255, 255, 255, 255)
    end

	for k, v in pairs(textTab) do
        if mvp.utils.IsColor(v) then 
            surface.SetTextColor(v)
        else
            surface.DrawText(v)
        end
    end

	return w, h

end

