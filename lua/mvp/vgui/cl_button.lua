--- Alternative to default DButton.
-- @panel mvp.Button

local theme = mvp.themes.GetActive()
local PANEL = {}

DEFINE_BASECLASS( "DButton" )

AccessorFunc(PANEL, 'backgroundColor', 'BackgroundColor')

function PANEL:SetBackgroundColor(col)
    self.backgroundColor = col
    self.backgroundCurrentColor = col
end

AccessorFunc(PANEL, 'backgroundColorHover', 'BackgroundColorHover')
AccessorFunc(PANEL, 'outlineColor', 'OutlineColor')

AccessorFunc(PANEL, 'noDrawOutline', 'NoDrawOutline')

AccessorFunc(PANEL, 'borderRadius', 'BorderRadius')

AccessorFunc(PANEL, 'textColor', 'TextColor')
AccessorFunc(PANEL, 'textColorHover', 'TextColorHover')

AccessorFunc(PANEL, 'icon', 'Icon')


function PANEL:Init()
    self:SetFont(mvp.Font(16, 500))

    self:SetBackgroundColor(mvp.Color(secondary_dark))
    self:SetBackgroundColorHover(mvp.Color(accent))

    self:SetTextColor(mvp.Color(primary_text))
    self:SetTextColorHover(mvp.Color(primary_text))

    self:SetOutlineColor(mvp.Color(accent))
    self:SetBorderRadius(4)

    self.backgroundCurrentColor = self:GetBackgroundColor()
end

function PANEL:DefaultPaint(w, h)
    if not self:GetNoDrawOutline() then
        draw.RoundedBox(self:GetBorderRadius() + 1, 0, 0, w, h, self:GetOutlineColor())
    end 

    draw.RoundedBox(self:GetBorderRadius(), self:GetNoDrawOutline() and 0 or 1, self:GetNoDrawOutline() and 0 or 1, w - (self:GetNoDrawOutline() and 0 or 2), h - (self:GetNoDrawOutline() and 0 or 2), self.backgroundCurrentColor)

    local tw, th = self:GetTextSize()
    if self:GetIcon() then
        local iw = h * .8

        draw.SimpleText(self:GetText(), self:GetFont(), w * .5 + iw * .5 + 1, h * .5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        mvp.utils.DrawIcon(w * .5 - tw * .5 - 1, h * .5, self:GetIcon(), th * .9, mvp.Color(white))
    else
        draw.SimpleText(self:GetText(), self:GetFont(), w * .5, h * .5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return true 
end

function PANEL:OnCursorEntered()
    self:LerpColor('backgroundCurrentColor', self:GetBackgroundColorHover(), .2)
end
function PANEL:OnCursorExited()
    self:LerpColor('backgroundCurrentColor', self:GetBackgroundColor(), .2)
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)
    return true 
end

function PANEL:PerformLayout(w, h)
    local tw, th = self:GetTextSize()

    local size = w

    if self:GetIcon() then
        local iw = h
        size = tw * 1.5 + iw + 2
    else
        size = tw * 1.3
    end

    self:SetWide(math.max(size, w))
end

mvp.ui.Register('mvp.Button', PANEL, 'DButton')