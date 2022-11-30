mvp.utils = mvp.utils or {}



function mvp.utils.AddPopup(text, icon, color, duration)
    assert(text, 'Cannot add popup without text!')

    icon = icon or 'f071'
    color = color or mvp.Color('green')

    duration = duration or 5

    local w, h = ScrW(), ScrH()

    local pnl = vgui.Create('EditablePanel')
    pnl:SetDrawOnTop(true)

    pnl.progress = 0

    function pnl:Paint(w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, mvp.Color('primary'), true, true, true, false)
        draw.RoundedBoxEx(8, 0, 0, math.min(64, h), h, mvp.Color('secondary'), true, false, true, false)

        draw.RoundedBox(0, math.min(64, h), h - 7, w - math.min(64, h), 15, ColorAlpha(mvp.Color('white'), 15))
        draw.RoundedBox(0, math.min(64, h), h - 7, (w - math.min(64, h)) * self.progress, 7, color)

        mvp.utils.DrawIcon( math.min(64 * .5, h * .5), h * .5, icon, math.min(64 * .5, h), color_white)
    end

    local textPnl = vgui.Create('DLabel', pnl)
    textPnl:SetText( text )
    textPnl:SetFont(mvp.utils.GetFont(18, 'Proxima Nova Rg'))
	textPnl:SizeToContents()
	textPnl:SetContentAlignment( 4 )
	textPnl:SetTextColor( mvp.Color('primary_text') )
    
    local w, h = textPnl:GetSize()
    
    local xOffset = math.min(64, math.max(h, 45) + 15) + 10
    
	pnl:SetSize( math.max(w, 200) + xOffset + 10, math.max(h, 45) + 15 )

    pnl:CenterHorizontal()
    pnl:SetY(-(math.max(h, 45) + 15))
    
    textPnl:StretchToParent( xOffset, 5, 5, 5 )

    pnl:MoveTo(pnl:GetX(), 15, 1, 0, 0.5, function()
        pnl:Lerp('progress', 1, duration, function()
            pnl:MoveTo(pnl:GetX(), -pnl:GetTall() - 15, 1, 0, 0.5, function()
                pnl:Remove()
            end)
        end) 
    end)
end