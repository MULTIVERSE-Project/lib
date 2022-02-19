mvp.config = mvp.config or {}
mvp.config.ui = mvp.config.ui or {}
-- mvp.config.ui.versionsCache = nil

surface.CreateFont('mvp.Config.Title', {
    font = 'Proxima Nova Rg',
    size = 24,
    extended = true
})

surface.CreateFont('mvp.Config.Description', {
    font = 'Proxima Nova Rg',
    size = 16,
    extended = true
})

local restoreToDefaultMaterial = Material('mvp/restore.png', 'mips smooth')
local deleteMaterial = Material('mvp/delete.png', 'mips smooth')
local globalMaterial = Material('mvp/global.png', 'mips smooth')

local arrowMaterial = Material('mvp/categoryarrow.png', 'mips smooth')

local function resetButton(panel, input)
    local restoreToDefault = vgui.Create('mvp.Button', panel)

    restoreToDefault:SetWide(24)
    restoreToDefault:SetDrawText(false)

    restoreToDefault:SetPos(250 - 24, 12)

    function restoreToDefault:OnPaint(w, h)
        surface.SetDrawColor(COLOR_WHITE)
        surface.SetMaterial(restoreToDefaultMaterial)

        surface.DrawTexturedRect(w * .5 - 8, h * .5 - 8, 16, 16)
    end

    function restoreToDefault:DoClick()
        input:Reset()
    end
end

local backgroundColor = Color(58, 58, 58)

