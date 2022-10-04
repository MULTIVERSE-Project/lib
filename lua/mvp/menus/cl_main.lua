function mvp.Menu()
    local frame = vgui.Create('mvp.Frame')
    frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle('MULTIVERSE Control')
    frame:SetIcon('folder')
    frame:SetPopupStayAtBack(true)

    local content = vgui.Create('EditablePanel', frame)
    content:Dock(FILL)
    content:DockPadding(5, 5, 5, 5)

    local sidebar = vgui.Create('mvp.Sidebar', frame)
    sidebar:Dock(LEFT)
    sidebar:SetStyle(LEFT)

    sidebar:AddButton('house', 'Home', function()
        content:Clear()
    end)
    sidebar:AddButton('gear', 'Config', function()
        content:Clear()

        local manager = vgui.Create('mvp.ConfigManager', content)
        manager:Dock(FILL)

        print('config')
    end)
    sidebar:AddButton('boxes-stacked', 'Modules', function()
        content:Clear()
    end)
    sidebar:AddButton('key', 'Permissions', function()
        content:Clear()
    end)
    sidebar:AddButton('circle-question', 'About', function()
        content:Clear()

        local credits = vgui.Create('EditablePanel', content)
        credits:Dock(TOP)
        credits:SetTall(130)

        function credits:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary'))
            
            draw.SimpleText('MULTIVERSE Library', mvp.utils.GetFont(28, 'Proxima Nova Rg', 500), w * .5 - 100, h * .5 - 10, mvp.Color('accent'), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText('created by Kot', mvp.utils.GetFont(24, 'Proxima Nova Rg', 500), w * .5 - 115, h * .5 + 10, mvp.Color('text_primary'), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            draw.SimpleText('MULTIVERSE Project', mvp.utils.GetFont(28, 'Proxima Nova Rg', 500), w * .5 + 100, h * .5 - 10, mvp.Color('accent'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText('created by Kot & Ben_Bro', mvp.utils.GetFont(24, 'Proxima Nova Rg', 500), w * .5 + 115, h * .5 + 10, mvp.Color('text_primary'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local avatarKotMask = vgui.Create('DPanel', credits)
        avatarKotMask:SetSize(84, 84)
        avatarKotMask:SetPos(0, 0)

        local avatarKot = vgui.Create('AvatarImage', avatarKotMask)
        avatarKot:SetSize(80, 80)
        avatarKot:SetPos(avatarKotMask:GetWide() * .5 - 80 * .5, avatarKotMask:GetTall() * .5 - 80 * .5)
        avatarKot:SetPaintedManually(true)

        avatarKot:SetSteamID('76561198144964099', 128)

        function avatarKotMask:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))
            render.ClearStencil()
            render.SetStencilEnable(true)

            render.SetStencilWriteMask(1)
            render.SetStencilTestMask(1)

            render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
            render.SetStencilPassOperation(STENCILOPERATION_ZERO)
            render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
            render.SetStencilReferenceValue(1)

            draw.NoTexture()
            surface.SetDrawColor(255, 255, 255, 255)
            mvp.utils.DrawCircle(w * .5, h * .5, w * .64, 1, false)

            render.SetStencilFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
            render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
            render.SetStencilReferenceValue(1)

            avatarKot:SetPaintedManually(false)
            avatarKot:PaintManual()
            avatarKot:SetPaintedManually(true)

            render.SetStencilEnable(false)
            render.ClearStencil()
        end

        local avatarBenMask = vgui.Create('DPanel', credits)
        avatarBenMask:SetSize(84, 84)
        avatarBenMask:SetPos(0, 0)

        local avatarBen = vgui.Create('AvatarImage', avatarBenMask)
        avatarBen:SetSize(80, 80)
        avatarBen:SetPos(avatarBenMask:GetWide() * .5 - 80 * .5, avatarBenMask:GetTall() * .5 - 80 * .5)
        avatarBen:SetPaintedManually(true)

        avatarBen:SetSteamID('76561198105599682', 128)

        function avatarBenMask:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary_dark'))
            render.ClearStencil()
            render.SetStencilEnable(true)

            render.SetStencilWriteMask(1)
            render.SetStencilTestMask(1)

            render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
            render.SetStencilPassOperation(STENCILOPERATION_ZERO)
            render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
            render.SetStencilReferenceValue(1)

            draw.NoTexture()
            surface.SetDrawColor(255, 255, 255, 255)
            mvp.utils.DrawCircle(w * .5, h * .5, w * .64, 1, false)

            render.SetStencilFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
            render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
            render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
            render.SetStencilReferenceValue(1)

            avatarBen:SetPaintedManually(false)
            avatarBen:PaintManual()
            avatarBen:SetPaintedManually(true)

            render.SetStencilEnable(false)
            render.ClearStencil()
        end

        local discordButton = vgui.Create('mvp.Button', content)
        discordButton:SetText('Join our Discord')
        discordButton:SetSize(credits:GetWide() * .5 - 10, 32)
        discordButton:SetFont(mvp.utils.GetFont(21, 'Proxima Nova Rg', 500))
        discordButton:SetIcon('discord')
        discordButton:InvalidateLayout(true)

        function credits:PerformLayout(w, h)
            avatarKotMask:SetPos(w * .5 - 84 - 5, h * .5 - 84 * .5)
            avatarBenMask:SetPos(w * .5 + 5, h * .5 - 84 * .5)

            
            discordButton:SetPos(w * .5 + 5 - discordButton:GetWide() * .5, h - discordButton:GetTall() * .5 + 5)
        end

        local changelogs = vgui.Create('DScrollPanel', content)
        changelogs:Dock(FILL)
        changelogs:DockMargin(0, 25, 0, 0)

        local ang = 0

        changelogs.loading = true

        function changelogs:Paint(w, h)
            if not self.loading then return end
            
            ang = ang + FrameTime() * 250
            surface.SetDrawColor(mvp.Color('secondary_text'))
            draw.NoTexture()
            mvp.utils.DrawSubSection(w * .5, h * .5, 32, 5, 0 - ang, 240 - ang, 1, false)
        end

        http.Fetch('https://multiverse-project.com/api/v1/changelogs/all', function(data, _, _, status)
            if status ~= 200 then return end
            changelogs.loading = false

            local response = util.JSONToTable(data)
            PrintTable(response)
            
            for k, v in SortedPairsByMemberValue(response, 'created_at', true) do
                local changelog = vgui.Create('EditablePanel', changelogs)
                changelog:Dock(TOP)
                changelog:SetTall(10)
                changelog:DockMargin(0, 10, 0, 0)

                for k, info in ipairs(v.data.blocks) do
                    
                    info.text = string.Replace(info.data.text or info.data.message, '<br>', '\n')
                end

                local timePublised = os.date('%H:%M, %B %d, %Y', v.created_at / 1000)

                local sizesMap = {
                    [2] = 26,
                    [3] = 30,
                    [4] = 22
                }
                
                function changelog:Paint(w, h)
                    draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary'))
                    local y = 10

                    local _, th = draw.SimpleText(v.title, mvp.utils.GetFont(32, 'Proxima Nova Rg', 500), 10, y, mvp.Color('accent_text'))
                    y = y + th
                    local _, th = draw.SimpleText(timePublised, mvp.utils.GetFont(16, 'Proxima Nova Rg', 500), 10, y, mvp.Color('secondary_text'))
                    y = y + th + 5

                    for k, info in ipairs(v.data.blocks) do
                        if info.type == 'paragraph' then
                            surface.SetFont(mvp.utils.GetFont(18, 'Proxima Nova Rg', 500))

                            local _, lineHeight = surface.GetTextSize('\n')

                            local th = lineHeight
                            for str in string.gmatch(info.text, '\n') do
                                th = th + lineHeight * .5
                            end

                            draw.DrawText(info.text, mvp.utils.GetFont(18, 'Proxima Nova Rg', 500), 15, y, mvp.Color('text'))
                            y = y + th
                        end

                        if info.type == 'header' then
                            local _, th = draw.SimpleText(info.text, mvp.utils.GetFont(sizesMap[info.data.level], 'Proxima Nova Rg', 500), 10, y, mvp.Color('text'))
                            y = y + th
                        end
                    end

                    self:SetTall(y)
                end
            end
        end)
    end)
end