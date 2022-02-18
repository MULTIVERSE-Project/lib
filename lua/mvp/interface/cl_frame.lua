local PANEL = {}

AccessorFunc( PANEL, 'm_bDeleteOnClose',	'DeleteOnClose',	FORCE_BOOL )
AccessorFunc( PANEL, 'm_bPaintShadow',		'PaintShadow',		FORCE_BOOL )

AccessorFunc( PANEL, 'm_cBackground',		'Background')

AccessorFunc( PANEL, 'm_bBackgroundBlur',	'BackgroundBlur',	FORCE_BOOL )

surface.CreateFont('mvp.Title', {
	font = 'Open Sans',
	size = 24,
	extended = true
})

surface.CreateFont('mvp.CloseButton', {
	font = 'Open Sans',
	size = 18,
	extended = true
})

function PANEL:Init()

	self:SetFocusTopLevel( true )

	--self:SetCursor( 'sizeall' )

	self:SetPaintShadow( true )

	self.lblTitle = vgui.Create( 'DPanel', self )
	-- self.lblTitle:SetFont('mvp.Title')

	self.lblTitle.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(49, 49, 49))
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(self:GetTitle(), 'mvp.Title', 5, h * .5, COLOR_WHITE, nil, TEXT_ALIGN_CENTER)
		return false
	end

	self.btnClose = vgui.Create( 'mvp.Button', self.lblTitle )
	self.btnClose:SetText( '✖', 'mvp.CloseButton', Color(236, 236, 236), TEXT_ALIGN_CENTER, 0, 0 )
	self.btnClose:SetBackgroundColor(Color(49, 49, 49))
	self.btnClose:SetFail()
	self.btnClose.DoClick = function ( button ) self:Close() end

	self:SetDeleteOnClose( true )
	self:SetTitle( 'Window' )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self:SetBackground(Color(41, 41, 41))

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )
end

function PANEL:ShowTitle( bShow )
	self.lblTitle:SetVisible( bShow )

	if bShow then
		self:DockPadding( 5, 24 + 5, 5, 5 )
	else
		self:DockPadding( 5, 5, 5, 5 )
	end
end

function PANEL:ShowCloseButton( bShow )
	self.btnClose:SetVisible( bShow )
end

function PANEL:GetTitle()

	return self.lblTitle.Title

end

function PANEL:SetTitle( strTitle )

	self.lblTitle.Title = strTitle

end

function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end

function PANEL:OnClose()
end

function PANEL:Center()

	self:InvalidateLayout( true )
	self:CenterVertical()
	self:CenterHorizontal()

end

function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false

end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

    surface.SetDrawColor(self:GetBackground())
    surface.DrawRect(0,0, w, h)
	
	self:OnPaint(w, h)

	return true

end

function PANEL:OnPaint(w, h)
	
end

function PANEL:OnMousePressed()

end


function PANEL:PerformLayout()

	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16

	end
	
   	self.lblTitle:SetPos( 0, 0 )
	self.lblTitle:SetSize( self:GetWide(), 26 )

	self.btnClose:Dock(RIGHT)
	self.btnClose:SetWide(26)

end

derma.DefineControl( 'mvp.Frame', '', PANEL, 'EditablePanel' )