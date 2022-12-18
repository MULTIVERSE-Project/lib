local PANEL = {}
AccessorFunc(PANEL, 'horizontalMargin', 'HorizontalMargin', FORCE_NUMBER)
AccessorFunc(PANEL, 'verticalMargin', 'VerticalMargin', FORCE_NUMBER)
AccessorFunc(PANEL, 'columns', 'Columns', FORCE_NUMBER)

function PANEL:Init()
    self:SetHorizontalMargin(0)
    self:SetVerticalMargin(0)
    self.Rows = {}
    self.Cells = {}
end

function PANEL:AddCell(pnl)
    local cols = self:GetColumns()
    local idx = math.floor(#self.Cells / cols) + 1
    self.Rows[idx] = self.Rows[idx] or self:CreateRow()
    local margin = self:GetHorizontalMargin()
    pnl:SetParent(self.Rows[idx])
    pnl:Dock(LEFT)
    pnl:DockMargin(0, 0, #self.Rows[idx].Items + 1 < cols and self:GetHorizontalMargin() or 0, 0)
    pnl:SetWide((self:GetWide() - margin * (cols - 1)) / cols)
    table.insert(self.Rows[idx].Items, pnl)
    table.insert(self.Cells, pnl)
    self:CalculateRowHeight(self.Rows[idx])
end

function PANEL:CreateRow()
    local row = self:Add('DPanel')
    row:Dock(TOP)
    row:DockMargin(0, 0, 0, self:GetVerticalMargin())
    row.Paint = nil
    row.Items = {}

    return row
end

function PANEL:CalculateRowHeight(row)
    local height = 0

    for k, v in pairs(row.Items) do
        height = math.max(height, v:GetTall())
    end

    row:SetTall(height)
end

function PANEL:Skip()
    local cell = vgui.Create('DPanel')
    cell.Paint = nil
    self:AddCell(cell)
end

function PANEL:Clear()
    for _, row in pairs(self.Rows) do
        for _, cell in pairs(row.Items) do
            cell:Remove()
        end

        row:Remove()
    end

    self.Cells, self.Rows = {}, {}
end

function PANEL:PerformLayout(w, h)
    local cols = self:GetColumns()
    local margin = self:GetHorizontalMargin()

    for k, v in pairs(self.Rows) do
        for k2, v2 in pairs(v.Items) do
            v2:SetWide((self:GetWide() - margin * (cols - 1)) / cols)
        end
    end
end

PANEL.OnRemove = PANEL.Clear
vgui.Register('ThreeGrid', PANEL, 'EditablePanel')