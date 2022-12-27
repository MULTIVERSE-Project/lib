local PANEL = {}
local theme = mvp.themes.GetActive()

function PANEL:Init()
    self:SetContentAlignment(4)
    self:SetTextInset(5, 0)

    self:SetFont(mvp.Font(24, 300))
end

function PANEL:DoClick()
    self:GetParent():Toggle()
end

function PANEL:Paint(w, h)
    draw.SimpleText(self:GetText(), self:GetFont(), 5, h / 2, mvp.Color(text), 0, 1)

    return true
end

mvp.ui.Register('mvp.CategoryHeader', PANEL, 'DButton')

local PANEL = {}

AccessorFunc(PANEL, 'sideblockColor', 'SideblockColor')

function PANEL:Init()
    if IsValid(self.Header) then
        self.Header:Remove()
    end

    self.Header = vgui.Create('mvp.CategoryHeader', self)
    self.Header:Dock(TOP)
    self.Header:DockMargin(0, 0, 0, 5)
    self.Header:SetTall(32)

    self:DockPadding(5, 0, 5, 5)

    self.headerBackgroundColor = mvp.Color(secondary_dark)
end

function PANEL:DefaultPaint(w, h)
    local headerHeight = self:GetHeaderHeight()

    -- if not self:GetExpanded() then
        draw.RoundedBox(8, 0, 0, w - 5, h, self.sideblockColor or mvp.Color(white))
    -- end
    
    draw.RoundedBoxEx(8, 5, 5, w - 5, h - 5, mvp.Color(secondary), false, false, true, true)
    draw.RoundedBox(8, 5, 0, w - 5, headerHeight, self.headerBackgroundColor, true, true, not self:GetExpanded(), not self:GetExpanded())
        
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h) 
end

mvp.ui.Register('mvp.Category', PANEL, 'DCollapsibleCategory')