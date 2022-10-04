local PANEL = {}

local theme = mvp.themes.GetActive()

function PANEL:Init()
    self.backgroundColor = theme:GetColor('secondary_dark')
    self.iconWidth = 0
end

function PANEL:PaintDefault(w, h)
    draw.RoundedBox(5, 0, 0, w, h, theme:GetColor('accent'))
    draw.RoundedBox(4, 1, 1, w-2, h-2, self.backgroundColor)

    local x, y = self:LocalToScreen(0, 0)

    render.SetScissorRect(x, y, x + self.iconWidth,  y + 22, true )
        mvp.utils.DrawIcon(w * .5, h * .5, 'check', h - 5, theme:GetColor('primary_text'))
    render.SetScissorRect(0, 0, 0, 0, false )
end

function PANEL:OnChange(value)
    self:LerpColor('backgroundColor', value and theme:GetColor('accent') or theme:GetColor('secondary_dark'), .3)
    self:Lerp('iconWidth', value and self:GetWide() or 0, .3)
end

function PANEL:OnCursorEntered()
    self:LerpColor('backgroundColor', ColorAlpha(theme:GetColor('secondary_dark'), 125), .3)
end

function PANEL:OnCursorExited()
    self:LerpColor('backgroundColor', self:GetChecked() and theme:GetColor('accent') or theme:GetColor('secondary_dark'), .3)
end

function PANEL:Paint(w, h)
    self:PaintDefault(w, h)
end

function PANEL:PerformLayout(w, h)
    self:Lerp('iconWidth', self:GetChecked() and w or 0, .3)
end

mvp.ui.Register('mvp.Checkbox', PANEL, 'DCheckBox')