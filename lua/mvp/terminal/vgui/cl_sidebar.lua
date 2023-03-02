local PANEL = {}

function PANEL:Init()
    self:DockPadding(0, mvp.ui.Scale(90), mvp.ui.Scale(5), 0)

    self._buttons = {}
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(7, 0, 0, mvp.ui.Scale(65), h, Color(51, 51, 51), true, false, true, false)
    draw.RoundedBox(0, w - mvp.ui.Scale(5), 0, mvp.ui.Scale(5), h, Color(51, 51, 51))
end

function PANEL:AddButton(icon, text, click, defaultActive)
    local btn = vgui.Create("mvp.SidebarButton", self)
    btn:Dock(TOP)
    
    btn:SetText(text)
    btn:SetIcon(icon)
    btn:SetActive(defaultActive)

    btn.DoClick = function(self2)
        for k, v in pairs(self._buttons) do
            v:SetActive(false)
        end

        self2:SetActive(true)

        if click and isfunction(click) then
            click()
        end
    end

    self._buttons[#self._buttons + 1] = btn
    

    return btn
end

function PANEL:SetShowCloseButton(show, clickOverride)
    if self.closeButton then
        self.closeButton:Remove()
    end
    
    if not show then
        return 
    end

    self.closeButton = vgui.Create("mvp.SidebarButtonClose", self)
    self.closeButton:Dock(BOTTOM)
    self.closeButton:SetText("Close")

    self.closeButton.DoClick = function()
        if clickOverride and isfunction(clickOverride) then
            return clickOverride()
        end

        self:GetParent():Remove()
    end

    return self.closeButton
end

vgui.Register("mvp.Sidebar", PANEL, "EditablePanel")