local theme = mvp.themes.GetActive()
local PANEL = {}

AccessorFunc(PANEL, '_backgroundColor', 'BackgroundColor')
AccessorFunc(PANEL, 'backgroundColorHover', 'BackgroundColorHover')

AccessorFunc(PANEL, 'icon', 'Icon')

AccessorFunc(PANEL, 'outlineColor', 'OutlineColor')

function PANEL:Init()
    self:SetBackgroundColor(theme:GetColor('secondary_dark'))
    self:SetBackgroundColorHover(theme:GetColor('accent'))

    self:SetOutlineColor(theme:GetColor('accent'))

    self.backgroundColor = self._backgroundColor
end

function PANEL:DefaultPaint(w, h)
    draw.RoundedBox(5, 0, 0, w, h, self.outlineColor)
    draw.RoundedBox(4, 1, 1, w - 2, h - 2, self.backgroundColor)

    mvp.utils.DrawIcon(w * .5, h * .5, self:GetIcon(), h - 8, theme:GetColor('white'))
    
    return true 
end

function PANEL:OnCursorEntered()
    self:LerpColor('backgroundColor', self.backgroundColorHover, .2)
end

function PANEL:OnCursorExited()
    self:LerpColor('backgroundColor', self._backgroundColor, .2)
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)
    return true 
end

function PANEL:PerformLayout(w, h)
    self:SetWide(h)
end

mvp.ui.Register('mvp.IconButton', PANEL, 'DButton')