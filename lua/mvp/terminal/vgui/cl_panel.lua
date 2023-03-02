--- Generic panel with some basic style.
-- This is a generic panel with rounded box of secondary color.
-- @panel mvp.Panel

local PANEL = {}

function PANEL:Init()
    
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(56, 56, 56))
end

vgui.Register("mvp.Panel", PANEL, "EditablePanel")