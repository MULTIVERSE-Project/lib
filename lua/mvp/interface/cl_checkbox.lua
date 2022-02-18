local PANEL = {}
AccessorFunc(PANEL, "m_bChecked", "Checked", FORCE_BOOL)
AccessorFunc(PANEL, "m_Style", "Style", FORCE_NUMBER)
AccessorFunc(PANEL, "m_Color", "Color")
-- Derma_Hook( PANEL, "Paint", "Paint", "CheckBox" )
-- Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "CheckBox" )
-- Derma_Hook( PANEL, "PerformLayout", "Layout", "CheckBox" )
Derma_Install_Convar_Functions(PANEL)
local soundClick = Sound('mvp/click.ogg')

function PANEL:Init()
    self:SetSize(15, 15)
    self:SetText("")
    self:SetStyle(1)
    self.mult = 0
    self.curMult = 0
    self:SetColor(Color(121, 218, 113))
end

function PANEL:IsEditing()
    return self.Depressed
end

function PANEL:Paint(w, h)
    if self:GetStyle() == 1 then
        draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(100, 100, 100))

        local bw, bh = w * self.curMult, h * self.curMult
        bw, bh = math.Round(bw), math.Round(bh)
        draw.RoundedBox(2, w * 0.5 - bw * 0.5, h * 0.5 - bh * 0.5, bw, bh, self:GetColor())
    elseif self:GetStyle() == 2 then
        surface.SetDrawColor(Color(100, 100, 100))
        draw.NoTexture()

        mvp.ui.drawCircle(w * .5, h * .5, w * 0.5 - 1, 1)
        surface.SetDrawColor(self:GetColor())
        mvp.ui.drawCircle(w * .5, h * .5, w * self.curMult * 0.5, 1)
    end
end

function PANEL:SetValue(val)
    -- Tobool bugs out with "0.00"
    if (tonumber(val) == 0) then
        val = 0
    end

    val = tobool(val)
    self:SetChecked(val)
    self.m_bValue = val
    self:OnChange(val)

    if (val) then
        val = "1"
    else
        val = "0"
    end

    self:ConVarChanged(val)
end

function PANEL:DoClick()
    self:Toggle()
    surface.PlaySound(soundClick)
end

function PANEL:Toggle()
    if (not self:GetChecked()) then
        self:SetValue(true)
    else
        self:SetValue(false)
    end
end

function PANEL:OnChange(bVal)
    -- For override
end

function PANEL:Think()
    self.curMult = Lerp(FrameTime() * 12, self.curMult, self:GetChecked() and 1 or 0)
    self:ConVarStringThink()
end

-- No example for this control
function PANEL:GenerateExample(class, tabs, w, h)
end

derma.DefineControl("mvp.CheckBox", "Simple Checkbox", PANEL, "DButton")
local PANEL = {}
AccessorFunc(PANEL, "m_iIndent", "Indent")

function PANEL:Init()
    self:SetTall(16)
    self.Button = vgui.Create("mvp.CheckBox", self)

    self.Button.OnChange = function(_, val)
        self:OnChange(val)
    end

    self.Label = vgui.Create("DLabel", self)
    self.Label:SetCursor('hand')
    self.Label:SetMouseInputEnabled(true)

    self.Label.DoClick = function()
        self.Button:DoClick()
    end
end

function PANEL:SetDark(b)
    self.Label:SetDark(b)
end

function PANEL:SetBright(b)
    self.Label:SetBright(b)
end

function PANEL:SetConVar(cvar)
    self.Button:SetConVar(cvar)
end

function PANEL:SetValue(val)
    self.Button:SetValue(val)
end

function PANEL:SetChecked(val)
    self.Button:SetChecked(val)
end

function PANEL:GetChecked(val)
    return self.Button:GetChecked()
end

function PANEL:Toggle()
    self.Button:Toggle()
end

function PANEL:SetStyle(var)
    self.Button:SetStyle(var)
end

function PANEL:SetColor(var)
    self.Button:SetColor(var)
end

function PANEL:PerformLayout()
    local x = self.m_iIndent or 0
    self.Button:SetSize(15, 15)
    self.Button:SetPos(x, math.floor((self:GetTall() - self.Button:GetTall()) / 2))
    self.Label:SizeToContents()
    self.Label:SetPos(x + self.Button:GetWide() + 9, math.floor((self:GetTall() - self.Label:GetTall()) / 2))
end

function PANEL:SetTextColor(color)
    self.Label:SetTextColor(color)
end

function PANEL:SizeToContents()
    self:InvalidateLayout(true) -- Update the size of the DLabel and the X offset
    self:SetWide(self.Label.x + self.Label:GetWide())
    self:SetTall(math.max(self.Button:GetTall(), self.Label:GetTall()))
    self:InvalidateLayout() -- Update the positions of all children
end

function PANEL:SetText(text)
    self.Label:SetText(text)
    self:SizeToContents()
end

function PANEL:SetFont(font)
    self.Label:SetFont(font)
    self:SizeToContents()
end

function PANEL:GetText()
    return self.Label:GetText()
end

function PANEL:Paint()
end

function PANEL:OnChange(bVal)
    -- For override
end

derma.DefineControl("mvp.CheckBoxLabel", "Simple Checkbox", PANEL, "DPanel")