local theme = mvp.themes.GetActive()
local PANEL = {}

--- Button with ability to render FontAwesome icons with text.
-- @panel mvp.IconButton

--- Sets background color.
-- @function SetBackgroundColor
-- @realm client
-- @tparam Color color Color to be set as background color.
AccessorFunc(PANEL, '_backgroundColor', 'BackgroundColor')

--- Sets background color when button is hovered. 
-- @function SetBackgroundColorHovered
-- @realm client
-- @tparam Color color Color to be set as background color when button is hovered.
AccessorFunc(PANEL, 'backgroundColorHover', 'BackgroundColorHover')

--- Sets the icon to be rendered.
-- @function SetIcon
-- @realm client
-- @tparam string icon The icon to be rendered.

--- Gets the icon to be rendered.
-- @realm client
-- @function GetIcon
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