mvp.config.ui.elements = {
    ['string'] = function(id, defaultValue, curValue, validator)
        local inputGroup = vgui.Create('EditablePanel')
        inputGroup:SetWide(250)
        
        local valueInput = vgui.Create('mvp.TextBox', inputGroup)
        valueInput:SetPlaceholderText(defaultValue)
        valueInput:SetText(curValue)

        valueInput:SetWide(250 - 24)
        valueInput:SetPos(0, 12)

        valueInput.validatorPassed = true

        function valueInput:OnChange()
            local value = self:GetValue()

            local validatorPassed = self:Validate(value)
            
            if not validatorPassed then return end

            if self.CustomSaver then
                self:CustomSaver(value)
                return 
            end

            if timer.Exists('mvp.ConfigDelayEdit' .. id) then
                timer.Remove('mvp.ConfigDelayEdit' .. id)
            end
            timer.Create('mvp.ConfigDelayEdit' .. id, 3, 1, function()
                mvp.config.Set(id, value)
            end)
        end

        function valueInput:PaintOver(w, h)
            if self.validatorPassed then
                return 
            end

            surface.SetDrawColor(COLOR_RED)
            self:DrawOutlinedRect()
        end

        function valueInput:Validate(value)
            local validatorPassed = validator(value, defaultValue)

            self.validatorPassed = validatorPassed

            if not validatorPassed and id and timer.Exists('mvp.ConfigDelayEdit' .. id) then
                timer.Remove('mvp.ConfigDelayEdit' .. id)
            end

            return validatorPassed
        end

        function valueInput:Reset()
            self:SetText(defaultValue)

            mvp.config.Set(id, defaultValue)
            self:Validate(defaultValue)
        end

        return inputGroup, valueInput
    end,
    ['select'] = function(id, defaultValue, curValue, validator, avaibleValues)
        local inputGroup = vgui.Create('EditablePanel')
        inputGroup:SetWide(250)

        local valueInput = vgui.Create('mvp.Combobox', inputGroup)

        valueInput:SetWide(250 - 24)
        valueInput:SetPos(0, 12)
        valueInput.validatorPassed = true

        valueInput:SetValue(avaibleValues[defaultValue] or defaultValue)

        for key, niceName in pairs(avaibleValues) do -- key = internal value, niceName = "niceName" of key
            valueInput:AddChoice(niceName, key, key == curValue)
        end

        function valueInput:OnSelect( index, text, data )
            local validatorPassed = self:Validate(data)
            if not validatorPassed then return end

            if self.CustomSaver then
                self:CustomSaver(data)
                return 
            end

            if timer.Exists('mvp.ConfigDelayEdit' .. id) then
                timer.Remove('mvp.ConfigDelayEdit' .. id)
            end
            timer.Create('mvp.ConfigDelayEdit' .. id, 3, 1, function()
                mvp.config.Set(id, data)
            end)
        end

        function valueInput:PaintOver(w, h)
            if self.validatorPassed then
                return 
            end

            surface.SetDrawColor(COLOR_RED)
            self:DrawOutlinedRect()
        end

        function valueInput:Validate(value)
            local validatorPassed = validator(value, defaultValue, avaibleValues)

            self.validatorPassed = validatorPassed

            if not validatorPassed and id and timer.Exists('mvp.ConfigDelayEdit' .. id) then
                timer.Remove('mvp.ConfigDelayEdit' .. id)
            end

            return validatorPassed
        end

        function valueInput:Reset()
            self:SetValue(avaibleValues[defaultValue] or defaultValue)

            mvp.config.Set(id, defaultValue)
            self:Validate(defaultValue)
        end

        return inputGroup, valueInput
    end,
    ['bool'] = function(id, defaultValue, curValue)
        local inputGroup = vgui.Create('EditablePanel')
        
        inputGroup:SetWide(250)

        local valueInput = vgui.Create('mvp.CheckBoxLabel', inputGroup)
        valueInput:SetText('On/Off')
        valueInput:SetValue(curValue)

        function valueInput:OnChange(checked)
            if self.CustomSaver then
                self:CustomSaver(checked)
                return 
            end

            mvp.config.Set(id, checked)
        end

        valueInput:Dock(RIGHT)
        valueInput:DockMargin(0, 0, 15, 0)

        return inputGroup, valueInput
    end,
    ['number'] = function(id, defaultValue, curValue, validator)
        local inputGroup = vgui.Create('EditablePanel')
        inputGroup:SetWide(250)

        local valueInput = vgui.Create('mvp.TextBox', inputGroup)
        valueInput:SetPlaceholderText(tostring(defaultValue))
        valueInput:SetText(tostring(curValue))
        -- valueInput:SetNumeric(true)

        valueInput:SetWide(250 - 24)
        valueInput:SetPos(0, 12)
        valueInput.validatorPassed = true

        function valueInput:OnChange()
            local value = tonumber(self:GetValue())

            local validatorPassed = self:Validate(value)

            if not validatorPassed then return end

            if self.CustomSaver then
                self:CustomSaver(value)
                return 
            end

            if timer.Exists('mvp.ConfigDelayEdit' .. id) then
                timer.Remove('mvp.ConfigDelayEdit' .. id)
            end
            timer.Create('mvp.ConfigDelayEdit' .. id, 3, 1, function()
                mvp.config.Set(id, value)
            end)
        end

        function valueInput:PaintOver(w, h)
            if self.validatorPassed then
                return 
            end

            surface.SetDrawColor(COLOR_RED)
            self:DrawOutlinedRect()
        end

        function valueInput:Validate(value)
            local validatorPassed = validator(value, defaultValue)

            self.validatorPassed = validatorPassed

            if not validatorPassed and id and timer.Exists('mvp.ConfigDelayEdit' .. id) then
                timer.Remove('mvp.ConfigDelayEdit' .. id)
            end

            return validatorPassed
        end

        function valueInput:Reset()
            self:SetText(tostring(defaultValue))

            mvp.config.Set(id, defaultValue)
            self:Validate(defaultValue)
        end

        return inputGroup, valueInput
    end
}

