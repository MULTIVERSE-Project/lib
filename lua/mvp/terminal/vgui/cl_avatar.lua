local PANEL = {}

AccessorFunc(PANEL, "_outlineColor", "OutlineColor")

function PANEL:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)

    self:SetOutlineColor(Color(255, 192, 92))
end

function PANEL:PerformLayout(w, h)
    local pad = mvp.ui.Scale(8)
    
    -- self.Avatar:DockMargin(pad, pad, pad, pad)
    -- self.Avatar:Dock(FILL)

    self.Avatar:SetSize(w, h)
end

function PANEL:Paint(w, h)
    local pad = mvp.ui.Scale(2)

    draw.RoundedBox(8, 0, 0, w, h, Color(255, 192, 92))
    
    mvp.ui.DrawPolyMask(function()
        mvp.ui.DrawRoundedBox(9, pad, pad, w - pad * 2, h - pad * 2)
    end, function()
        self.Avatar:SetPaintedManually(false)
		self.Avatar:PaintManual()
		self.Avatar:SetPaintedManually(true)
    end)

end

PANEL.SetPlayer = function(s, ply, size) s.Avatar:SetPlayer(ply, size) end
PANEL.SetSteamID = function(s, id, size) s.Avatar:SetSteamID(id, size) end

vgui.Register("mvp.Avatar", PANEL, "EditablePanel")