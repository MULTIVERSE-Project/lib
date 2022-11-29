local PANEL = {}

function PANEL:Init()
    self.scroll = vgui.Create('DScrollPanel', self)
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(5, 0, 5, 5)

    for k, v in pairs(mvp.modules.list) do
        PrintTable(v)
        self:AddModule(v)
    end
end

function PANEL:AddModule(module)
    local pnl = vgui.Create('EditablePanel', self.scroll)

    pnl:Dock(TOP)
    pnl:DockMargin(0, 0, 0, 5)

    pnl:SetTall(95)

    function pnl:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, mvp.Color('secondary'))

        local y = 5
        local tw, th = draw.SimpleText(module:GetName(), mvp.utils.GetFont(24, 'Proxima Nova Rg'), 5, y, mvp.Color('text'))
        draw.SimpleText(Format('version %s', module:GetVersion()), mvp.utils.GetFont(16, 'Proxima Nova Rg'), 5 + tw + 3, th * .5, mvp.Color('secondary_text'))
        y = y + th - 5


        local _, th = draw.SimpleText(Format('Author: %s', module:GetAuthor()), mvp.utils.GetFont(16, 'Proxima Nova Rg'), 5, y, mvp.Color('text'))
        y = y + th + 5

        local _, th = draw.SimpleText(module:GetDescription(), mvp.utils.GetFont(18, 'Proxima Nova Rg'), 5, y, mvp.Color('text'))
        y = y + th + 5
    end

    local controls = vgui.Create('DPanel', pnl)
    controls:Dock(BOTTOM)
    controls:DockMargin(0, 0, 0, 5)

    function controls:Paint(w, h)
        draw.SimpleText('Enabled', mvp.utils.GetFont(18, 'Proxima Nova Rg'), 30, h * .5, mvp.Color('text'), nil, TEXT_ALIGN_CENTER)
    end

    local enabled = vgui.Create('mvp.Checkbox', controls)
    enabled:SetSize(20, 20)
    enabled:SetPos(5, 2)
    enabled:SetValue( not module:GetDisabled() )
    -- enabled:SetChecked( not module:GetDisabled() )

    function enabled:OnValueChanged(val)
        net.Start('mvp.DisableModule')
            net.WriteString(module:GetID())
            net.WriteBool(not val)
        net.SendToServer()

        mvp.utils.MessagePromt('You need to restart server for this to take action!', 'Server restart required')
    end
end

mvp.ui.Register('mvp.ModulesManager', PANEL, 'EditablePanel')