mvp.config.ui.types = {
    ['string'] = function(id, configEntry)
        if not configEntry then
            return 
        end

        local description = configEntry.description

        local defaultValue = configEntry.default
        local curValue = configEntry.value

        local validator = configEntry.validator or mvp.config.validators['string']

        local entryBasePanel = vgui.Create('EditablePanel')
        entryBasePanel:Dock(TOP)
        entryBasePanel:SetTall(45)

        function entryBasePanel:Paint(w, h)
            surface.SetDrawColor(backgroundColor)
            surface.DrawRect(0, 0, w, h)
            
            draw.SimpleText(mvp.language.Get(id), 'mvp.Config.Title', not configEntry.serverOnly and 36 or 15, 3, COLOR_WHITE)
            draw.SimpleText(mvp.language.Get(description), 'mvp.Config.Description', 15, 24, COLOR_WHITE)

            if not configEntry.serverOnly then
                surface.SetDrawColor(Color(253, 206, 77))
                surface.SetMaterial(globalMaterial)

                surface.DrawTexturedRect(15, 6, 16, 16)
            end
        end

        local inputGroup, valueInput = mvp.config.ui.elements['string'](id, defaultValue, curValue, validator)

        entryBasePanel:Add(inputGroup)

        inputGroup:Dock(RIGHT)
        inputGroup:DockMargin(0, 0, 15, 0)

        resetButton(inputGroup, valueInput)

        return entryBasePanel
    end,
    ['select'] = function(id, configEntry)
        if not configEntry then
            return 
        end

        local description = configEntry.description

        local defaultValue = configEntry.default
        local curValue = configEntry.value

        local avaibleValues = {}

        if configEntry.data.from and isfunction(configEntry.data.from) then
            avaibleValues = configEntry.data.from()
        else
            avaibleValues = configEntry.data.from
        end

        local validator = configEntry.validator or mvp.config.validators['select']

        local entryBasePanel = vgui.Create('EditablePanel')
        entryBasePanel:Dock(TOP)
        entryBasePanel:SetTall(45)

        function entryBasePanel:Paint(w, h)
            surface.SetDrawColor(backgroundColor)
            surface.DrawRect(0, 0, w, h)
            
            draw.SimpleText(mvp.language.Get(id), 'mvp.Config.Title', not configEntry.serverOnly and 36 or 15, 3, COLOR_WHITE)
            draw.SimpleText(mvp.language.Get(description), 'mvp.Config.Description', 15, 24, COLOR_WHITE)

            if not configEntry.serverOnly then
                surface.SetDrawColor(Color(253, 206, 77))
                surface.SetMaterial(globalMaterial)

                surface.DrawTexturedRect(15, 6, 16, 16)
            end
        end

        local inputGroup, valueInput = mvp.config.ui.elements['select'](id, defaultValue, curValue, validator, avaibleValues)

        entryBasePanel:Add(inputGroup)

        inputGroup:Dock(RIGHT)
        inputGroup:DockMargin(0, 0, 15, 0)

        resetButton(inputGroup, valueInput)

        return entryBasePanel
    end,
    ['bool'] = function(id, configEntry)
        if not configEntry then
            return 
        end

        local description = configEntry.description

        local defaultValue = configEntry.default
        local curValue = configEntry.value

        -- we don't need validator here bruh

        local entryBasePanel = vgui.Create('EditablePanel')
        entryBasePanel:Dock(TOP)
        entryBasePanel:SetTall(45)

        function entryBasePanel:Paint(w, h)
            surface.SetDrawColor(backgroundColor)
            surface.DrawRect(0, 0, w, h)
            
            draw.SimpleText(mvp.language.Get(id), 'mvp.Config.Title', not configEntry.serverOnly and 36 or 15, 3, COLOR_WHITE)
            draw.SimpleText(mvp.language.Get(description), 'mvp.Config.Description', 15, 24, COLOR_WHITE)

            if not configEntry.serverOnly then
                surface.SetDrawColor(Color(253, 206, 77))
                surface.SetMaterial(globalMaterial)

                surface.DrawTexturedRect(15, 6, 16, 16)
            end
        end

        local inputGroup, valueInput = mvp.config.ui.elements['bool'](id, defaultValue, curValue)

        entryBasePanel:Add(inputGroup)

        inputGroup:Dock(RIGHT)
        inputGroup:DockMargin(0, 0, 15, 0)

        return entryBasePanel
    end,
    ['number'] = function(id, configEntry)
        if not configEntry then
            return 
        end

        local description = configEntry.description

        local defaultValue = configEntry.default
        local curValue = configEntry.value

        local validator = configEntry.validator or mvp.config.validators['number']

        local entryBasePanel = vgui.Create('EditablePanel')
        entryBasePanel:Dock(TOP)
        entryBasePanel:SetTall(45)

        function entryBasePanel:Paint(w, h)
            surface.SetDrawColor(backgroundColor)
            surface.DrawRect(0, 0, w, h)
            
            draw.SimpleText(mvp.language.Get(id), 'mvp.Config.Title', not configEntry.serverOnly and 36 or 15, 3, COLOR_WHITE)
            draw.SimpleText(mvp.language.Get(description), 'mvp.Config.Description', 15, 24, COLOR_WHITE)

            if not configEntry.serverOnly then
                surface.SetDrawColor(Color(253, 206, 77))
                surface.SetMaterial(globalMaterial)

                surface.DrawTexturedRect(15, 6, 16, 16)
            end
        end

        local inputGroup, valueInput = mvp.config.ui.elements['number'](id, defaultValue, curValue, validator)

        entryBasePanel:Add(inputGroup)

        inputGroup:Dock(RIGHT)
        inputGroup:DockMargin(0, 0, 15, 0)

        resetButton(inputGroup, valueInput)

        return entryBasePanel
    end,
    ['keyvaluetable'] = function(id, configEntry)
        if not configEntry then
            return 
        end

        local description = configEntry.description

        local defaultValue = configEntry.default
        local curValue = configEntry.value

        local tableStruct = configEntry.data.tableStructure

        local validator = configEntry.validator or function(value)
            return (value ~= nil) and (value ~= '') and type(value) == type(defaultValue)
        end

        local entryBasePanel = vgui.Create('EditablePanel')
        entryBasePanel:Dock(TOP)
        entryBasePanel:SetTall(90)

        function entryBasePanel:Paint(w, h)
            surface.SetDrawColor(backgroundColor)
            surface.DrawRect(0, 0, w, h)
            
            draw.SimpleText(mvp.language.Get(id), 'mvp.Config.Title', not configEntry.serverOnly and 36 or 15, 3, COLOR_WHITE)
            draw.SimpleText(mvp.language.Get(description), 'mvp.Config.Description', 15, 24, COLOR_WHITE)

            if not configEntry.serverOnly then
                surface.SetDrawColor(Color(253, 206, 77))
                surface.SetMaterial(globalMaterial)

                surface.DrawTexturedRect(15, 6, 16, 16)
            end
        end

        local keyInputHandler = mvp.config.ui.elements[tableStruct.key.type]
        local valueInputHandler = mvp.config.ui.elements[tableStruct.value.type]

        local inputs = vgui.Create('EditablePanel', entryBasePanel)
        inputs:Dock(TOP)
        inputs:DockMargin(0, 45, 0, 0)
        inputs:SetTall(450)

        local valuesCounter = 0

        local keyData = tableStruct.key
        local valueData = tableStruct.value

        local newConfigValue = table.Copy(curValue)

        local function recalculateTall()
            inputs:SetTall(35 * valuesCounter)
            entryBasePanel:SetTall(35 * valuesCounter + 110)

            entryBasePanel:GetParent():InvalidateParent()
        end

        local wrongValueEntry
        local hightlightWrongEntry = false

        local function addEntry(key, value)
            valuesCounter = valuesCounter + 1

            local tempValue

            local keyValueGroup = vgui.Create('EditablePanel', inputs)
            keyValueGroup:Dock(TOP)
            keyValueGroup:SetTall(35)

            function keyValueGroup:Paint(w, h)
                if wrongValueEntry ~= self or not hightlightWrongEntry then return end

                local colMultiplier = math.sin(CurTime() * 2) * 0.5 + 0.5

                local col = Color(255 * colMultiplier, 0, 0, 50 * colMultiplier)

                surface.SetDrawColor(col)
                surface.DrawRect(0, 11, w, h)
            end

            -- id, defaultValue, curValue, validator, avaibleValues

            local id = nil
            local defaultValue = keyData.default
            local curValue = key or ''
            local originalValidator = keyData.validator or mvp.config.validators[keyData.type] or function() return true end

            local validator = function(value, defaultValue)
                local uniqueValidatorCheck = true
                local originalValidatorCheck = originalValidator(value, defaultValue)

                if not originalValidatorCheck then
                    wrongValueEntry = keyValueGroup
                end

                if newConfigValue[value] and value ~= key then
                    uniqueValidatorCheck = false

                    wrongValueEntry = keyValueGroup
                    return 
                end

                return originalValidatorCheck and uniqueValidatorCheck
            end

            local avaibleValues = {}

            if keyData.from and isfunction(keyData.from) then
                avaibleValues = keyData.from()
            elseif keyData.from then
                avaibleValues = keyData.from
            end

            local keyInputGroup, keyInput = keyInputHandler(id, defaultValue, curValue, validator, avaibleValues)

            keyValueGroup:Add(keyInputGroup)
            
            keyInputGroup:Dock(LEFT)
            keyInputGroup:DockMargin(15, 0, 0, 0)
            keyInputGroup:SetWide(350)
            keyInput:SetWide(350)

            function keyInput:CustomSaver(value)
                newConfigValue[value] = newConfigValue[key] or tempValue or valueData.default or ''
                
                tempValue = nil

                self.validatorPassed = true
                wrongValueEntry = nil

                key = value
            end

            local id = nil
            local defaultValue = valueData.default
            local curValue = value
            local validator = valueData.validator or mvp.config.validators[valueData.type] or function() return true end

            local avaibleValues = {}

            if valueData.from and isfunction(valueData.from) then
                avaibleValues = valueData.from()
            elseif valueData.from then
                avaibleValues = valueData.from
            end
            
            local valueInputGroup, valueInput = valueInputHandler(id, defaultValue, curValue, validator, avaibleValues)

            keyValueGroup:Add(valueInputGroup)
            
            valueInputGroup:Dock(RIGHT)
            valueInputGroup:DockMargin(0, 0, 15, 0)

            function valueInput:CustomSaver(value)
                

                if not newConfigValue[key] then
                    tempValue = value
                    return 
                end

                newConfigValue[key] = value
            end

            local deleteButton = vgui.Create('mvp.Button', valueInputGroup)

            deleteButton:SetWide(24)
            deleteButton:SetDrawText(false)

            deleteButton:SetPos(250 - 24, 12)

            function deleteButton:OnPaint(w, h)
                surface.SetDrawColor(COLOR_WHITE)
                surface.SetMaterial(deleteMaterial)

                surface.DrawTexturedRect(w * .5 - 8, h * .5 - 8, 16, 16)
            end

            function deleteButton:DoClick()
                if newConfigValue[key] then
                    newConfigValue[key] = nil
                end

                valuesCounter = valuesCounter - 1

                keyValueGroup:Remove()
                recalculateTall()
            end
        end

        for key, value in pairs(curValue) do
            addEntry(key, value)
        end

        local addButton = vgui.Create('mvp.Button', entryBasePanel)
        addButton:Dock(TOP)
        addButton:DockMargin(15, 5, 15, 0)
        addButton:SetText('Add new entry!')

        function addButton:DoClick()
            addEntry()
            recalculateTall()
        end

        local saveButton = vgui.Create('mvp.Button', entryBasePanel)
        saveButton:Dock(TOP)
        saveButton:DockMargin(15, 5, 15, 0)
        saveButton:SetText('Save!')

        function saveButton:Think()
            
        end

        function saveButton:DoClick()
            if IsValid(wrongValueEntry) then
                hightlightWrongEntry = true
                return 
            end
            hightlightWrongEntry = false

            mvp.config.Set(id, newConfigValue)
        end

        recalculateTall()

        return entryBasePanel
    end
}

