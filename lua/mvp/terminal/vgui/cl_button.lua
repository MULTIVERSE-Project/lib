--- Alternative to default DButton.
-- When activated, the "mvp.Button" panel is design to display text or an icon indicating its function. 
-- The panel also have additional customizable features, such as the ability to change its color or size. 
-- Additionally, the panel may be programmed to respond to different types of user interactions, such as a single click or a double-click, depending on the requirements of the script.
-- @panel mvp.Button
local PANEL = {}

--- Sets the text of the button.
-- @function SetText
-- @realm client
-- @string text The text to set.

--- Gets the text of the button.
-- @function GetText
-- @realm client
-- @treturn string The text of the button.
AccessorFunc(PANEL, "_text", "Text", FORCE_STRING)

--- Set the function to call when the button is clicked.
-- @function SetClick
-- @realm client
-- @tparam function func The function to call.

--- Gets the function to call when the button is clicked.
-- @function GetClick
-- @realm client
-- @treturn function The function to call.
AccessorFunc(PANEL, "_clickFunc", "Click")

--- Sets the left icon of the button.
-- @function SetLeftIcon
-- @realm client
-- @string icon The icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery) to set.

--- Gets the left icon of the button.
-- @function GetLeftIcon
-- @realm client
-- @treturn string The left icon unicode of the button.
AccessorFunc(PANEL, "_leftIcon", "LeftIcon")

--- Sets the right icon of the button.
-- @function SetRightIcon
-- @realm client
-- @string icon The icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery) to set.

--- Gets the right icon of the button.
-- @function GetRightIcon
-- @realm client
-- @treturn string The right icon unicode of the button.
AccessorFunc(PANEL, "_rightIcon", "RightIcon")

--- Button styles
-- @realm client
-- @table ButtonStyles
-- @field primary Primary button style
-- @field secondary Secondary button style
-- @field red Red button style
-- @field green Green button style
-- @field steam Steam button style
-- @field discord Discord button style
local styles = {
    ["primary"] = {
        startColor = Color(244, 144, 12),
        endColor = Color(161, 100, 0),
        startColorHovered = Color(185, 109, 10),
        endColorHovered = Color(112, 69, 0),
        startColorFlash = Color(255, 145, 0),
        endColorFlash = Color(216, 133, 0),
    },
    ["secondary"] = {
        startColor = Color(94, 94, 94),
        endColor = Color(62, 62, 62),
        startColorHovered = Color(78, 78, 78),
        endColorHovered = Color(53, 53, 53),
        startColorFlash = Color(131, 131, 131),
        endColorFlash = Color(104, 104, 104),
    },
    ["red"] = {
        startColor = Color(255, 68, 68),
        endColor = Color(130, 34, 34),
        startColorHovered = Color(190, 49, 49),
        endColorHovered = Color(80, 21, 21),
        startColorFlash = Color(255, 81, 81),
        endColorFlash = Color(179, 0, 0),
    },
    ["green"] = {
        startColor = Color(120, 177, 89),
        endColor = Color(65, 101, 46),
        startColorHovered = Color(81, 119, 60),
        endColorHovered = Color(36, 56, 26),
        startColorFlash = Color(149, 255, 92),
        endColorFlash = Color(72, 156, 26),
    },
    ["steam"] = {
        startColor = Color(23, 26, 33),
        endColor = Color(27, 40, 56),
        startColorHovered = Color(33, 37, 48),
        endColorHovered = Color(34, 51, 71),
        startColorFlash = Color(23, 26, 33),
        endColorFlash = Color(27, 40, 56),
    },
    ["discord"] = {
        startColor = Color(65, 79, 128),
        endColor = Color(114, 137, 218),
        startColorHovered = Color(52, 63, 102),
        endColorHovered = Color(99, 118, 187),
        startColorFlash = Color(65, 79, 128),
        endColorFlash = Color(114, 137, 218),
    }

}

function PANEL:Init()
    self.style = "primary"

    self._startColor = Color(244, 144, 12)
    self._endColor = Color(161, 100, 0)

    self._text = "Label"
end

--- Sets the style of the button.
-- @realm client
-- @tparam string style The style to set. See @{ButtonStyles} for a list of available styles.
function PANEL:SetStyle(style)
    if not styles[style] then
        return error(Format("Style %s is not a valid style for button!"))
    end

    self.style = style

    self.startColor = styles[style].startColor
    self.endColor = styles[style].endColor
    self.startColorHovered = styles[style].startColorHovered
    self.endColorHovered = styles[style].endColorHovered

    self.startColorFlash = styles[style].startColorFlash
    self.endColorFlash = styles[style].endColorFlash

    self._startColor = styles[style].startColor
    self._endColor = styles[style].endColor
