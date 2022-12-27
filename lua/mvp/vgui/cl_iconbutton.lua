--- Button with ability to render FontAwesome icons with text.
-- Test
-- @panel mvp.IconButton
local theme = mvp.themes.GetActive()
local PANEL = {}


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
    self:SetBackgroundColor(mvp.Color(secondary_dark))
    self:SetBackgroundColorHover(mvp.Color(accent))

    self:SetOutlineColor(mvp.Color(accent))

    self.backgroundColor = self._backgroundColor
end

function PANEL:DefaultPaint(w, h)

    if not self:GetNoDrawOutline() then
        draw.RoundedBox(self:GetBorderRadius() + 1, 0, 0, w, h, self:GetOutlineColor())
    end 

    draw.RoundedBox(self:GetBorderRadius(), self:GetNoDrawOutline() and 0 or 1, self:GetNoDrawOutline() and 0 or 1, w - (self:GetNoDrawOutline() and 0 or 2), h - (self:GetNoDrawOutline() and 0 or 2), self.backgroundCurrentColor)

    mvp.utils.DrawIcon(w * .5, h * .5, self:GetIcon(), h * .75, mvp.Color(white))
    
    return true 
end

function PANEL:PerformLayout(w, h)
    self:SetWide(h)
end

mvp.ui.Register('mvp.IconButton', PANEL, 'mvp.Button')