function mvp.config.ui.AddItems(category, configItems)
    local categoryContents = vgui.Create('EditablePanel')
    
    for k, v in pairs(configItems) do
        if not mvp.config.ui.types[v.data.type] then continue end

        local panel = mvp.config.ui.types[v.data.type](k, v)

        panel:DockMargin(0, 0, 0, 3)
        
        categoryContents:Add(panel):Dock(TOP)
    end

    category:SetContents(categoryContents)
end

local menuMat = Material('mvp/menu.png', 'smooth mips')
local blur = Material('pp/blurscreen')



function mvp.config.ui.Config()
    local categories = {}

    /*
        Parsing config values to categories
    */
    for configKey, configValue in pairs(mvp.config.stored) do
        local categoryName

        if configValue.onlyServer then
            continue 
        end

        if not configValue.data.category then
            local otherCategoryLocal = mvp.language.Get('config#Other')

            if not categories[otherCategoryLocal] then
                categories[otherCategoryLocal] = {}
            end
            
            categoryName = otherCategoryLocal
        else
            local categoryLocal = mvp.language.Get(configValue.data.category)

            if not categories[categoryLocal] then
                categories[categoryLocal] = {}
            end

            categoryName = categoryLocal
        end
        
        categories[categoryName][configKey] = configValue
    end

    local categoriesList = vgui.Create('DCategoryList', mvp.config.ui.content)
    categoriesList:Dock(FILL)

    local disclaimer = vgui.Create('DPanel', mvp.config.ui.content)
    disclaimer:Dock(TOP)
    disclaimer:SetTall(30)

    function disclaimer:Paint(w, h)
        draw.SimpleText(mvp.language.Get('config#Configuration'), 'mvp.Config.Title', w * .5, h * .5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    for categoryTitle, configItems in pairs(categories) do
        local categoryPanel = categoriesList:Add(categoryTitle)

        local vbar = categoriesList:GetVBar()

        vbar:SetWide(8)
        vbar:SetHideButtons(true)
        function vbar:Paint(w, h)
            draw.RoundedBox(5, 0, 0, w, h, Color(51, 51, 51))
        end
        function vbar.btnGrip:Paint(w, h)
            draw.RoundedBox(5, 0, 0, w, h, (self:IsHovered() or self.Depressed) and Color(75, 75, 75) or Color(65, 65, 65))
        end

        categoryPanel:SetHeaderHeight(36)
        categoryPanel.Paint = nil

        /*
            Header stuff
        */
        categoryPanel.Header:SetFont('mvp.Config.Title')
        function categoryPanel.Header:UpdateColours( skin )

            if ( !self:GetParent():GetExpanded() ) then
                self:SetExpensiveShadow( 0, Color( 0, 0, 0, 200 ) )
                return self:SetTextStyleColor( Color(150, 150, 150) )
            end
    
            self:SetExpensiveShadow( 1, Color( 0, 0, 0, 100 ) )
            return self:SetTextStyleColor( skin.Colours.Category.Header )
    
        end
        function categoryPanel.Header:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(82, 82, 82))
            
            surface.SetMaterial(arrowMaterial)

            surface.SetDrawColor(Color(253, 206, 77))
            
            self.deg = Lerp(FrameTime() * 15, self.deg or 0, categoryPanel:GetExpanded() and 0 or 180)
            surface.DrawTexturedRectRotated(w - 18, h * .5, 16, 16, self.deg)
        end

        mvp.config.ui.AddItems(categoryPanel, configItems)
    end
    categoriesList:InvalidateLayout( true )

    categoriesList.Paint = nil
