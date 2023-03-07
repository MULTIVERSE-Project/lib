--- Default menu panel. This is a DScrollPanel with some extra functionality.
-- @panel mvp.Menu

local PANEL = {}

--- Sets maximum height of the menu.
-- @function SetMaxHeight
-- @realm client
-- @number height The maximum height of the menu.

--- Gets maximum height of the menu.
-- @function GetMaxHeight
-- @realm client
-- @treturn number The maximum height of the menu.
AccessorFunc( PANEL, "_maxHeight", "MaxHeight", FORCE_NUMBER )

--- Sets minimum width of the menu.
-- @function SetMinimumWidth
-- @realm client
-- @number width The minimum width of the menu.

--- Gets minimum width of the menu.
-- @function GetMinimumWidth
-- @realm client
-- @treturn number The minimum width of the menu.
AccessorFunc( PANEL, "_minWidth", "MinimumWidth" )

function PANEL:Init()
    self:SetIsMenu( true )

    self:SetMinimumWidth( 100 )
    self:SetMaxHeight( ScrH() * 0.9 )

    self:SetDrawOnTop( true )

    RegisterDermaMenuForClose( self )

    self._startColor = Color(29, 29, 29)
    self._endColor = Color(36, 36, 36)
end

--- Adds a panel to the menu.
-- @realm client
-- @internal
-- @tparam Panel pnl The panel to add.
function PANEL:AddPanel(pnl)
    self:AddItem(pnl)
    pnl._menu = self
end

--- Adds a string option to the menu.
-- @realm client
-- @tparam string text The text of the option.
-- @tparam[opt] any data The data of the option.
-- @tparam[opt] function click The click callback of the option.
-- @treturn Panel The created panel.
-- @see mvp.MenuItemString
function PANEL:AddStringOption(text, data, click)
    local pnl = vgui.Create("mvp.MenuItemString", self)
    pnl:SetMenu(self)
    pnl:SetText(text)
    pnl:SetData(data)

    if click then
        pnl.DoClick = click
    end

    self:AddPanel(pnl)

    return pnl
end

--- Adds a player option to the menu.
-- @realm client
-- @tparam Player player The player of the option.
-- @tparam[opt] any data The data of the option.
-- @tparam[opt] function click The click callback of the option.
-- @treturn Panel The created panel.
-- @see mvp.MenuItemPlayer
function PANEL:AddPlayerOption(player, data, click)
    local pnl = vgui.Create("mvp.MenuItemPlayer", self)
    pnl:SetMenu(self)
    pnl:SetPlayer(player or LocalPlayer())
    pnl:SetData(data)

    if click then
        pnl.DoClick = click
    end

    self:AddPanel(pnl)

    return pnl
end

function PANEL:Paint(w, h)
    -- x, y, w, h, r, startColor, endColor
    mvp.ui.DrawRoundedBoxGradient(8, 0, 0, w, h, self._startColor, self._endColor)
end

function PANEL:PerformLayout(w, h)
    local w = self:GetMinimumWidth()

    for k, pnl in ipairs(self:GetCanvas():GetChildren()) do
        pnl:InvalidateLayout(true)
        
        w = math.max(w, pnl:GetWide())
    end

    self:SetWide(w)

    local y = 8

    for k, pnl in ipairs(self:GetCanvas():GetChildren()) do
        pnl:SetPos(0, y)
        pnl:SetWide(w)

        y = y + pnl:GetTall()
    end

    self:SetTall(math.min(y + 8, self:GetMaxHeight()))
end

--- Opens the menu.
-- If x and y are not specified, the menu will be opened at the mouse position.
-- @realm client
-- @tparam[opt] number x The x position of the menu.
-- @tparam[opt] number y The y position of the menu.
function PANEL:Open(x, y)
    RegisterDermaMenuForClose( self )

    local manual = x and y

    x = x or gui.MouseX()
    y = y or gui.MouseY()

    self:InvalidateLayout(true)

    local w, h = self:GetSize()

    if ( y + h > ScrH() ) then
        y = manual and y - h or ScrH() - h
    end

    if ( x + w > ScrW() ) then
        x = manual and x - w or ScrW() - w
    end

    if ( x < 1 ) then x = 1 end
    if ( y < 1 ) then y = 1 end

    local p = self:GetParent()
    if ( IsValid(p) and p:IsModal() ) then
        x, y = p:ScreenToLocal( x, y )

        if ( y + h > p:GetTall() ) then
            y = p:GetTall() - h
        end

        if ( x + w > p:GetWide() ) then
            x = p:GetWide() - w
        end

        if ( x < 1 ) then x = 1 end
        if ( y < 1 ) then y = 1 end

        self:SetPos( x, y )
    else
        self:SetPos( x, y )
        self:MakePopup()
    end

    self:SetVisible( true )
    self:SetKeyboardInputEnabled( false )
end

--- Closes the menu.
-- @realm client
function PANEL:Close()
    self:Remove()
end

function PANEL:OptionSelectedInternal( option )
    print("OptionSelectedInternal")
    self:OptionSelected( option, option:GetText(), option:GetData() )
end

--- Called when an option is selected.
-- @realm client
-- @tparam Panel option The selected option.
-- @tparam string text The text of the selected option.
-- @tparam any data The data of the selected option.
function PANEL:OptionSelected(option, text, data)
    -- Override me
end

derma.DefineControl( "mvp.Menu", "", PANEL, "DScrollPanel" )