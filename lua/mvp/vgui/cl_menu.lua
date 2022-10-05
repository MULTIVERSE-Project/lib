local PANEL = {}

DEFINE_BASECLASS( 'DMenu' )

function PANEL:Init()
    BaseClass.Init( self )

    self:SetPadding(6)
    self:SetAlpha(0)

    self:AlphaTo(255, 0.2, 0)
end

function PANEL:PerformLayout( w, h )

	local w = self:GetMinimumWidth()

	-- Find the widest one
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do

		pnl:InvalidateLayout( true )
		w = math.max( w, pnl:GetWide() )

	end

	self:SetWide( w )

	local y = self:GetPadding()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do

		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )

		y = y + pnl:GetTall()

	end

	y = math.min( y, self:GetMaxHeight() )

	self:SetTall( y + self:GetPadding() )

	derma.SkinHook( "Layout", "Menu", self )

	DScrollPanel.PerformLayout( self, w, h )

end

function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( 'mvp.MenuOption', self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	self:AddPanel( pnl )
	
	pnl:SetBackgroundColor(Color(0, 0, 0, 0))
	pnl:SetBackgroundColorHover(Color(126, 126, 126, 86))
	return pnl

end

function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( 'DPanel', self )
	pnl.Paint = function( p, w, h )
		derma.SkinHook( 'Paint', 'MenuSpacer', p, w, h )
	end

	pnl:SetTall( 1 )
	self:AddPanel( pnl )

	return pnl

end

function PANEL:Paint( w, h )

	if ( !self:GetPaintBackground() ) then return end

	-- derma.SkinHook( 'Paint', 'Menu', self, w, h )
    draw.RoundedBoxEx(4, 0, 0, w, h, mvp.Color('primary'), false, false, true, true)
	return true

end

mvp.ui.Register('mvp.Menu', PANEL, 'DMenu')

local PANEL = {}

AccessorFunc( PANEL, 'm_pMenu', 'Menu' )
AccessorFunc( PANEL, 'm_bChecked', 'Checked' )
AccessorFunc( PANEL, 'm_bCheckable', 'IsCheckable' )

function PANEL:Init()

	self:SetTextInset( 32, 0 ) -- Room for icon on left
	self:SetChecked( false )

    self:SetTextColor(mvp.Color('primary_text'))
end

function PANEL:SetSubMenu( menu )

	self.SubMenu = menu

	if ( !IsValid( self.SubMenuArrow ) ) then

		self.SubMenuArrow = vgui.Create( 'DPanel', self )
		self.SubMenuArrow.Paint = function( panel, w, h ) derma.SkinHook( 'Paint', 'MenuRightArrow', panel, w, h ) end

	end

end

function PANEL:AddSubMenu()

	local SubMenu = vgui.Create('mvp.Menu')
	SubMenu:SetVisible( false )
	SubMenu:SetParent( self )

	self:SetSubMenu( SubMenu )

	return SubMenu

end

function PANEL:PerformLayout()
    
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, self.backgroundCurrentColor)

    local tw, th = self:GetTextSize()

    
    if self:GetIcon() then
        local iw = h * .8

        draw.SimpleText(self:GetText(), self:GetFont(), w * .5 + iw * .5 + 1, h * .5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        mvp.utils.DrawIcon(w * .5 - tw * .5 - 1, h * .5, self:GetIcon(), h * .7, theme:GetColor('white'))
    else
        draw.SimpleText(self:GetText(), self:GetFont(), w * .5, h * .5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    return true 
end

mvp.ui.Register('mvp.MenuOption', PANEL, 'mvp.Button')