end

function PANEL:Think()
    if self:IsHovered() then
        self._startColor = mvp.utils.LerpColor(FrameTime() * 5, self._startColor, self.startColorHovered)
        self._endColor = mvp.utils.LerpColor(FrameTime() * 5, self._endColor, self.endColorHovered)
    else
        self._startColor = mvp.utils.LerpColor(FrameTime() * 5, self._startColor, self.startColor)
        self._endColor = mvp.utils.LerpColor(FrameTime() * 5,self._endColor, self.endColor)
    end
end

function PANEL:OnCursorEntered()
    mvp.ui.Sound("hover")
end

function PANEL:DoClickInternal()
    mvp.ui.Sound("click")

    if self.startColorFlash and self.endColorFlash then
        self._startColor = self.startColorFlash
        self._endColor = self.endColorFlash
    end
end

function PANEL:Paint(w, h)
    mvp.ui.DrawRoundedBoxGradient(8, 0, 0, w, h, self._startColor, self._endColor)

    surface.SetFont(mvp.Font(21))
    local tw, _th = surface.GetTextSize(self._text)

    local totalW = tw

    local leftIconInfo
    local rightIconInfo

    local leftIconW, rightIconW

    if self._leftIcon then
        leftIconInfo = mvp.ui.GetIcon(self._leftIcon, mvp.ui.Scale(18))

        surface.SetFont(leftIconInfo.font)
        leftIconW = surface.GetTextSize(leftIconInfo.text)

        totalW = totalW + leftIconW + mvp.ui.Scale(8)
    end

    if self._rightIcon then
        rightIconInfo = mvp.ui.GetIcon(self._rightIcon, mvp.ui.Scale(18))

        surface.SetFont(rightIconInfo.font)
        rightIconW = surface.GetTextSize(rightIconInfo.text)

        totalW = totalW + rightIconW + mvp.ui.Scale(8)
    end

    local x = (w - totalW) * .5 

    if self._leftIcon then
        draw.SimpleText(leftIconInfo.text, leftIconInfo.font, x, h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(self._text, mvp.Font(21), x + (leftIconW and (leftIconW + mvp.ui.Scale(8)) or 0), h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if self._rightIcon then
        draw.SimpleText(rightIconInfo.text, rightIconInfo.font, x + (leftIconW and (leftIconW + mvp.ui.Scale(8)) or 0) + tw + mvp.ui.Scale(8), h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return true
end

vgui.Register("mvp.Button", PANEL, "DButton")

--- Dual text version of @{mvp.Button}.
-- @panel mvp.DualTextButton
-- @inherits mvp.Button

--- Button styles
-- @realm client
-- @table ButtonStyles
-- @field primary Primary button style
-- @field secondary Secondary button style
-- @field red Red button style
-- @field green Green button style
-- @field steam Steam button style
-- @field discord Discord button style

local PANEL = {}

--- Sets the top text of the button.
-- @realm client
-- @function SetTopText
-- @tparam string text The text to set.

--- Gets the top text of the button.
-- @realm client
-- @function GetTopText
-- @treturn string The top text of the button.
AccessorFunc(PANEL, "_topText", "TopText", FORCE_STRING)

--- Sets the bottom text of the button.
-- @realm client
-- @function SetBottomText
-- @tparam string text The text to set.

--- Gets the bottom text of the button.
-- @realm client
-- @function GetBottomText
-- @treturn string The bottom text of the button.
AccessorFunc(PANEL, "_bottomText", "BottomText", FORCE_STRING)

--- Sets the text alignment of the button.
-- @realm client
-- @function SetTextAlign
-- @tparam number align The text alignment to set. See [TEXT_ALIGN Enums](https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN) for a list of available alignments.

--- Gets the text alignment of the button.
-- @realm client
-- @function GetTextAlign
-- @treturn number The text alignment of the button.
AccessorFunc(PANEL, "_textAlignment", "TextAlign")

--- Set the function to call when the button is clicked.
-- @function SetClick
-- @realm client
-- @tparam function func The function to call.

--- Gets the function to call when the button is clicked.
-- @function GetClick
-- @realm client
-- @treturn function The function to call.
AccessorFunc(PANEL, "_clickFunc", "Click")

--- Sets the left icon of the button.
-- @function SetLeftIcon
-- @realm client
-- @string icon The icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery) to set.

--- Gets the left icon of the button.
-- @function GetLeftIcon
-- @realm client
-- @treturn string The left icon unicode of the button.
AccessorFunc(PANEL, "_leftIcon", "LeftIcon")

--- Sets the right icon of the button.
-- @function SetRightIcon
-- @realm client
-- @string icon The icon unicode from [Font Awesome](https://fontawesome.com/icons?d=gallery) to set.

--- Gets the right icon of the button.
-- @function GetRightIcon
-- @realm client
-- @treturn string The right icon unicode of the button.
AccessorFunc(PANEL, "_rightIcon", "RightIcon")

function PANEL:Init()
    self.style = "primary"

    self._startColor = Color(244, 144, 12)
    self._endColor = Color(161, 100, 0)

    self._text = "Label"
end

--- Sets the style of the button.
-- @realm client
-- @tparam string style The style to set. See @{ButtonStyles} for a list of available styles.
function PANEL:SetStyle(style)
    if not styles[style] then
        return error(Format("Style %s is not a valid style for button!"))
    end

    self.style = style

    self.startColor = styles[style].startColor
    self.endColor = styles[style].endColor
    self.startColorHovered = styles[style].startColorHovered
    self.endColorHovered = styles[style].endColorHovered

    self.startColorFlash = styles[style].startColorFlash
    self.endColorFlash = styles[style].endColorFlash

    self._startColor = styles[style].startColor
    self._endColor = styles[style].endColor
end

function PANEL:Think()
    if self:IsHovered() then
        self._startColor = mvp.utils.LerpColor(FrameTime() * 5, self._startColor, self.startColorHovered)
        self._endColor = mvp.utils.LerpColor(FrameTime() * 5, self._endColor, self.endColorHovered)
    else
        self._startColor = mvp.utils.LerpColor(FrameTime() * 5, self._startColor, self.startColor)
        self._endColor = mvp.utils.LerpColor(FrameTime() * 5,self._endColor, self.endColor)
    end
end

function PANEL:OnCursorEntered()
    mvp.ui.Sound("hover")
end

function PANEL:DoClickInternal()
    mvp.ui.Sound("click")

    if self.startColorFlash and self.endColorFlash then
        self._startColor = self.startColorFlash
        self._endColor = self.endColorFlash
    end
end

function PANEL:Paint(w, h)
    mvp.ui.DrawRoundedBoxGradient(8, 0, 0, w, h, self._startColor, self._endColor)

    surface.SetFont(mvp.Font(20))
    local topTW, _th = surface.GetTextSize(self._topText)
    
    surface.SetFont(mvp.Font(15))
    local bottomTW, _th = surface.GetTextSize(self._topText)

    local tw = math.max(topTW, bottomTW)

    local totalW = tw

    local leftIconInfo
    local rightIconInfo

    local leftIconW, rightIconW

    if self._leftIcon then
        leftIconInfo = mvp.ui.GetIcon(self._leftIcon, mvp.ui.Scale(30))

        surface.SetFont(leftIconInfo.font)
        leftIconW = surface.GetTextSize(leftIconInfo.text)

        totalW = totalW + leftIconW + mvp.ui.Scale(8)
    end

    if self._rightIcon then
        rightIconInfo = mvp.ui.GetIcon(self._rightIcon, mvp.ui.Scale(30))

        surface.SetFont(rightIconInfo.font)
        rightIconW = surface.GetTextSize(rightIconInfo.text)

        totalW = totalW + rightIconW + mvp.ui.Scale(8)
    end

    local x = (w - totalW) * .5

    if self._textAlignment == TEXT_ALIGN_RIGHT then
        x = w - mvp.ui.Scale(8)
    end

    if self._textAlignment == TEXT_ALIGN_LEFT then
        x = mvp.ui.Scale(15)
    end

    if self._leftIcon then
        draw.SimpleText(leftIconInfo.text, leftIconInfo.font, x, h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- mvp.ui.DrawDualText(x, y, topText, topFont, topColor, bottomText, bottomFont, bottomColor, alignment, centerSpacing)
    mvp.ui.DrawDualText(x + (leftIconW and (leftIconW + mvp.ui.Scale(8)) or 0), h * .5, self._topText, mvp.Font(20, 700), Color(255, 255, 255),  self._bottomText, mvp.Font(15), Color(255, 255, 255), TEXT_ALIGN_LEFT)

    if self._rightIcon then
        draw.SimpleText(rightIconInfo.text, rightIconInfo.font, x + (leftIconW and (leftIconW + mvp.ui.Scale(8)) or 0) + tw + mvp.ui.Scale(8), h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return true
end

vgui.Register("mvp.DualTextButton", PANEL, "DButton")