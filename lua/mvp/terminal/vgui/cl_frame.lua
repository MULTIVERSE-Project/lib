local PANEL = {}

DEFINE_BASECLASS("DFrame")

function PANEL:Init()
    self:DockPadding(0,0,0,0)
    self.backgroundGradient = mvp.ui.gradients.CreateHTMLGradient("terminalFrame_background_" .. mvp.utils.UUID(4), 800, 600, "135deg", "7px" )
end
function PANEL:PerformLayout(w, h)
    self.backgroundGradient = mvp.ui.gradients.CreateHTMLGradient(self.backgroundGradient, w, h, "135deg", "7px")
    BaseClass.PerformLayout(self, w, h)
end

function PANEL:OnCursorEntered()
    print(111)
end

function PANEL:Paint(w, h)
    mvp.ui.gradients.DrawHTMLGradient(self.backgroundGradient, 0, 0, w, h)
end

function PANEL:OnRemove()
    mvp.ui.gradients.DeleteHTMLGradient(self.backgroundGradient)
end

vgui.Register("mvp.Frame", PANEL, "DFrame")