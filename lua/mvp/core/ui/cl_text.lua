--- @module mvp.ui
mvp.ui = mvp.ui or {}

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