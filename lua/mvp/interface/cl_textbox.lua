local PANEL = {}

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

surface.CreateFont('mvp.TextBox', {
    font = 'Proxima Nova Rg',
    size = 16,
    extended = true 
})

function PANEL:Init()

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( 'hand' )
	self:SetFont( 'mvp.TextBox' )

    self:SetTextColor(COLOR_WHITE)
    self:SetCursorColor(COLOR_WHITE)
end

function PANEL:OnCursorEntered()
	surface.PlaySound(soundHover)
end

function PANEL:DoClickInternal()

	surface.PlaySound(soundClick)
end

function PANEL:Paint( w, h )

    draw.RoundedBox(0, 0, 0, w, h, Color(75,75,75))

	if ( self.GetPlaceholderText && self.GetPlaceholderColor && self:GetPlaceholderText() && self:GetPlaceholderText():Trim() != "" && self:GetPlaceholderColor() && ( !self:GetText() || self:GetText() == "" ) ) then

		local oldText = self:GetText()

		local str = self:GetPlaceholderText()
		if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
		str = language.GetPhrase( str )

		self:SetText( str )
		self:DrawTextEntryText( self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor() )
		self:SetText( oldText )

		return
	end

	self:DrawTextEntryText( self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor() )
	return false
end

derma.DefineControl( 'mvp.TextBox', 'A standard Button', PANEL, 'DTextEntry' )