end

function mvp.config.ui.Modules()
    if not mvp.config.ui.versionsCache then
        http.Fetch('https://raw.githubusercontent.com/Kotyarishka/mvp-versions/main/info.json', function(data)
            mvp.config.ui.versionsCache = util.JSONToTable(data)
        end)
    end

    local scroll = vgui.Create('DScrollPanel', mvp.config.ui.content)
    scroll:Dock(FILL)

    local vbar = scroll:GetVBar()

    vbar:SetWide(8)
    vbar:SetHideButtons(true)
    function vbar:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(51, 51, 51))
    end
    function vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, (self:IsHovered() or self.Depressed) and Color(75, 75, 75) or Color(65, 65, 65))
    end

    local disclaimer = vgui.Create('DPanel', mvp.config.ui.content)
    disclaimer:Dock(TOP)
    disclaimer:SetTall(30)

    function disclaimer:Paint(w, h)
        draw.SimpleText(mvp.language.Get('config#Modules'), 'mvp.Config.Title', w * .5, h * .5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local refresh = vgui.Create('mvp.Button', mvp.config.ui.content)
    refresh:Dock(TOP)
    refresh:DockMargin(2, 5, 2, 5)
    refresh:SetText(mvp.language.Get('config#ModulesRefresh'))
    refresh:SetTall(30)

    function refresh:DoClick()
        mvp.config.ui.versionsCache = nil

        http.Fetch('https://raw.githubusercontent.com/Kotyarishka/mvp-versions/main/info.json', function(data)
            mvp.config.ui.versionsCache = util.JSONToTable(data)
        end)
    end

    local function addModule(id, icon, name, description, author, version)
        local panel = scroll:Add('EditablePanel')

        panel:SetTall(132)
        panel:Dock(TOP)
        panel:DockMargin(2, 0, 2, 3)

        local mat

        if icon then
            mat = icon
        else
            mat = Material('mvp/m_icons/' .. id .. '.png')
        end

        function panel:Paint(w, h)
            self.text = self.text or mvp.utils.TextWrap(description, 'mvp.Config.Description', w - 138)
            local versionsCache = mvp.config.ui.versionsCache or {}
            surface.SetDrawColor(Color(55, 55, 55))
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(COLOR_WHITE)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(2, 2, 128, h - 4)

            local nameWidth = draw.SimpleText(name, 'mvp.Config.Title', 128 + 5, 5, COLOR_WHITE)

            draw.DrawText(self.text or 'Module doesn\'t have description yet!', 'mvp.Config.Description', 128 + 5, 25, COLOR_WHITE)

            draw.SimpleText(Format(mvp.language.Get('config#ModulesAuthor'), author), 'mvp.Config.Description', 128 + 5, h - 35, COLOR_WHITE, TEXT_ALIGN_BOTTOM)

            draw.SimpleText(version, 'mvp.Config.Description', 128 + 10 + nameWidth, 11, COLOR_WHITE)

            

            if mvp.config.ui.versionsCache == nil then
                draw.SimpleText(mvp.language.Get('config#ModulesFetching'), 'mvp.Config.Description', 128 + 5, h - 5, COLOR_WHITE, nil, TEXT_ALIGN_BOTTOM)
                return 
            end

            local isUpToDate = version == versionsCache[id]
            local color = COLOR_RED
            local text = mvp.language.Get('config#ModulesNoInformation')

            if versionsCache[id] then
                color = isUpToDate and COLOR_GREEN or COLOR_YELLOW
                text = isUpToDate and mvp.language.Get('config#ModulesUpToDate') or mvp.language.Get('config#ModulesNeedsUpdate') .. Format(mvp.language.Get('config#ModulesNewVersion'), versionsCache[id])
            end

            draw.NoTexture()
            surface.SetDrawColor(ColorAlpha(color, 50))
            mvp.ui.drawCircle( 128 + 10, h - 14, 6, 10, false)
            surface.SetDrawColor(ColorAlpha(color, 250))
            mvp.ui.drawCircle( 128 + 10, h - 14, 3, 10, false)

            draw.SimpleText(text, 'mvp.Config.Description', 128 + 18, h - 5, color, nil, TEXT_ALIGN_BOTTOM)
        end
    end

    addModule('base', Material('mvp/m_icons/base.png'), mvp.name, mvp.description, mvp.author, mvp.version)

    for id, m in pairs(mvp.module.list) do
        addModule(id, m.icon, m.name, m.description, m.author, m.version)
    end
end

function mvp.config.ui.Permissions()
    local scroll = vgui.Create('DScrollPanel', mvp.config.ui.content)
    scroll:Dock(FILL)

    local disclaimer = vgui.Create('DPanel', mvp.config.ui.content)
    disclaimer:Dock(TOP)
    disclaimer:SetTall(30)

    function disclaimer:Paint(w, h)
        draw.SimpleText(mvp.language.Get('config#Permissions'), 'mvp.Config.Title', w * .5, h * .5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local function addPermission(name, description, default)
        local panel = scroll:Add('EditablePanel')

        panel:SetTall(60)
        panel:DockMargin(0, 0, 0, 3)
        panel:Dock(TOP)

        function panel:Paint(w, h)
            surface.SetDrawColor(Color(55, 55, 55))
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(name, 'mvp.Config.Title', 5, 5, COLOR_WHITE)
            draw.SimpleText(description or 'Module doesn\'t have description yet!', 'mvp.Config.Description', 5, 25, COLOR_WHITE)
            draw.SimpleText(Format(mvp.language.Get('config#PermissionsDefaultAccess'), default), 'mvp.Config.Description', 5, 40, COLOR_WHITE)
            
        end
    end

    for id, permission in pairs(mvp.permission.GetLibPermissions()) do
        addPermission(permission.Name, permission.Description, permission.MinAccess)
    end
end

function mvp.config.ui.Open(shouldReturn)
    local buttons = {
        {
            name = mvp.language.Get('config#MenuConfig'),
            icon = Material('mvp/config.png', 'smooth mips'),
            click = function()
                mvp.config.ui.Config()
            end
        },
        {
            name = mvp.language.Get('config#MenuModules'),
            icon = Material('mvp/modules.png', 'smooth mips'),
            click = function()
                mvp.config.ui.Modules()
            end
        },
        {
            name = mvp.language.Get('config#MenuPermissions'),
            icon = Material('mvp/permissions.png', 'smooth mips'),
            click = function()
                mvp.config.ui.Permissions()
            end
        }
    }

    local frame

    if shouldReturn then
        frame = vgui.Create('EditablePanel')
    else
        frame = vgui.Create('mvp.Frame')
        frame:SetSize(ScrW() * .6, ScrH() * .7)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle('MVP Base Settings')
        frame:DockPadding( 32, 24 + 5, 5, 5 )
    end

    frame.blur = nil

    local sideblock = vgui.Create('EditablePanel', frame)
    -- sideblock:Dock(LEFT)
    -- sideblock:DockMargin(0, -3, 3, -5)
    sideblock:SetPos(0, 26)
    -- sideblock:SetWide(32)
    sideblock:SetSize(32, frame:GetTall() - 26)
    sideblock:SetZPos(100)

    function sideblock:Paint(w, h)
        surface.SetDrawColor(Color(49, 49, 49))
        surface.DrawRect(0, 0, w, h)
    end

    sideblock.opened = false

    local scroll = vgui.Create('DScrollPanel', sideblock)
    scroll:Dock(FILL)

    local vbar = scroll:GetVBar()

    vbar:SetWide(8)
    vbar:SetHideButtons(true)
    vbar:DockMargin(2, 0, 0, 0)
    function vbar:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(51, 51, 51))
    end
    function vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, (self:IsHovered() or self.Depressed) and Color(75, 75, 75) or Color(65, 65, 65))
    end

    local menuToggle = vgui.Create('mvp.Button')
    menuToggle:Dock(TOP)
    menuToggle:DockMargin(0, 0, 0, 0)
    menuToggle:SetText('')
    menuToggle:SetTall(32)
    menuToggle.textOpacity = 0

    scroll:AddItem(menuToggle)

    function menuToggle:OnPaint(w, h)
        surface.SetMaterial(menuMat)
        surface.SetDrawColor(COLOR_WHITE)
        surface.DrawTexturedRect(32 * .5 - 12, h * .5 - 12, 24, 24)

        if sideblock.opened then
            self.textOpacity = Lerp(FrameTime() * 15, self.textOpacity, 255)
        else
            self.textOpacity = Lerp(FrameTime() * 15, self.textOpacity, 0)
        end

        draw.SimpleText('Close', 'mvp.Button', 32, h * .5, Color(255, 255, 255, self.textOpacity), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    function menuToggle:DoClick()
        if sideblock.opened then
            self:CloseMenu()    
            return
        end

        self:OpenMenu()
    end

    function menuToggle:OpenMenu()
        sideblock:SizeTo(frame:GetWide() * .2, sideblock:GetTall(), .3, 0)
        
        frame.blur = vgui.Create('DPanel', frame)
        frame.blur:Dock(FILL)
        frame.blur:SetAlpha(0)
        frame.blur:AlphaTo(255, .3)

        function frame.blur:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            local scrW, scrH = ScrW(), ScrH()

            surface.SetDrawColor(Color(0, 0, 0, 150))
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(COLOR_WHITE)
            surface.SetMaterial(blur)

            for i = 1, 3 do
                blur:SetFloat('$blur', (i / 3) * 2)
                blur:Recompute()

                render.UpdateScreenEffectTexture()
                surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
            end
        end

        sideblock.opened = true
    end

    function menuToggle:CloseMenu()
        sideblock:SizeTo(vbar.Enabled and 40 or 32, sideblock:GetTall(), .3, 0, nil, function()
            sideblock.opened = false
        end)

        

        if IsValid(frame.blur) then
            frame.blur:AlphaTo(0, .3, nil, function(_, self)
                self:Remove()
            end)
        end
    end

    for k, v in pairs(buttons) do
        local button = vgui.Create('mvp.Button')
        button:Dock(TOP)
        button:SetText('')
        button:SetTall(32)
        button.textOpacity = 0
    
        function button:OnPaint(w, h)
            surface.SetMaterial(v.icon)
            surface.SetDrawColor(COLOR_WHITE)
            surface.DrawTexturedRect(32 * .5 - 12, h * .5 - 12, 24, 24)
    
            if sideblock.opened then
                self.textOpacity = Lerp(FrameTime() * 3, self.textOpacity, 255)
            else
                self.textOpacity = Lerp(FrameTime() * 15, self.textOpacity, 0)
            end
    
            draw.SimpleText(v.name, 'mvp.Button', 32, h * .5, Color(255, 255, 255, self.textOpacity), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        function button:DoClick()
            mvp.config.ui.content:Clear()
            menuToggle:CloseMenu()

            v.click()
        end

        scroll:AddItem(button)
    end

    function sideblock:Think()
        if vbar.Enabled and not self.opened then
            self:SetWide(40)
            mvp.config.ui.content:DockMargin(11, 0, 0, 0)
        end
    end
    
    local content = vgui.Create('EditablePanel', frame)
    content:Dock(FILL)
    content:DockMargin(3, 0, 0, 0)

    mvp.config.ui.content = content

    mvp.config.ui.Config()

    return frame
end

hook.Add('OnPlayerChat', 'mvp.hooks.OpenConfig', function(ply, text)  
    if ply ~= LocalPlayer() then return end
    
    if string.Trim(string.lower(text)) ~= mvp.config.Get('mvpCommand') then return end
    if not mvp.permission.Check(ply, 'mvp/EditConfigs') then return end

    mvp.config.ui.Open(false)
    return true
end)