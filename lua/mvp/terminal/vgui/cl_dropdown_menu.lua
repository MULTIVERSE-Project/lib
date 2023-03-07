--- This is a dropdown menu that can be used to select a player or a string. You can expand its functionality using @{mvp.MenuItem}. Uses @{mvp.Menu} internally.
-- @panel mvp.Dropdown
-- @inherits mvp.Button

local PANEL = {}
DEFINE_BASECLASS("mvp.Button")

--- Sets selected option.
-- @function SetSelected
-- @realm client
-- @internal
-- @tparam number id Option ID

--- Gets selected option.
-- @function GetSelected
-- @realm client
-- @internal
-- @treturn number Option ID
AccessorFunc(PANEL, "_selected", "Selected", FORCE_NUMBER)

function PANEL:Init()
    self:SetRightIcon("f0d7")

    self._options = {}

    self._playerAvatar = vgui.Create("AvatarImage", self)
    self._playerAvatar:SetMouseInputEnabled(false)
    self._playerAvatar:SetVisible(false)
end

function PANEL:Paint(w, h)
    mvp.ui.DrawRoundedBoxGradient(8, 0, 0, w, h, self._startColor, self._endColor)

    local leftIconInfo
    local rightIconInfo

    local leftIconW, rightIconW = 0, 0

    if self._leftIcon then
        leftIconInfo = mvp.ui.GetIcon(self._leftIcon, mvp.ui.Scale(18))

        surface.SetFont(leftIconInfo.font)
        leftIconW = surface.GetTextSize(leftIconInfo.text) + mvp.ui.Scale(8)
    end

    local selectedOptionType = self._options[self._selected] and self._options[self._selected].type

    local x = 0

    if selectedOptionType == "player" then
        x = mvp.ui.Scale(8) * 2 + h
    else
        x = mvp.ui.Scale(8)
    end

    if self._leftIcon then
        draw.SimpleText(leftIconInfo.text, leftIconInfo.font, x, h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(self._text, mvp.Font(21), x + leftIconW, h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if self._rightIcon then
        rightIconInfo = mvp.ui.GetIcon(self._rightIcon, mvp.ui.Scale(18))

        surface.SetFont(rightIconInfo.font)
        rightIconW = surface.GetTextSize(rightIconInfo.text)
    end

    if self._rightIcon then
        draw.SimpleText(rightIconInfo.text, rightIconInfo.font, w - rightIconW - mvp.ui.Scale(8), h * .5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return true
end

--- Opens the @{mvp.Menu} menu and populates it with options.
-- @realm client
function PANEL:OpenMenu()
    if self._menu then
        self._menu:Remove()
        return
    end

    local x, y = self:LocalToScreen(0, self:GetTall())
    
    self._menu = vgui.Create("mvp.Menu")
    self._menu:SetMinimumWidth(self:GetWide())

    self._menu.OptionSelected = function(_, option, text, data)
        self:OptionSelectedInternal(option, data)
    end

    self._menu.OnRemove = function()
        self._menu = nil
    end

    for k, v in ipairs(self._options) do
        if v.type == "string" then
            local option = self._menu:AddStringOption(v.text, k)

            if v.icon then
                option:SetIcon(v.icon)
            end
        elseif v.type == "player" then
            self._menu:AddPlayerOption(v.player, k)
        end
    end

    self._menu:Open(x, y + mvp.ui.Scale(4))
end

function PANEL:DoClick()
    self:OpenMenu()
end

function PANEL:OptionSelectedInternal(option, id)
    if not self._options[id] then return end

    if option.GetIcon and option:GetIcon() ~= "" then
        self:SetLeftIcon(option:GetIcon())
    else
        self:SetLeftIcon("f007")
    end

    self:SetText(option:GetDisplayText())
    self:SetSelected(id)

    local optionInfo = self._options[id]

    if optionInfo.type == "player" then
        if isstring(optionInfo.player) then
            self._playerAvatar:SetSteamID(util.SteamIDTo64(optionInfo.player), 64)
        else
            self._playerAvatar:SetPlayer(optionInfo.player, 64)
        end
        
        self._playerAvatar:SetVisible(true)
    else
        self._playerAvatar:SetVisible(false)
    end

    self:OptionSelected(option, optionInfo.value)
end

--- Override this function to handle option selection.
-- @realm client
-- @tparam panel option Option panel (@{mvp.MenuItem})
-- @tparam any data Option data
function PANEL:OptionSelected(option, data)
    -- Override me
end

--- Adds a string option.
-- @realm client
-- @tparam string text Option text
-- @tparam any data Option data
-- @tparam[opt] string icon Option icon
function PANEL:AddStringOption(text, data, icon)
    local id = #self._options + 1

    self._options[id] = {
        text = text,
        icon = icon,
        value = data,

        type = "string"
    }
end

--- Adds a player option.
-- @realm client
-- @tparam Player ply Player to display
-- @tparam any data Option data
function PANEL:AddPlayerOption(ply, data)
    local id = #self._options + 1

    self._options[id] = {
        player = ply,
        value = data,
        type = "player"
    }
end

function PANEL:PerformLayout(w, h)
    BaseClass.PerformLayout(self, w, h)

    self._playerAvatar:SetSize(h, h)
    self._playerAvatar:SetPos(mvp.ui.Scale(8), 0)
end

vgui.Register("mvp.DropdownMenu", PANEL, "mvp.Button")