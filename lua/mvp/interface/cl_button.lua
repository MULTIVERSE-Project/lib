local PANEL = {}

AccessorFunc(PANEL, 'm_CircleColor', 'CircleColor')
AccessorFunc(PANEL, 'm_RoundCorners', 'RoundCorners')
AccessorFunc(PANEL, 'm_BackgroundColor', 'BackgroundColor')
AccessorFunc(PANEL, 'm_BackgroundHoverColor', 'BackgroundHoverColor')

AccessorFunc(PANEL, 'm_DrawSideBlock', 'DrawSideblock', FORCE_BOOL)
AccessorFunc(PANEL, 'm_DrawSideBlockColor', 'SideblockColor')
AccessorFunc(PANEL, 'm_DrawSideBlockWidth', 'SideblockWidth', FORCE_NUMBER)

AccessorFunc(PANEL, 'm_DrawText', 'DrawText', FORCE_BOOL)

AccessorFunc(PANEL, 'm_TextAligment', 'TextAligment')

function lerpColor(frac, from, to)
    return Color(
		Lerp(frac, from.r, to.r),
		Lerp(frac, from.g, to.g),
		Lerp(frac, from.b, to.b),
		Lerp(frac, from.a, to.a)
	)
end

local soundClick = Sound('mvp/click.ogg')
local soundHover = Sound('mvp/hover3.ogg')

surface.CreateFont('mvp.Button', {
    font = 'Proxima Nova Rg',
    size = 18,
    extended = true 
})

function PANEL:SetSuccess()
	self:SetBackgroundHoverColor(Color(86, 221, 81, 200))
end

function PANEL:SetFail()
	self:SetBackgroundHoverColor(Color(255, 81, 81, 200))
end

function PANEL:Init()

	self:SetContentAlignment( 5 )

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( 'hand' )
	self:SetFont( 'DermaDefault' )

	self:SetCircleColor(Color(200, 200, 200, 150))
	self:SetBackgroundColor(Color(56, 56, 56))
	self:SetBackgroundHoverColor(Color(97, 97, 97, 200, 200))

	self.m_BackgroundLerpColor = Color(40,40,40, 200)

	self:SetDrawSideblock(false)
    self:SetRoundCorners(0)

    self:SetDrawText(true)

	self:SetTextColor(Color(200, 200, 200))
	self:SetTextAligment(TEXT_ALIGN_CENTER)
	self.m_TextOffsets = {x = 5, y = 0}

	self.hovered = false
end

function PANEL:IsDown()
	return self.Depressed
end

function PANEL:OnCursorEntered()
	surface.PlaySound(soundHover)
end

function PANEL:SetText(text, font, color, aligment, ox, oy)
	text = text or 'Change me!'
	font = font or 'mvp.Button'
	color = color or Color(255, 255, 255)

	aligment = aligment or self:GetTextAligment()

	ox = ox or 5
	oy = oy or 0

	DLabel.SetText(self, text)
	self:SetFont(font)
	self:SetTextColor(color)

	self:SetTextAligment(aligment)

	self.m_TextOffsets = {x = ox, y = oy}

    -- self:SizeToContents()

    self:InvalidateLayout(true)
end

function PANEL:SetBackground(bgColor, bgHoverColor)
	self:SetBackgroundColor(bgColor)
	self:SetBackgroundHoverColor(bgHoverColor)

	self.m_BackgroundLerpColor = bgColor
end

function PANEL:SetSideblock(color, width)
	self:SetDrawSideblock(true)
	self:SetSideblockColor(color)
	self:SetSideblockWidth(width)
end

local speed = 5 

PANEL.m_Rad, PANEL.m_Alpha, PANEL.m_ClickX, PANEL.m_ClickY = 0, 0, 0, 0
function PANEL:CircleClick(w, h)
	if self.m_Alpha >= 1 then
		surface.SetDrawColor(ColorAlpha(self:GetCircleColor(), self.m_Alpha))
		draw.NoTexture()
		mvp.ui.drawCircle(self.m_ClickX, self.m_ClickY, self.m_Rad, 3)

		self.m_Rad = Lerp(FrameTime() * speed, self.m_Rad, w)
		self.m_Alpha = Lerp(FrameTime() * speed, self.m_Alpha, 0)
	end
end

function PANEL:DoClickInternal()
	self.m_ClickX, self.m_ClickY = self:CursorPos()
	self.m_Rad = 0
	self.m_Alpha = self:GetCircleColor().a

	surface.PlaySound(soundClick)
end

function PANEL:PaintOver(w, h)
	self:CircleClick(w, h)
end

function PANEL:Paint( w, h )

	if self:IsHovered() then
		self.m_BackgroundLerpColor = lerpColor(FrameTime() * 12, self.m_BackgroundLerpColor, self:GetBackgroundHoverColor())
	else
		self.m_BackgroundLerpColor = lerpColor(FrameTime() * 12, self.m_BackgroundLerpColor, self:GetBackgroundColor())
	end

	draw.RoundedBox(self:GetRoundCorners(), 0, 0, w, h, self.m_BackgroundLerpColor)

	self:DrawSideBlock(w, h)
	self:DrawText(w, h)
	self:OnPaint(w, h)

	--
	-- Draw the button text
	--
	return true
end

function PANEL:DrawSideBlock(w, h)
	if self:GetDrawSideblock() then
		surface.SetDrawColor(self:GetSideblockColor())
		surface.DrawRect(0, 0, self:GetSideblockWidth(), h)
	end
end

function PANEL:DrawText(w, h)
	if not self:GetDrawText() then
		return 
	end

	local x = 0

	local ox, oy = self.m_TextOffsets.x, self.m_TextOffsets.y

	if self:GetTextAligment() == TEXT_ALIGN_CENTER then
		x = w * 0.5
	elseif self:GetTextAligment() == TEXT_ALIGN_RIGHT then
		x = w
	end

	draw.SimpleText(self:GetText(), self:GetFont(), x + ox, h * .5 + oy, self:GetTextColor(), self:GetTextAligment(), TEXT_ALIGN_CENTER)
end

function PANEL:OnPaint(w, h)
	
end

function PANEL:UpdateColours( skin )

	if ( !self:IsEnabled() )					then return self:SetTextStyleColor( skin.Colours.Button.Disabled ) end
	if ( self:IsDown() || self.m_bSelected )	then return self:SetTextStyleColor( skin.Colours.Button.Down ) end
	if ( self.Hovered )							then return self:SetTextStyleColor( skin.Colours.Button.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Button.Normal )

end

function PANEL:PerformLayout( w, h )

	--
	-- If we have an image we have to place the image on the left
	-- and make the text align to the left, then set the inset
	-- so the text will be to the right of the icon.
	--
	if ( IsValid( self.m_Image ) ) then

		self.m_Image:SetPos( 4, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )

		self:SetTextInset( self.m_Image:GetWide() + 16, 0 )

	end

	DLabel.PerformLayout( self, w, h )

end

function PANEL:SizeToContents()
	local w, h = self:GetTextSize()

    if w <= 85 then
        self:SetSize( 85, h + 4 )
        return 
    end
	self:SetSize( w + 16, h + 4 )
end

derma.DefineControl( 'mvp.Button', 'A standard Button', PANEL, 'DLabel' )