mvp.utils = mvp.utils or {}

function mvp.utils.MessagePromt(strText, strTitle, strButtonText)
	local Window = vgui.Create( "mvp.Frame" )
	Window:SetTitle( strTitle or "Message" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "Panel", Window )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetText( strText or "Message Text" )
	Text:SetFont(mvp.Font(16))
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )

	

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	local Button = vgui.Create( "mvp.Button", ButtonPanel )
	Button:SetText( strButtonText or "OK" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() end

	ButtonPanel:SetWide( Button:GetWide() + 10 )

	local w, h = Text:GetSize()

	Window:SetSize( math.max(w, 300) + 50, math.max(h, 75) + 25 + 45 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 45, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()
	return Window
end

function mvp.utils.QuerryPromt(strTitle, strText, ...)
	local Window = vgui.Create( "mvp.Frame" )
	Window:SetTitle( strTitle or "Message Title (First Parameter)" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetPaintBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetFont(mvp.Font(16))
	Text:SetText( strText or "Message Text (Second Parameter)" )
	Text:SizeToContents()
	Text:Dock(FILL)
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k=1, 8, 2 do

		local Text = select( k, ... )
		if Text == nil then break end

		local Func = select( k+1, ... ) or function() end

		local Button = vgui.Create( "mvp.Button", ButtonPanel )
		Button:SetText( Text )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button.DoClick = function() Window:Close() Func() end
		Button:SetPos( x, 5 )

		x = x + Button:GetWide() + 5

		ButtonPanel:SetWide( x )
		NumOptions = NumOptions + 1

	end

	local w, h = Text:GetSize()
	
	w = math.max( w, ButtonPanel:GetWide() )

	Window:SetSize( math.max(w, 300) + 50, math.max(h, 75) + 25 + 45 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 45, 5, 10 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()

	if ( NumOptions == 0 ) then

		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil

	end

	return Window
end