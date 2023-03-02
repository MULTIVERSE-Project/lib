--- Icon container, that can be used to display an icon with a background color of a certain style.
-- @panel mvp.IconContainer

local PANEL = {}

--- Icon container styles.
-- @table IconContainerStyles
-- @realm client
-- @field primary Primary style.
-- @field green Green style.
-- @field red Red style.
-- @field info Info style.
-- @field white White style.
local styles = {
    ["primary"] = Color(255, 192, 92, 255 * .5),
    ["green"] = Color(120, 177, 89, 255 * .5),
    ["red"] = Color(255, 68, 68, 255 * .5),
    ["info"] = Color(92, 177, 255, 255 * .5),
    ["white"] = Color(255, 255, 255, 255 * .3),
}

--- Sets the icon for the icon container.
-- @function SetIcon
-- @realm client
-- @string icon The icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery). 

--- Gets the icon for the icon container.
-- @function GetIcon
-- @realm client
-- @treturn string The icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery).
AccessorFunc(PANEL, "_icon", "Icon")

--- Sets the background color for the icon container.
-- @function SetBackgroundColor
-- @internal
-- @realm client
-- @tparam Color color The background color.

--- Gets the background color for the icon container.
-- @function GetBackgroundColor
-- @internal
-- @realm client
-- @treturn Color The background color.
AccessorFunc(PANEL, "_backgroundColor", "BackgroundColor")

function PANEL:Init()
    self:SetStyle("primary")
    self:SetIcon("e1fe")
end

--- Sets the style for the icon container.
-- @function SetStyle
-- @realm client
-- @tparam IconContainerStyles style The style to set.
function PANEL:SetStyle(style)
    if not styles[style] then
        return error(Format("Style %s is not a valid style for button!"))
    end

    self:SetBackgroundColor(styles[style])
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self._backgroundColor)

    mvp.ui.DrawIcon(w * .5, h * .5, self._icon, h * .8, color_white)
end

vgui.Register("mvp.IconContainer", PANEL, "EditablePanel")