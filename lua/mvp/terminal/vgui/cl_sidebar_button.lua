--- Button for sidebar menu.
-- This is a button for the sidebar menu. It inherits from @{mvp.Button}, except icons function differently.
-- @panel mvp.SidebarButton

local PANEL = {}

--- Sets the icon of the button
-- @function SetIcon
-- @realm client
-- @string icon Icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery) (e.g. "f00d" for the trash icon)

--- Gets the icon of the button
-- @function GetIcon
-- @realm client
-- @treturn string Icon unicode
AccessorFunc(PANEL, "_icon", "Icon")

--- Sets whether the button is active
-- @function SetActive
-- @realm client
-- @internal
-- @bool active Whether the button is active

--- Gets whether the button is active
-- @function GetActive
-- @realm client
-- @treturn bool Whether the button is active
AccessorFunc(PANEL, "_active", "Active")

local gradientTexture = surface.GetTextureID("gui/gradient")

function PANEL:Init()
    self:SetTall(mvp.ui.Scale(50))
    
    self._gradientWidth = 0
    self._alphaMult = 0
    self._active = false

    self._startColor = Color(74, 74, 74)
    self._endColor = Color(62, 62, 62)
end

function PANEL:Think()
    if (self:IsHovered() or self._active) then
        self._gradientWidth = Lerp(FrameTime() * 10, self._gradientWidth, self:GetWide() - mvp.ui.Scale(65))
        self._alphaMult = Lerp(FrameTime() * 10, self._alphaMult, 1)
    else
        self._gradientWidth = Lerp(FrameTime() * 10, self._gradientWidth, 0)
        self._alphaMult = Lerp(FrameTime() * 10, self._alphaMult, 0)
    end

    if self._active then
        self._startColor = mvp.utils.LerpColor(FrameTime() * 10, self._startColor, Color(244, 144, 12))
        self._endColor = mvp.utils.LerpColor(FrameTime() * 10, self._endColor, Color(255, 192, 92))
    else
        self._startColor = mvp.utils.LerpColor(FrameTime() * 10, self._startColor, Color(74, 74, 74))
        self._endColor = mvp.utils.LerpColor(FrameTime() * 10, self._endColor, Color(62, 62, 62))
    end
end

function PANEL:Paint(w, h)
    surface.SetAlphaMultiplier(self._alphaMult)
    mvp.ui.gradients.DrawGradient(0, 0, mvp.ui.Scale(65), h, 0, self._startColor, self._endColor)
    surface.SetAlphaMultiplier(1)

    mvp.ui.DrawIcon(mvp.ui.Scale(65) * .5, h * .5, self._icon, mvp.ui.Scale(32), color_white)

    surface.SetAlphaMultiplier(self._alphaMult)

    draw.NoTexture()
    surface.SetTexture(gradientTexture)
    surface.SetDrawColor(ColorAlpha(self._endColor, 100))

    surface.DrawTexturedRect(mvp.ui.Scale(65), 0, self._gradientWidth, h)

    surface.SetAlphaMultiplier(1)

    draw.SimpleText(self._text, mvp.Font(22), mvp.ui.Scale(65) + 10, h * .5, self._active and Color(255, 255, 255) or Color(185, 185, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    return true
end

vgui.Register("mvp.SidebarButton", PANEL, "mvp.Button")

--- Button for sidebar menu that represents a close button.
-- @inherits mvp.SidebarButton
-- @panel mvp.SidebarCloseButton
PANEL = {}

function PANEL:Init()
    self:SetTall(mvp.ui.Scale(50))
    
    self._gradientWidth = 0
    self._alphaMult = 0

    self._startColor = Color(255, 68, 68)
    self._endColor = Color(130, 34, 34)

    self._icon = "f00d"
end

function PANEL:Think()
    if (self:IsHovered()) then
        self._gradientWidth = Lerp(FrameTime() * 10, self._gradientWidth, self:GetWide() - mvp.ui.Scale(65))
        self._alphaMult = Lerp(FrameTime() * 10, self._alphaMult, 1)
    else
        self._gradientWidth = Lerp(FrameTime() * 10, self._gradientWidth, 0)
        self._alphaMult = Lerp(FrameTime() * 10, self._alphaMult, 0)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(7, 0, 0, 14, h, Color(255, 68, 68, 255 * self._alphaMult), false, false, true, false)
    
    surface.SetAlphaMultiplier(self._alphaMult)
    mvp.ui.gradients.DrawGradient(14, 0, mvp.ui.Scale(65) - 14, h, 0, self._startColor, self._endColor)
    surface.SetAlphaMultiplier(1)

    mvp.ui.DrawIcon(mvp.ui.Scale(65) * .5, h * .5, self._icon, mvp.ui.Scale(32), color_white)

    surface.SetAlphaMultiplier(self._alphaMult)

    draw.NoTexture()
    surface.SetTexture(gradientTexture)
    surface.SetDrawColor(ColorAlpha(self._endColor, 100))

    surface.DrawTexturedRect(mvp.ui.Scale(65), 0, self._gradientWidth, h)

    surface.SetAlphaMultiplier(1)

    draw.SimpleText(self._text, mvp.Font(22), mvp.ui.Scale(65) + 10, h * .5, self._active and Color(255, 255, 255) or Color(185, 185, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    return true
end

vgui.Register("mvp.SidebarButtonClose", PANEL, "mvp.Button")