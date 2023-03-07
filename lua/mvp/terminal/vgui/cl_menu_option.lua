--- This is the base panel for all options, you can use this to create your own custom options.
-- @panel mvp.MenuItem
-- @inherits mvp.Button
local PANEL = {}

--- Sets the menu that this option is in.
-- @function SetMenu
-- @realm client
-- @internal
-- @tparam Panel menu

--- Gets the menu that this option is in.
-- @function GetMenu
-- @realm client
-- @internal
-- @treturn Panel
AccessorFunc(PANEL, "_menu", "Menu")

--- Sets the function that is called when this option is clicked.
-- @function SetOnClick
-- @realm client
-- @tparam function func

--- Gets the function that is called when this option is clicked.
-- @function GetOnClick
-- @realm client
-- @treturn function
AccessorFunc(PANEL, "_doClick", "Click")

--- Sets the data that is passed to the function that is called when this option is clicked.
-- @function SetData
-- @realm client
-- @tparam any data

--- Gets the data that is passed to the function that is called when this option is clicked.
-- @function GetData
-- @realm client
-- @treturn any
AccessorFunc(PANEL, "_data", "Data")

DEFINE_BASECLASS("mvp.Button")

function PANEL:Init()
    self._startColor = Color(29, 29, 29)
    self._endColor = Color(36, 36, 36)

    self.startColor = self._startColor
    self.endColor = self._endColor
    self.startColorHovered = Color(185, 109, 10)
    self.endColorHovered = Color(112, 69, 0)
    self.startColorFlash = Color(255, 145, 0)
    self.endColorFlash = Color(216, 133, 0)
end

function PANEL:DoClickInternal()
    BaseClass.DoClickInternal(self)

    if self._menu then
        self._menu:OptionSelectedInternal(self)
        self._menu:Remove()
    end

    if self._doClick then
        self._doClick(self, self._data)
    end
end

--- Gets the text that is displayed when this option selected in @{mvp.Menu}.
-- 
-- Used by @{mvp.Menu} to display the selected option. You should override this function to return the text that should be displayed.
-- @realm client
-- @treturn string
function PANEL:GetDisplayText()
    return error("GetDisplayText not implemented")
end

vgui.Register("mvp.MenuItem", PANEL, "mvp.Button")


--- This is string based option, for use with @{mvp.Menu}, displays a plain string with no custom behavior.
-- @panel mvp.MenuItemString
-- @inherits mvp.MenuItem
local PANEL = {}

--- Sets option text.
-- @function SetText
-- @realm client
-- @tparam string text

--- Gets option text.
-- @function GetText
-- @realm client
-- @treturn string
AccessorFunc(PANEL, "_text", "Text")

--- Sets option icon.
-- @function SetIcon
-- @realm client
-- @tparam string icon

--- Gets option icon.
-- @function GetIcon
-- @realm client
-- @treturn string
AccessorFunc(PANEL, "_icon", "Icon")

--- Sets option text alignment.
-- @function SetAlign
-- @realm client
-- @tparam number align
AccessorFunc(PANEL, "_align", "Align", FORCE_NUMBER)

function PANEL:Init()
    self:SetAlign(TEXT_ALIGN_LEFT)
end

--- Gets the text that is displayed when this option selected in @{mvp.Menu}.
-- Returns the text set with @{SetText}.
-- @realm client
-- @treturn string
-- @see SetText
function PANEL:GetDisplayText()
    return self._text
end

