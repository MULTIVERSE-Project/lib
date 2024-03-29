local PANEL = {}
local theme = mvp.themes.GetActive()

function PANEL:Init()
    self.categories = {}
    self.inputs = {}

    self.scroll = vgui.Create('DScrollPanel', self)
    self.scroll:Dock(FILL)

    for k, v in pairs(mvp.config.stored) do
        local categ = self:AddCategory(v.data.category and mvp.Lang('@' .. v.data.category .. '_Cat') or mvp.Lang('@other_Cat'))

        self:AddInput(categ, v.type, k, v.value)
    end

    self.savePopup = vgui.Create('EditablePanel', self)
    self.savePopup:SetY(ScrH())
    
    surface.SetFont(mvp.Font(21, 500))
    local textW, textH = surface.GetTextSize('UNSAVED CHANGES')
    self.savePopup:SetSize(textW + 64 + 16 + 128, 64)
    
    self.savePopup.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary'))

        mvp.utils.DrawIcon(32, h * .5, 'triangle-exclamation', 32, mvp.Color('yellow'))

        draw.SimpleText('UNSAVED CHANGES', mvp.Font(21, 500), 64, h * .5 - textH * .5 + 2, mvp.Color('accent_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText('Please save/reset your changes', mvp.Font(18, 500), 64, h * .5 + textH * .5, mvp.Color('primary_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local saveButton = vgui.Create('mvp.IconButton', self.savePopup)
    saveButton:SetIcon('floppy-disk')
    saveButton:SetBackgroundColorHover(mvp.Color('green'))
    saveButton:SetOutlineColor(mvp.Color('green'))
    saveButton:SetSize(32, 32)
    saveButton:SetPos(self.savePopup:GetWide() - 64 - 16 - 5, self.savePopup:GetTall() * .5 - 32 * .5)

    saveButton.DoClick = function(s)
        for k, v in pairs(self.inputs) do
            if mvp.config.stored[k].value ~= v:GetValue() then
                mvp.config.Set(k, v:GetValue())
            end
        end
    end

    local resetButton = vgui.Create('mvp.IconButton', self.savePopup)
    resetButton:SetIcon('rotate-left')
    resetButton:SetBackgroundColorHover(mvp.Color('red'))
    resetButton:SetOutlineColor(mvp.Color('red'))
    resetButton:SetSize(32, 32)
    resetButton:SetPos(self.savePopup:GetWide() - 32 - 16, self.savePopup:GetTall() * .5 - 32 * .5)

    resetButton.DoClick = function(s)
        for k, v in pairs(self.inputs) do
            v:SetValue(mvp.config.stored[k].value)
        end
    end
end


local typesMap = {
    [mvp.type.string] = function(base, name, value)
        local config = mvp.config.stored[name]

        base:SetTall(56)
        base.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))

            draw.SimpleText(mvp.Lang('@' .. name), mvp.Font(24, 500), 16, h * .5 - 5, mvp.Color('accent_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('@' .. name .. '_Desc'), mvp.Font(16, 500), 16, h * .5 + 10, mvp.Color('secondary_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local input = vgui.Create('mvp.TextInput', base)
        input:Dock(RIGHT)

        local magicHappensHere = (56 - 22) * .5

        input:DockMargin(0, magicHappensHere, 5, magicHappensHere)
        input:SetText(value)
        input:SetWide(300)

        function input:SetValue(value)
            return self:SetText(mvp.utils.SanitazeType(mvp.type.string, value))
        end

        function input:GetValue()
            return self:GetText()
        end

        return input
    end,
    [mvp.type.number] = function(base, name, value)
        local config = mvp.config.stored[name]

        base:SetTall(56)
        base.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))

            draw.SimpleText(mvp.Lang('@' .. name), mvp.Font(24, 500), 16, h * .5 - 5, mvp.Color('accent_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('@' .. name .. '_Desc'), mvp.Font(16, 500), 16, h * .5 + 10, mvp.Color('secondary_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local input = vgui.Create('DNumSlider', base)
        input:Dock(RIGHT)

        local magicHappensHere = (56 - 22) * .5

        input:DockMargin(0, magicHappensHere, 5, magicHappensHere)
        input:SetWide(300)

        input:SetMin(config.data.min or 0)
        input:SetMax(config.data.max or 50)
        input:SetDecimals(config.data.decimals or 0)

        input:SetValue(value)

        return input
    end,
    [mvp.type.bool] = function(base, name, value)
        local config = mvp.config.stored[name]

        base:SetTall(56)
        base.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))

            draw.SimpleText(mvp.Lang('@' .. name), mvp.Font(24, 500), 16, h * .5 - 5, mvp.Color('accent_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('@' .. name .. '_Desc'), mvp.Font(16, 500), 16, h * .5 + 10, mvp.Color('secondary_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local input = vgui.Create('mvp.Checkbox', base)
        input:Dock(RIGHT)

        local magicHappensHere = (56 - 22) * .5

        input:DockMargin(0, magicHappensHere, 5, magicHappensHere)
        input.oldSetValue = input.SetValue
        input:oldSetValue(mvp.utils.SanitazeType(mvp.type.bool, value))

        input:SetWide(22)

        function input:SetValue(value)
            return self:oldSetValue(mvp.utils.SanitazeType(mvp.type.bool, value))
        end

        function input:GetValue()
            return mvp.utils.SanitazeType(mvp.type.bool, self:GetChecked())
        end

        return input
    end,
    [mvp.type.array] = function(base, name, value)
        local config = mvp.config.stored[name]

        base:SetTall(56)
        base.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))

            draw.SimpleText(mvp.Lang('@' .. name), mvp.Font(24, 500), 16, h * .5 - 5, mvp.Color('accent_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('@' .. name .. '_Desc'), mvp.Font(16, 500), 16, h * .5 + 10, mvp.Color('secondary_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local manager

        local currentValue = value

        local btn = vgui.Create('mvp.Button', base)
        btn:Dock(RIGHT)
        btn:SetIcon('marker')
        btn:SetText(mvp.Lang('configEdit'))
 
        btn.DoClick = function()
            manager = vgui.Create('mvp.ArrayManager')

            manager:SetTitle(mvp.Lang('configEditField', name))

            manager:SetKeyType(config.data.key.type)
            manager:SetValueType(config.data.value.type)

            manager:SetKeyHint(config.data.key.hint or '')
            manager:SetValueHint(config.data.value.hint or '')
            
            for k, v in pairs(currentValue) do
                manager:AddEntry(k, v)
            end

            manager.OnSave = function(s, value)
                local hasChanges = false

                for k, v in pairs(value) do
                    if currentValue[k] == nil or currentValue[k] ~= v then
                        hasChanges = true
                        break
                    end
                end

                for k, v in pairs(currentValue) do
                    if value[k] == nil then
                        hasChanges = true
                        break
                    end
                end

                if hasChanges then
                    currentValue = value
                end
            end
        end

        local magicHappensHere = (56 - 22) * .5

        btn:DockMargin(0, magicHappensHere, 5, magicHappensHere)

        -- faking a value input
        local input = {
            GetValue = function(self)
                return currentValue
            end,
            SetValue = function(self, value)
                currentValue = value
            end
        }

        return input
    end,
    ['select'] = function(base, name, value)
        local config = mvp.config.stored[name]

        base:SetTall(56)
        base.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))

            draw.SimpleText(mvp.Lang('@' .. name), mvp.Font(24, 500), 16, h * .5 - 5, mvp.Color('accent_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('@' .. name .. '_Desc'), mvp.Font(16, 500), 16, h * .5 + 10, mvp.Color('secondary_text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local input = vgui.Create('mvp.Combobox', base)
        input:Dock(RIGHT)

        local magicHappensHere = (56 - 22) * .5

        input:DockMargin(0, magicHappensHere, 5, magicHappensHere)
        -- input:SetText(value)
        input:SetWide(300)

        if config.data.GetValues then
            for k, v in pairs(config.data.GetValues()) do
                input:AddChoice(v.text, v.value, v.value == config.value)
            end
        end

        function input:SetValue(value)
            local values = config.data.GetValues and config.data.GetValues() or {}

            for k, v in pairs(values) do
                if v.value == value then
                    self:ChooseOptionID(k)
                    break
                end
            end
            
            return
        end

        function input:GetValue()
            local _, data = self:GetSelected()
            return data
        end

        return input
    end
}
function PANEL:AddInput(categ, type, name, value)
    print('adding input', categ, type, name, value)
    if not typesMap[type] then return end

    categ.inputs = categ.inputs or {}

    local pnl = vgui.Create('DPanel', categ)
    pnl:Dock(TOP)
    pnl:DockMargin(5, 5, 5, 0)

    local reset = vgui.Create('mvp.IconButton', pnl)
    reset:Dock(RIGHT)
    reset:SetIcon('rotate-left')
    reset:SetBackgroundColorHover(mvp.Color('red'))
    reset:SetOutlineColor(mvp.Color('red'))
    
    pnl.PerformLayout = function(s, w, h)
        reset:SetWide(22)

        local magicHappensHere = (h - 22) * .5
        reset:DockMargin(0, magicHappensHere, 5, magicHappensHere)
    end

    local input = typesMap[type](pnl, name, value)

    reset.DoClick = function(s)
        input:SetValue(mvp.config.stored[name].default)
    end

    categ.inputs[name] = input
    self.inputs[name] = input
end

function PANEL:Think()
    local shouldPopup = false
    for k, v in pairs(self.categories) do
        
        if v.inputs then
            local changed = false
            for k2, v2 in pairs(v.inputs) do
                local configEntry = mvp.config.stored[k2]
                if v2:GetValue() ~= configEntry.value then -- oh shit what i have done, pls dont kill me, better solution will be in the future ( or you can do it dor me :) )
                    if configEntry.type == mvp.type.array then -- array is a special case
                        for configKey, configValue in pairs(configEntry.value) do -- check if the value is the same
                            local value = v2:GetValue()[configKey]
                            if value == nil or value ~= configValue then
                                changed = true
                                break
                            end
                        end

                        for k3, v3 in pairs(v2:GetValue()) do -- check if the value is the same x2
                            if configEntry.value[k3] ~= v3 then
                                changed = true
                                break
                            end
                        end
                    else
                        changed = true
                        -- print(k2, v2:GetValue(), configEntry.value)
                        break
                    end
                end
            end

            v.hasUnsavedChanges = changed
        end

        v:SetSideblockColor(mvp.utils.LerpColor(FrameTime() * 15, v:GetSideblockColor() or color_white, v.hasUnsavedChanges and mvp.Color('yellow') or mvp.Color('green')))

        if v.hasUnsavedChanges then
            shouldPopup = true
        end
    end

    if not self.savePopup then return end
    if shouldPopup then
        self.savePopup:SetY(Lerp(FrameTime() * 5, self.savePopup:GetY(), self:GetTall() - self.savePopup:GetTall() - 35))
    else
        self.savePopup:SetY(Lerp(FrameTime() * 5, self.savePopup:GetY(), self:GetTall() + 50))        
    end
end

function PANEL:AddCategory(title)
    if self.categories[title] then return self.categories[title] end
    
    local categ = vgui.Create('mvp.Category', self.scroll)
    categ:SetLabel(title)
    categ:Dock(TOP)

    self.categories[title] = categ

    return categ
end

function PANEL:GetCategory(title)
    return self.categories[title]
end

function PANEL:DefaultPaint(w, h)
    
end

function PANEL:Paint(w, h)
    self:DefaultPaint(w, h)
end

function PANEL:PerformLayout(w, h)
    self.savePopup:SetX(w * .5 - self.savePopup:GetWide() * .5)
end

mvp.ui.Register('mvp.ConfigManager', PANEL, 'EditablePanel')