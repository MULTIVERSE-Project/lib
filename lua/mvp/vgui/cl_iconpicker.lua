local PANEL = {}

function PANEL:Init()
    local frame = self
    frame:SetTitle('Icon picker')
    frame:SetIcon('f1fb')
    frame:SetSize(600, 450)
    frame:Center()
    frame:SetBackgroundBlur(true)
    frame:SetDrawOnTop(true)
    frame:MakePopup()
    frame:DoModal()

    local scroll = vgui.Create('DScrollPanel', frame)
    scroll:Dock(FILL)

    local list = vgui.Create('DIconLayout', scroll)
    list:Dock(FILL)
    list:DockMargin(5, 5, 5, 5)
    list:SetSpaceY(10)
    list:SetSpaceX(10)

    for k, v in pairs(mvp.utils.faIcons) do
        local copy = list:Add('mvp.IconButton')
        copy:SetSize(48, 48)
        copy:SetTooltip(k)
        copy:SetIcon(v.unicode)
        copy:SetNoDrawOutline(true)

        function copy:DoClick()
            mvp.utils.AddPopup(Format('%s (%s) copied to clipboard.\nWith code snippet.', v.unicode, k), v.unicode, nil, 1)
            SetClipboardText(Format('mvp.utils.DrawIcon(x, y, "%s", size, color, style)', v.unicode))
        end

        function copy:DoRightClick()
            mvp.utils.AddPopup(Format('%s (%s) copied to clipboard', v.unicode, k), v.unicode, nil, 1)
            SetClipboardText(v.unicode)
        end
    end
end

mvp.ui.Register('mvp.IconPicker', PANEL, 'mvp.Frame')