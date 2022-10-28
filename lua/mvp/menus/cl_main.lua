local function openDiscord()
    gui.OpenURL('https://discord.multiverse-project.com')
end 

local function createQuickActions(actionsPnl, title, buttons)
    local actions = vgui.Create('EditablePanel', actionsPnl)
    actions:Dock(LEFT)

    local base = vgui.Create('EditablePanel', actions)
    base:Dock(TOP)
    base:DockPadding(0, 25, 0, 5)
    base:DockMargin(3, 0, 3, 0)

    function base:Paint(w, h)
        draw.RoundedBox(4, 0, 20, w, h - 20, mvp.Color('secondary_dark'))

        draw.SimpleText(title, mvp.utils.GetFont(16, 'Proxima Nova Rg'), 0, 3, mvp.Color('text'))
    end

    for k, v in pairs(buttons) do
        local btn = vgui.Create('mvp.Button', base)
        btn:Dock(TOP)
        btn:SetText(v.text)

        if v.color then
            btn:SetTextColor(v.color)
        end

        if v.click then
            function btn:DoClick()
                v.click()
            end
        end

        if v.icon then
            btn:SetIcon(v.icon)
        end

        btn:SetBackgroundColor(Color(77, 77, 77, 0))
        btn:SetBackgroundColorHover(Color(126, 126, 126, 86))
        btn:SetNoDrawOutline(true)

        btn:SetBorderRadius(0)
    end

    actions:InvalidateLayout(true)

    function base:PerformLayout(w, h)
        self:SetTall(#self:GetChildren() * 22 + 30)
        actions.myTall = #self:GetChildren() * 22 + 30 + 40
    end
end

local function createHomeContent(content)
    local welcome = vgui.Create('EditablePanel', content)
    welcome:Dock(TOP)
    welcome:SetTall(80)

    function welcome:Paint(w, h)

        surface.SetFont(mvp.utils.GetFont(28, 'Proxima Nova Rg'))
		local tw, th = surface.GetTextSize(mvp.Lang('menuWelcomeText1', LocalPlayer():Name()))

		surface.SetFont(mvp.utils.GetFont(18, 'Proxima Nova Rg'))
		local bw, bh = surface.GetTextSize(mvp.Lang('menuWelcomeText2'))

		local y1, y2 = h / 2 - bh / 2, h  / 2 + th / 2

        draw.SimpleText(mvp.Lang('menuWelcomeText1', LocalPlayer():Name()), mvp.utils.GetFont(28, 'Proxima Nova Rg'), 90, y1 + 8, mvp.Color('text'), nil, TEXT_ALIGN_CENTER)
        draw.SimpleText(mvp.Lang('menuWelcomeText2'), mvp.utils.GetFont(18, 'Proxima Nova Rg'), 90, y2 + 8, mvp.Color('text'), nil, TEXT_ALIGN_CENTER)
    end

    local avatarMask = vgui.Create('DPanel', content)
    avatarMask:SetSize(84, 84)
    avatarMask:SetPos(5, 8)

    local avatarKot = vgui.Create('AvatarImage', avatarMask)
    avatarKot:SetSize(80, 80)
    avatarKot:SetPos(avatarMask:GetWide() * .5 - 80 * .5, avatarMask:GetTall() * .5 - 80 * .5)
    avatarKot:SetPaintedManually(true)

    avatarKot:SetPlayer(LocalPlayer(), 128)

    function avatarMask:Paint(w, h)
        draw.RoundedBox(6, 0, 0, w, h, mvp.Color('secondary_dark'))
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

    local actionsMenus = vgui.Create('EditablePanel', content)
    actionsMenus:Dock(TOP)
    actionsMenus:DockPadding(5, 30, 5, 5)
    actionsMenus:SetTall(350)
    actionsMenus:DockMargin(3, 15, 3, 3)

    function actionsMenus:Paint(w, h)
        draw.RoundedBox(4, 0, 15, w, h - 15, mvp.Color('accent'))
        draw.RoundedBox(4, 1, 15 + 1, w - 2, h - 15 - 2, mvp.Color('secondary'))

        surface.SetFont(mvp.utils.GetFont(18, 'Proxima Nova Rg'))
        local tw, th = surface.GetTextSize(mvp.Lang('menuQuickActions'))

        draw.RoundedBox(5, 10 - 3 - 2, 15 - th * .5 - 3, tw + 10 + 6 + 4, th + 6, mvp.Color('accent'))
        draw.RoundedBox(4, 10 - 3, 15 - th * .5 - 3, tw + 10 + 6, th + 6, mvp.Color('secondary_dark'))

        draw.SimpleText(mvp.Lang('menuQuickActions'), mvp.utils.GetFont(18, 'Proxima Nova Rg'), 10 + 5, 15, mvp.Color('text'), nil, TEXT_ALIGN_CENTER)
    end

    createQuickActions(actionsMenus, mvp.Lang('menuConfig'), {
        {text = mvp.Lang('menuEditConfig'), click = function()
            content:Clear()

            local manager = vgui.Create('mvp.ConfigManager', content)
            manager:Dock(FILL)
        end, icon = 'f013'},
        {text = mvp.Lang('menuReloadLibConfig'), icon = 'f2f9'},
        {text = mvp.Lang('menuReloadModulesConfig'), icon = 'f2f9'},
        {text = mvp.Lang('menuConfigDump'), color = mvp.Color('yellow'), icon = 'f1c0'},
        
    })

    createQuickActions(actionsMenus, mvp.Lang('menuModules'), {
        {text = mvp.Lang('menuReloadModules'), icon = 'f2f9'},
        {text = mvp.Lang('menuCheckUpdates'), color = mvp.Color('green'), icon = 'f002'}
    })

    createQuickActions(actionsMenus, mvp.Lang('menuCommunityActions'), {
        {text = mvp.Lang('joinDiscord'), icon = 'f392', click = function()
            openDiscord()
        end},
        {text = mvp.Lang('menuReportBug'), icon = 'f188', click = function()
            mvp.utils.QuerryPromt('Report a bug', 'You can report bug using Discord or Steam page.', 'Use Discord', openDiscord, 'Use Steam', function() gui.OpenURL('https://discord.multiverse-project.com/') end)
        end},
        {text = mvp.Lang('menuSupport'), icon = 'f1cd', click = function()
            mvp.utils.QuerryPromt('Support', 'You can get support through our Discord or Steam.\nIf you need support for paid modules, please use Discord.', 'Use Discord', openDiscord, 'Use Steam', nil)
        end},
        {text = mvp.Lang('libraryDocs'), icon = 'f02d', click = function()
            gui.OpenURL('https://docs.multiverse-project.com/')
        end},
        {text = mvp.Lang('menuBuyModule'), color = mvp.Color('blue'), icon = 'f290', click = function()
            mvp.utils.QuerryPromt('Custom module', 'Please get in touch with us using Discord, and we will discuss about your module.', 'Discord', openDiscord)
        end}
    })

    createQuickActions(actionsMenus, mvp.Lang('menuDangerActions'), {
        {text = mvp.Lang('menuResetConfig'), color = mvp.Color('red'), icon = 'f794'},
        {text = mvp.Lang('menuResetData'), color = mvp.Color('red'), icon = 'f071'},
    })

    actionsMenus:InvalidateLayout(true)

    function actionsMenus:PerformLayout(w, h)
        local maxHeight = 0
        for _, v in pairs(self:GetChildren()) do
            v:SetWide(( w - 10) / #self:GetChildren())

            if not v.myTall then continue end
            if v.myTall > maxHeight then
                maxHeight = v.myTall
            end
        end

        self:SetTall(maxHeight)
    end
end

function mvp.Menu()
    local frame = vgui.Create('mvp.Frame')
    frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(mvp.Lang('menuTitle'))
    frame:SetIcon('folder')
    frame:SetPopupStayAtBack(true)

    local content = vgui.Create('EditablePanel', frame)
    content:Dock(FILL)
    content:DockPadding(5, 5, 5, 5)

    createHomeContent(content)

    local sidebar = vgui.Create('mvp.Sidebar', frame)
    sidebar:Dock(LEFT)
    sidebar:SetStyle(LEFT)

    sidebar:AddButton('house', mvp.Lang('menuHome'), function()
        content:Clear()
        createHomeContent(content)
    end)
    sidebar:AddButton('gear', mvp.Lang('menuConfig'), function()
        content:Clear()

        local manager = vgui.Create('mvp.ConfigManager', content)
        manager:Dock(FILL)
    end)
    sidebar:AddButton('boxes-stacked', mvp.Lang('menuModules'), function()
        content:Clear()
    end)
    sidebar:AddButton('key', mvp.Lang('menuPermissions'), function()
        content:Clear()
    end)
    sidebar:AddButton('circle-question', mvp.Lang('menuAbout'), function()
        content:Clear()

        local credits = vgui.Create('EditablePanel', content)
        credits:Dock(TOP)
        credits:SetTall(130)

        function credits:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, mvp.Color('secondary'))
            
            draw.SimpleText('MULTIVERSE Library', mvp.utils.GetFont(28, 'Proxima Nova Rg', 500), w * .5 - 100, h * .5 - 10, mvp.Color('accent'), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('aboutCreatedBy1', 'Kot'), mvp.utils.GetFont(24, 'Proxima Nova Rg', 500), w * .5 - 115, h * .5 + 10, mvp.Color('text_primary'), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            draw.SimpleText('MULTIVERSE Project', mvp.utils.GetFont(28, 'Proxima Nova Rg', 500), w * .5 + 100, h * .5 - 10, mvp.Color('accent'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(mvp.Lang('aboutCreatedBy2', 'Kot', 'Ben'), mvp.utils.GetFont(24, 'Proxima Nova Rg', 500), w * .5 + 115, h * .5 + 10, mvp.Color('text_primary'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
        discordButton:SetText(mvp.Lang('aboutJoinDiscord', 'Kot'))
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