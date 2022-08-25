local PANEL = {}
local theme = mvp.themes.GetActive()

function PANEL:Init()
    self:ShowCloseButton(false)
    self:SetTitle("")
    
    self.closeBtn = vgui.Create("DButton", self)
    self.closeBtn:SetText("")
    self.closeBtn:SetSize(16, 16)
    self.closeBtn:SetPos(self:GetWide() - 16, 0)

    self.closeBtn.backgroundColor = theme:GetColor('secondary')

    self.closeBtn.Paint = function(s, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, s.backgroundColor, false, true, false, false)

        mvp.utils.DrawIcon(w * .5, h * .5, 'xmark', 32, theme:GetColor('white'))
    end

    self.closeBtn.OnCursorEntered = function(s)
        s:LerpColor('backgroundColor', theme:GetColor('red'), 0.2)
    end
    self.closeBtn.OnCursorExited = function(s)
        s:LerpColor('backgroundColor', theme:GetColor('secondary'), 0.2)
    end

    self.closeBtn.DoClick = function()
        self:Remove()
    end

    self.lblTitle.Paint = function(self, w, h)
        return true
    end

    self:DockPadding( 0, 45, 0, 0 )
end

function PANEL:DefaultPaint(w, h)    
    draw.RoundedBox(8, 0, 0, w, h, theme:GetColor('primary'))

    draw.RoundedBoxEx(8, 0, 0, w, 45, theme:GetColor('secondary'), true, true, false, false)

    local offset = 10

    if self.icon then
        mvp.utils.DrawIcon(28, 45 * .5, self.icon, 24, theme:GetColor('text'))
        offset = offset + 28 + 10
    end

    draw.SimpleText(self.lblTitle:GetText(), mvp.utils.GetFont(24, 'Proxima Nova Regular'), offset, 45 * .5, theme:GetColor('text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)
end

function PANEL:SetTitle(title)
    self.lblTitle:SetText(title)
end

function PANEL:SetIcon(unicode)
    self.icon = unicode
end

function PANEL:PerformLayout(w, h)
    self.closeBtn:SetSize(45, 45)
    self.closeBtn:SetPos(w - 45, 0)
end

mvp.ui.Register('mvp.Frame', PANEL, 'DFrame')