local PANEL = {}

local theme = mvp.themes.GetActive()

AccessorFunc(PANEL, 'keyType', 'KeyType')
AccessorFunc(PANEL, 'valueType', 'ValueType')
AccessorFunc(PANEL, 'keyHint', 'KeyHint')
AccessorFunc(PANEL, 'valueHint', 'ValueHint')

local typesMap = {
    [mvp.type.string] = function(pnl, value, hint)
        local input = vgui.Create('mvp.TextInput', pnl)
        input:SetWide(200)        
        input:DockMargin(10, 0, 10, 0)

        input:SetText(value == 'nil' and '' or value)

        input:SetPlaceholderText(hint)
        input:SetBackgroundColor(mvp.Color('secondary'))

        return input
    end,
    [mvp.type.bool] = function(pnl, value)
        local checkbox = vgui.Create('mvp.Checkbox', pnl)
        checkbox:DockMargin(10, 0, 10, 0)
        checkbox:SetWide(25)

        checkbox:SetValue(value == 'nil' and false or value)

        function checkbox:GetValue()
            return self:GetChecked()
        end

        return checkbox
    end,
}

--- Array manager from the lib. This thing keeps track of the array and allows you to add/remove items from it from the UI.
-- @panel mvp.ArrayManager


function PANEL:Init()
    self.startTime = SysTime()

    self:SetDrawOnTop(true)

    self:SetTitle(mvp.Lang('arrayManagerTitle'))
    self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self:Center()
    self:MakePopup()

    self.hint = vgui.Create('EditablePanel', self)
    self.hint:Dock(TOP)
    self.hint:SetTall(60)

    self.hint.Paint = function(s, w, h)
        local y = 5
        local _, th = draw.SimpleText(mvp.Lang('arrayManagerHint1'), mvp.Font(18, 500), 20, y, mvp.Color('text_secondary'), TEXT_ALIGN_LEFT)
        y = y + th

        local _, th = draw.SimpleText(mvp.Lang('arrayManagerHint2'), mvp.Font(18, 500), 20, y, mvp.Color('text_secondary'), TEXT_ALIGN_LEFT)
        y = y + th

        draw.SimpleText(mvp.Lang('arrayManagerHint3'), mvp.Font(18, 500), 20, y, mvp.Color('text_secondary'), TEXT_ALIGN_LEFT)
    end

    self.add = vgui.Create('mvp.IconButton', self.hint)
    self.add:Dock(RIGHT)
    self.add:SetWide(30)
    self.add:DockMargin(0, 15, 15, 15)

    self.add:SetIcon('plus')
    self.add:SetBackgroundColorHover(mvp.Color('green'))
    self.add:SetOutlineColor(mvp.Color('green'))

    self.add.DoClick = function(s)
        self:AddEntry()
    end

    self.scroll = vgui.Create('DScrollPanel', self)
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(5, 0, 5, 5)

    self.entries = {}
    
end

--- Ads entry into the array manager, that can be edited by user.
-- @tparam string key Key of the entry
-- @tparam any value Value of the entry
-- @treturn Panel EditablePanel with the entry 
function PANEL:AddEntry(key, value)
    local pnl = vgui.Create('EditablePanel', self.scroll)
    pnl:Dock(TOP)
    pnl:SetTall(35)
    pnl:DockMargin(5, 5, 5, 0)
    pnl:DockPadding(0, 5, 0, 5)

    pnl.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, mvp.Color('primary_dark'))
    end

    pnl.remove = vgui.Create('mvp.IconButton', pnl)
    pnl.remove:Dock(RIGHT)
    pnl.remove:SetIcon('trash-can')

    pnl.remove:SetSize(25, 25)

    pnl.remove:SetBackgroundColorHover(mvp.Color('red'))
    pnl.remove:SetOutlineColor(mvp.Color('red'))

    pnl.remove.DoClick = function(s)
        pnl:Remove()
    end

    pnl.key = typesMap[self:GetKeyType()](pnl, mvp.utils.SanitazeType(self:GetKeyType(), key), self:GetKeyHint())
    pnl.key:Dock(LEFT)
    

    pnl.value = typesMap[self:GetValueType()](pnl, mvp.utils.SanitazeType(self:GetValueType(), value), self:GetValueHint())
    pnl.value:Dock(RIGHT)

    self.entries[#self.entries + 1] = pnl

    return pnl
end

function PANEL:Think()
    self:RequestFocus()
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)

    self:DefaultPaint(w, h)
end

--- Called when the array manager is closed/saved.
-- @callback mvp.ArrayManager:OnSave
-- @tparam table value Array that was edited by the user 
function PANEL:OnSave(value)
    
end

function PANEL:OnRemove()
    local t = {}
    for k, v in pairs(self.entries) do 
        if not IsValid(v) then continue end

        if v.key:GetValue() ~= '' and v.value:GetValue() ~= '' then
            t[v.key:GetValue()] = v.value:GetValue()
        end
    end
    self:OnSave(t)
    
    if IsValid(self.blur) then
        self.blur:Remove()
    end
end


mvp.ui.Register('mvp.ArrayManager', PANEL, 'mvp.Frame')