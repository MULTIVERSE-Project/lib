local PANEL = {}

AccessorFunc( PANEL, 'backgroundColor', 'BackgroundColor' )

function PANEL:Init()

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( 'hand' )
	self:SetFont( mvp.Font(16, 500) )

    self:SetTextColor(mvp.Color('primary_text'))
    self:SetCursorColor(mvp.Color('primary_text'))

	self:SetBackgroundColor( mvp.Color('primary_dark') )
end

function PANEL:OnCursorEntered()
end

function PANEL:DoClickInternal()
end

function PANEL:Paint( w, h )

    draw.RoundedBox(4, 0, 0, w, h, self:GetBackgroundColor())

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