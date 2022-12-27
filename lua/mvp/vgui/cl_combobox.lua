local PANEL = {}

-- Derma_Hook( PANEL, 'Paint', 'Paint', 'ComboBox' )

Derma_Install_Convar_Functions( PANEL )

AccessorFunc( PANEL, 'm_bDoSort', 'SortItems', FORCE_BOOL )

function PANEL:Init()

	self:SetTall( 22 )
	self:Clear()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 8, 0 )
	self:SetIsMenu( true )
	self:SetSortItems( true )

    self:SetTextColor(mvp.Color('primary_text'))
    self:SetFont(mvp.Font(18))

end

function PANEL:Paint(w, h)
    if self:IsMenuOpen() then
        draw.RoundedBoxEx(4, 0, 0, w, h, Color(77,77,77), true, true, false, false)
    else
        
        draw.RoundedBox(5, 0, 0, w, h, mvp.Color('accent'))
        draw.RoundedBox(4, 1, 1, w - 2, h - 2, mvp.Color('secondary_dark'))
    end
end

function PANEL:OpenMenu( pControlOpener )

	if ( pControlOpener && pControlOpener == self.TextEntry ) then
		return
	end

	-- Don't do anything if there aren't any options..
	if ( #self.Choices == 0 ) then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Menu = vgui.Create('mvp.Menu', self)

	if ( self:GetSortItems() ) then
		local sorted = {}
		for k, v in pairs( self.Choices ) do
			local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
			if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( '#' ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
			table.insert( sorted, { id = k, data = v, label = val } )
		end
		for k, v in SortedPairsByMemberValue( sorted, 'label' ) do
			local option = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
			if ( self.ChoiceIcons[ v.id ] ) then
				option:SetIcon( self.ChoiceIcons[ v.id ] )
			end
		end
	else
		for k, v in pairs( self.Choices ) do
			local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
			if ( self.ChoiceIcons[ k ] ) then
				option:SetIcon( self.ChoiceIcons[ k ] )
			end
		end
	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )

	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, false, self )

end


mvp.ui.Register('mvp.Combobox', PANEL, 'DComboBox')