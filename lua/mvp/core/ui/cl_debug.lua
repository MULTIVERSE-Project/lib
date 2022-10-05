local theme = mvp.themes.GetActive()

concommand.Add('mvp_ui_showcase', function()
    local frame = vgui.Create('mvp.Frame')
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    frame:Center()
    frame:SetTitle('MVP UI Showcase')
    frame:MakePopup()

    local combobox = vgui.Create('mvp.Combobox', frame)
    combobox:SetPos(10, 80)
    combobox:SetSize(200, 22)
    combobox:SetValue('Select a theme')

    combobox:AddChoice('Test 1')
    combobox:AddChoice('Test 2')
    combobox:AddChoice('Test 3')



end)