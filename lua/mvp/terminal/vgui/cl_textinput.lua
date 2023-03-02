local PANEL = {}

AccessorFunc( PANEL, '_icon', 'Icon' )

function PANEL:Init()

    self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( 'beam' )

    self.TextEntry = vgui.Create("mvp.TextInputInternal", self)

    self._font = mvp.Font(self.TextEntry:GetTall() * .8)
end

function PANEL:PerformLayout(w, h)
    local padX, padY = mvp.ui.Scale(8), mvp.ui.Scale(4)

    local iconPadding = 0
    if self._icon then
        local iconInfo = mvp.ui.GetIcon(self._icon, h * .6)

        surface.SetFont(iconInfo.font)
        iconW = surface.GetTextSize(iconInfo.text)

        iconPadding =  iconW + mvp.ui.Scale(4)
    end

    self.TextEntry:DockMargin(padX + iconPadding, padY, padX, padY)
    self.TextEntry:Dock(FILL)

    self._font = mvp.Font(self.TextEntry:GetTall() * .8)
end

function PANEL:OnCursorEntered()
    mvp.ui.Sound("hover")
end

function PANEL:DoClickInternal()
    mvp.ui.Sound("click")
end

function PANEL:Paint( w, h )
    draw.RoundedBox(8, 0, 0, w, h, Color(51, 51, 51))

    local padX, padY = mvp.ui.Scale(8), mvp.ui.Scale(4)

    local iconPadding = 0
    if self._icon then
        local iconInfo = mvp.ui.GetIcon(self._icon, h * .6)

        surface.SetFont(iconInfo.font)
        iconW = surface.GetTextSize(iconInfo.text)

        iconPadding =  iconW + mvp.ui.Scale(4)

        mvp.ui.DrawIconExt(mvp.ui.Scale(8), h * .5, self._icon, h * .6, self:IsEnabled() and color_white or Color(212, 212, 212), nil, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if not self:IsEnabled() then
        draw.SimpleText("Disabled", self._font, mvp.ui.Scale(8) + iconPadding + 3, h * .5, Color(150, 150, 150), nil, TEXT_ALIGN_CENTER)
    end

    if self:GetValue() == "" then
        draw.SimpleText(self:GetPlaceholderText() or "", self._font, padX + iconPadding + 3, h * .5, Color(150, 150, 150), nil, TEXT_ALIGN_CENTER)
    end

	return false
end

function PANEL:OnChange() end
function PANEL:OnValueChange(value) end

function PANEL:IsEnabled() return self.TextEntry:IsEnabled() end
function PANEL:SetEnabled(enabled) self.TextEntry:SetEnabled(enabled) end

function PANEL:GetValue() return self.TextEntry:GetValue() end
function PANEL:SetValue(value) self.TextEntry:SetValue(value) end

function PANEL:IsMultiline() return self.TextEntry:IsMultiline() end
function PANEL:SetMultiline(isMultiline) self.TextEntry:SetMultiline(isMultiline) end

function PANEL:IsEditing() return self.TextEntry:IsEditing() end

function PANEL:GetEnterAllowed() return self.TextEntry:GetEnterAllowed() end
function PANEL:SetEnterAllowed(allow) self.TextEntry:SetEnterAllowed(allow) end

function PANEL:GetUpdateOnType() return self.TextEntry:GetUpdateOnType() end
function PANEL:SetUpdateOnType(enabled) self.TextEntry:SetUpdateOnType(enabled) end

function PANEL:GetNumeric() return self.TextEntry:GetNumeric() end
function PANEL:SetNumeric(enabled) self.TextEntry:SetNumeric(enabled) end

function PANEL:GetHistoryEnabled() return self.TextEntry:GetHistoryEnabled() end
function PANEL:SetHistoryEnabled(enabled) self.TextEntry:SetHistoryEnabled(enabled) end

function PANEL:GetTabbingDisabled() return self.TextEntry:GetTabbingDisabled() end
function PANEL:SetTabbingDisabled(disabled) self.TextEntry:SetTabbingDisabled(disabled) end

function PANEL:GetPlaceholderText() return self.TextEntry:GetPlaceholderText() end
function PANEL:SetPlaceholderText(text) self.TextEntry:SetPlaceholderText(text) end

function PANEL:GetInt() return self.TextEntry:GetInt() end
function PANEL:GetFloat() return self.TextEntry:GetFloat() end

function PANEL:IsEditing() return self.TextEntry:IsEditing() end
function PANEL:SetEditable(enabled) self.TextEntry:SetEditable(enabled) end

function PANEL:AllowInput(value) end
function PANEL:GetAutoComplete(txt) end

function PANEL:OnKeyCode(code) end
function PANEL:OnEnter() end

function PANEL:OnGetFocus() end
function PANEL:OnLoseFocus() end

mvp.ui.Register('mvp.TextInput', PANEL, 'Panel')