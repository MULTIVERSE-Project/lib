--- Alternative to default DButton.
-- @panel mvp.Button

local theme = mvp.themes.GetActive()
local PANEL = {}


AccessorFunc(PANEL, 'backgroundColor', 'BackgroundColor')
AccessorFunc(PANEL, 'backgroundColorHover', 'BackgroundColorHover')

AccessorFunc(PANEL, 'textColor', 'TextColor')
AccessorFunc(PANEL, 'textColorHover', 'TextColorHover')

AccessorFunc(PANEL, 'icon', 'Icon')

AccessorFunc(PANEL, 'outlineColor', 'OutlineColor')

function PANEL:Init()
    self:SetFont(mvp.utils.GetFont(16, 'Proxima Nova Rg', 500))

    self:SetBackgroundColor(theme:GetColor('secondary_dark'))
    self:SetBackgroundColorHover(theme:GetColor('accent'))

    self:SetTextColor(theme:GetColor('primary_text'))
    self:SetTextColorHover(theme:GetColor('primary_text'))

    self:SetOutlineColor(theme:GetColor('accent'))
end

function PANEL:DefaultPaint(w, h)
    draw.RoundedBox(5, 0, 0, w, h, theme:GetColor('accent'))
    draw.RoundedBox(4, 1, 1, w - 2, h - 2, self.backgroundColor)

    local tw, th = self:GetTextSize()

    
    if self:GetIcon() then
        local iw = h * .8

        draw.SimpleText(self:GetText(), self:GetFont(), w * .5 + iw * .5 + 1, h * .5, theme:GetColor('primary_text'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        mvp.utils.DrawIcon(w * .5 - tw * .5 - 1, h * .5, self:GetIcon(), h * .7, theme:GetColor('white'))
    else
        draw.SimpleText(self:GetText(), self:GetFont(), w * .5, h * .5, theme:GetColor('primary_text'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return true 
end

function PANEL:OnCursorEntered()
    self:LerpColor('backgroundColor', theme:GetColor('accent'), .2)
end

function PANEL:OnCursorExited()
    self:LerpColor('backgroundColor', theme:GetColor('secondary_dark'), .2)
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)
    return true 
end

function PANEL:PerformLayout(w, h)
    local tw, th = self:GetTextSize()
    local iw = h - 8

    self:SetWide(tw + iw + 20)
end

mvp.ui.Register('mvp.Button', PANEL, 'DButton')