function PANEL:Paint(w, h)
    mvp.ui.DrawRoundedBoxGradient(0, 0, 0, w, h, self._startColor, self._endColor)

    surface.SetFont(mvp.Font(21))
    local tw, _th = surface.GetTextSize(self._text)

    local totalWidth = tw

    local iconInfo 
    local iconW = 0
    if self._icon then
        iconInfo = mvp.ui.GetIcon(self._icon, 18)

        surface.SetFont(iconInfo.font)
        iconW = surface.GetTextSize(iconInfo.text)

        totalWidth = totalWidth + iconW + mvp.ui.Scale(8)
    end

    local x = (w - totalWidth) * .5 

    if self._align == TEXT_ALIGN_LEFT then
        x = mvp.ui.Scale(8) * 2
    end
    if self._align == TEXT_ALIGN_RIGHT then
        x = w - totalWidth - mvp.ui.Scale(8) * 2
    end

    if self._icon then
        mvp.ui.DrawIconExt(x, h * .5, self._icon, 18, Color(255, 255, 255), nil, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        x = x + iconW + mvp.ui.Scale(8) 
    end

    draw.SimpleText(self._text, mvp.Font(21), x, h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    return true
end

function PANEL:PerformLayout(w, h)
    -- self:SetTall(math.max(h, mvp.ui.Scale(32)))

    surface.SetFont(mvp.Font(21))
    local tw, _th = surface.GetTextSize(self._text)

    local totalWidth = tw

    local iconInfo 
    local iconW = 0
    if self._icon then
        iconInfo = mvp.ui.GetIcon(self._icon, 18)

        surface.SetFont(iconInfo.font)
        iconW = surface.GetTextSize(iconInfo.text)

        totalWidth = totalWidth + iconW + mvp.ui.Scale(8)
    end

    -- self:SetWide(math.max(w, totalWidth + mvp.ui.Scale(32)))

    self:SetSize(math.max(w, totalWidth + mvp.ui.Scale(32)), math.max(h, mvp.ui.Scale(32)))
end

vgui.Register("mvp.MenuItemString", PANEL, "mvp.MenuItem")

--- This is a player based option, for use with @{mvp.Menu}, displays a player avatar, name and steamid64.
-- @panel mvp.MenuItemPlayer
-- @inherits mvp.MenuItem

local PANEL = {}

--- Sets the player name. You should use @{SetPlayer} or @{SetSteamID}.
-- @function SetPlayerName
-- @realm client
-- @internal
-- @tparam string name

--- Gets the player name.
-- @function GetPlayerName
-- @realm client
-- @treturn string
AccessorFunc(PANEL, "_playerName", "PlayerName")

--- Sets the player steamid64. You should use @{SetPlayer} or @{SetSteamID}.
-- @function SetPlayerSteamID
-- @realm client
-- @internal
-- @tparam string steamid

--- Gets the player steamid64.
-- @function GetPlayerSteamID
-- @realm client
-- @treturn string
AccessorFunc(PANEL, "_playerSteamID", "PlayerSteamID")

function PANEL:Init()
    self._avatar = vgui.Create("AvatarImage", self)
    self._avatar:SetPlayer(LocalPlayer(), 64)
    self._avatar:SetMouseInputEnabled(false)

    self._playerName = "Unknown"
    self._playerSteamID = "Unknown"
end

--- Gets the text that is displayed when this option selected in @{mvp.Menu}. This is the player name.
-- @realm client
-- @treturn string
function PANEL:GetDisplayText()
    return self._playerName
end

function PANEL:PerformLayout(w, h)
    surface.SetFont(mvp.Font(26))
    local textW = surface.GetTextSize(self._playerName)
    self:SetSize(math.max(w, h + mvp.ui.Scale(8) + textW + mvp.ui.Scale(8) + mvp.ui.Scale(150)), math.max(h, mvp.ui.Scale(64)))

    self._avatar:SetSize(math.max(h, mvp.ui.Scale(32)), math.max(h, mvp.ui.Scale(32)))
    self._avatar:SetPos(0, 0)

    self._avatar:SetSteamID(self._playerSteamID, 64)
end

--- Sets the player to display.
-- @realm client
-- @tparam Player ply
-- @tparam number size The size of the avatar
function PANEL:SetPlayer(ply, size)
    self._playerName = ply:Nick()
    self._playerSteamID = ply:SteamID64()

    self._avatar:SetPlayer(ply, size)
end

--- Sets the player to display by steamid64. This will request the player name from steam automatically.
-- @realm client
-- @tparam string steamid64
-- @tparam number size The size of the avatar
function PANEL:SetSteamID(steamid64, size)
    self._playerName = "Unknown"
    self._playerSteamID = steamid64

    self._avatar:SetSteamID(steamid64, size)

    steamworks.RequestPlayerInfo( steamid64, function( steamName )
        self._playerName = steamName
    end )
end

function PANEL:Paint(w, h)
    mvp.ui.DrawRoundedBoxGradient(0, 0, 0, w, h, self._startColor, self._endColor)

    -- x, y, topText, topFont, topColor, bottomText, bottomFont, bottomColor, alignment, centerSpacing
    mvp.ui.DrawDualText(h + mvp.ui.Scale(8), h * .5, self._playerName, mvp.Font(26), Color(255, 255, 255), self._playerSteamID, mvp.Font(18), Color(124, 124, 124), TEXT_ALIGN_LEFT)

    -- draw.SimpleText(self._text, mvp.Font(26), h + mvp.ui.Scale(8), h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    return true
end

vgui.Register("mvp.MenuItemPlayer", PANEL, "mvp.MenuItem")