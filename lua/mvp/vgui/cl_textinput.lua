local PANEL = {}

function PANEL:Init()

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( 'hand' )
	self:SetFont( mvp.utils.GetFont(16, 'Proxima Nova Rg', 500) )

    self:SetTextColor(color_white)
    self:SetCursorColor(color_white)
end

function PANEL:OnCursorEntered()
end

function PANEL:DoClickInternal()
end

function PANEL:Paint( w, h )

    draw.RoundedBox(4, 0, 0, w, h, Color(75,75,75))

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

mvp.ui.Register('mvp.TextInput', PANEL, 'DTextEntry')