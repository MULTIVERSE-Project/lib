local PANEL = {}

function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "mvp.MenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )

	return pnl

end

function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( "DPanel", self )
	pnl.Paint = function( p, w, h )
		derma.SkinHook( "Paint", "MenuSpacer", p, w, h )
	end

	pnl:SetTall( 1 )
	self:AddPanel( pnl )

	return pnl

end

function PANEL:Paint( w, h )

	if ( !self:GetPaintBackground() ) then return end

	-- derma.SkinHook( "Paint", "Menu", self, w, h )
    draw.RoundedBox(0, 0, 0, w, h, Color(75,75,75))
	return true

end

derma.DefineControl( "mvp.Menu", "A Menu", PANEL, "DMenu" )

local PANEL = {}

AccessorFunc( PANEL, "m_pMenu", "Menu" )
AccessorFunc( PANEL, "m_bChecked", "Checked" )
AccessorFunc( PANEL, "m_bCheckable", "IsCheckable" )

function PANEL:Init()

	self:SetTextInset( 32, 0 ) -- Room for icon on left
	self:SetChecked( false )
    
	self:SetTextAligment( TEXT_ALIGN_LEFT )
end

function PANEL:SetSubMenu( menu )

	self.SubMenu = menu

	if ( !IsValid( self.SubMenuArrow ) ) then

		self.SubMenuArrow = vgui.Create( "DPanel", self )
		self.SubMenuArrow.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "MenuRightArrow", panel, w, h ) end

	end

end

function PANEL:AddSubMenu()

	local SubMenu = vgui.Create('mvp.Menu')
	SubMenu:SetVisible( false )
	SubMenu:SetParent( self )

	self:SetSubMenu( SubMenu )

	return SubMenu

end

derma.DefineControl( "mvp.MenuOption", "Menu Option Line", PANEL, "mvp.Button" )