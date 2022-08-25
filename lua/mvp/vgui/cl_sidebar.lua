local PANEL = {}
local theme = mvp.themes.GetActive()

function PANEL:Init()
    self.buttons = {}
    self:SetWide(64)

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:Dock(FILL)

    self.scroll:DockPadding(0, 0, 1, 0)

    local vbar = self.scroll:GetVBar()
    vbar:SetWide(8)
    vbar:SetHideButtons(true)

    function vbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, theme:GetColor('secondary_dark'))
    end
    function vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, theme:GetColor('primary_dark'))
    end
end

function PANEL:AddButton(icon, tooltip, click)
    local button = vgui.Create('mvp.SidebarButton', self.scroll)
    
    button:SetIcon(icon)
    button:SetTooltip(tooltip)
    
    button:Dock(TOP)
    button:DockMargin(4, 5, 4, 0)

    button.DoClick = click or function() end

    self.buttons[#self.buttons + 1] = button

    return button
end

function PANEL:SetStyle(style)
    if style == LEFT then
        
    elseif style == RIGHT then
        
    else
        error("Invalid style")
    end
end

function PANEL:DefaultPaint(w, h)    
    draw.RoundedBoxEx(8, 0, 0, w, h, theme:GetColor('secondary_dark'), false, false, true, false)
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)
end

function PANEL:PerformLayout(w, h)

end

mvp.ui.Register('mvp.Sidebar', PANEL, 'EditablePanel')

local PANEL = {}

AccessorFunc(PANEL, 'icon', 'Icon')
AccessorFunc(PANEL, 'tooltip', 'Tooltip')

function PANEL:Init()
    self.hoverBackground = ColorAlpha(theme:GetColor('secondary_text'), 0)
end

function PANEL:DefaultPaint(w, h)
    local innerSize = w * .8

    draw.RoundedBox(5, 0, 0, w, h, theme:GetColor('primary_dark'))
    draw.RoundedBox(8, w * .5 - innerSize * .5, h * .5 - innerSize * .5, innerSize, innerSize, self.hoverBackground, 50)

    mvp.utils.DrawIcon(w * .5, h * .5, self.icon, innerSize * .7, theme:GetColor('white'))
end

function PANEL:OnCursorEntered()
    self:LerpColor('hoverBackground', ColorAlpha(theme:GetColor('secondary_text'), 50), .2)

    if IsValid(mvp.ui.tooltip) then
        mvp.ui.tooltip:Remove()
    end

    surface.SetFont(mvp.utils.GetFont(21, 'Proxima Nova Rg', 500))
    local textW, textH = surface.GetTextSize(self.tooltip)

    mvp.ui.tooltip = vgui.Create('EditablePanel')
    mvp.ui.tooltip:SetSize(textW + 30, 32)
    mvp.ui.tooltip:SetDrawOnTop( true )
    
    mvp.ui.tooltip.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, theme:GetColor('secondary_dark'))

        draw.SimpleText(self.tooltip, mvp.utils.GetFont(21, 'Proxima Nova Rg', 500), w * .5, h * .5, theme:GetColor('white'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    mvp.ui.tooltip.Think = function(s)
        local x, y = self:LocalToScreen(0, 0)
        
        s:SetPos(x - s:GetWide() - 15, y + self:GetTall() * .5 - s:GetTall() * .5)
    end
end

function PANEL:OnCursorExited()
    self:LerpColor('hoverBackground', ColorAlpha(theme:GetColor('secondary_text'), 0), .2)

    if IsValid(mvp.ui.tooltip) then
        mvp.ui.tooltip:Remove()
    end
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)

    return true
end

function PANEL:PerformLayout(w, h)
    self:SetTall(w)
end

mvp.ui.Register('mvp.SidebarButton', PANEL, 'DButton')
