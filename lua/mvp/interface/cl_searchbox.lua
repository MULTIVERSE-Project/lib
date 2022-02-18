local PANEL = {}

AccessorFunc(PANEL, 'm_Haystacks', 'Haystacks')
AccessorFunc(PANEL, 'm_CaseSensitive', 'CaseSensitive')

function PANEL:Init()
	self:SetHaystacks({})
	self:SetCaseSensitive(false)
end

function PANEL:GetAutoComplete( text )
	local suggestions = fzy.filter(text, self:GetHaystacks(), self:GetCaseSensitive())
	
	local result = {}

	for k, v in ipairs(suggestions) do
		result[#result + 1] = v[1]
	end

	return result
end

function PANEL:OpenAutoComplete( tab )

	if ( !tab ) then return end
	if ( #tab == 0 ) then return end

	self.Menu = vgui.Create('mvp.Menu')

	for k, v in pairs( tab ) do

		self.Menu:AddOption( v, function() self:SetText( v ) self:SetCaretPos( v:len() ) self:RequestFocus() end )

	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )
	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, true, self )
	self.Menu:SetPos( x, y )
	self.Menu:SetMaxHeight( ( ScrH() - y ) - 10 )

end

function PANEL:OnGetFocus()
	self:OpenAutoComplete( self:GetAutoComplete( '' ) )
end

derma.DefineControl( 'mvp.SearchBox', 'A standard Button', PANEL, 'mvp.TextBox' )