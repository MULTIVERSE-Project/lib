
mvp = mvp or {}
mvp.ui = mvp.ui or {}
mvp.ui.terminalMenuContent = nil
mvp.ui.terminalMenuAnimating = false

local function animateContentChange(content)
    local oldContent = content
    
    local parent = oldContent:GetParent()

    mvp.ui.terminalMenuAnimating = true

    oldContent:Dock(NODOCK) -- so fucking PerformLayout dont interfere with animation


    local newContent = vgui.Create("EditablePanel", parent)
    mvp.ui.terminalMenuContent = newContent
    newContent:SetPos(oldContent:GetPos())
    newContent:SetSize(oldContent:GetSize())
    newContent:SetX(newContent:GetX() - newContent:GetWide())

    local oldContentAnimation = oldContent:NewAnimation(0.5, 0, 0.5, function(anim, pnl)
        pnl:Remove()
    end)

    oldContentAnimation.startX = oldContent:GetX()
    oldContentAnimation.targetX = oldContent:GetX() + oldContent:GetWide()

    oldContentAnimation.Think = function(anim1, pnl1, fraction1)
        pnl1:SetX(Lerp(fraction1, anim1.startX, anim1.targetX))
    end

    local newContentAnimation = newContent:NewAnimation(0.5, 0.2, 0.5, function(anim, pnl) mvp.ui.terminalMenuAnimating = false end)

    newContentAnimation.startX = newContent:GetX()
    newContentAnimation.targetX = newContent:GetX() + newContent:GetWide()

    newContentAnimation.Think = function(anim2, pnl2, fraction2)
        pnl2:SetX(Lerp(fraction2, anim2.startX, anim2.targetX))
    end

    return newContent
end

local function drawHomePage(content)
    local leftSide = vgui.Create('EditablePanel', content)
    leftSide:Dock(LEFT)
    leftSide:DockMargin(5, mvp.ui.Scale(12), 5, mvp.ui.Scale(12))
    leftSide:SetWide(mvp.ui.Scale(830))

    local avatarContainer = vgui.Create('EditablePanel', leftSide)
    avatarContainer:Dock(TOP)
    avatarContainer:SetTall(mvp.ui.Scale(64))

    function avatarContainer:Paint(w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, color_white)
        mvp.ui.DrawDualText(mvp.ui.Scale(64 +  10), h * .5, 'Hi ' .. LocalPlayer():Name() .. '!', mvp.Font(28), color_white, 'How Terminal can help you today?', mvp.Font(20), Color(192, 192, 192), TEXT_ALIGN_LEFT)
    end

    local avatar = vgui.Create("mvp.Avatar", avatarContainer)
    avatar:Dock(LEFT)
    avatar:SetWide(mvp.ui.Scale(64))
    avatar:SetPlayer(LocalPlayer(), mvp.ui.Scale(64))

    local announcement = vgui.Create('EditablePanel', leftSide)
    announcement:Dock(TOP)
    announcement:DockMargin(0, mvp.ui.Scale(12), 0, 0)
    announcement:DockPadding(0, 0, 0, 0)
    announcement:SetTall(mvp.ui.Scale(190))

    announcement:InvalidateParent(true)

    local announcementImage = vgui.Create('mvp.HTMLImage', announcement)
    announcementImage:Dock(TOP)
    announcementImage:DockMargin(0, 0, 0, 0)
    announcementImage:SetTall(mvp.ui.Scale(145))


    local mockAnnouncementData = {
        title = 'Announcement from MULTIVERSE',
        text = 'We are proud to announce that we have released our new terminal system! This system will allow you to access all of our services from one place. You can access the terminal by pressing F4. We hope you enjoy this new system and we are looking forward to your feedback!',
        image = 'https://i.imgur.com/Q7fumvS.jpg',
        date = '2020-05-01'
    }
    announcementImage:SetImageURL(mockAnnouncementData.image)

    function announcementImage:PaintOver(w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0, 0, 0, 200), true, true, false, false)
        draw.SimpleText(mockAnnouncementData.title, mvp.Font(32, 700), 5, 5, color_white, TEXT_ALIGN_LEFT)

        -- mvp.utils.TextWrap(text, font, maxWidth)
        local wrappedText = mvp.utils.TextWrap(mockAnnouncementData.text, mvp.Font(20), w - 10)

        draw.DrawText(wrappedText, mvp.Font(20), 5, mvp.ui.Scale(32) + 10, color_white, TEXT_ALIGN_LEFT)
        -- draw.SimpleText(wrappedText, mvp.Font(20), 5, mvp.ui.Scale(32) + 5, color_white, TEXT_ALIGN_LEFT)
    end

    function announcement:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(52, 52, 52))

        surface.SetFont(mvp.Font(24))
        local tw, th = surface.GetTextSize('Announcement from MULTIVERSE')

        surface.SetTextColor(Color(122, 122, 122))
        surface.SetTextPos(5, mvp.ui.Scale(145) + th * .5)
        surface.DrawText('Announcement from MULTIVERSE')
    end

    local readMoreButton = vgui.Create('mvp.Button', announcement)
    readMoreButton:SetStyle('primary')
    readMoreButton:SetSize(mvp.ui.Scale(144), mvp.ui.Scale(30))
    readMoreButton:SetPos(announcement:GetWide() - mvp.ui.Scale(144) - 5, mvp.ui.Scale(145) + mvp.ui.Scale(15) - 5)
    readMoreButton:SetText('Read more')
    readMoreButton:SetLeftIcon('f4d5')

    local quickLinks = vgui.Create('EditablePanel', leftSide)
    quickLinks:Dock(TOP)
    quickLinks:DockMargin(0, mvp.ui.Scale(12), 0, 0)
    quickLinks:SetTall(mvp.ui.Scale(115))

    local topRow = vgui.Create('EditablePanel', quickLinks)
    topRow:Dock(TOP)
    topRow:DockMargin(0, 0, 0, 0)
    topRow:SetTall(mvp.ui.Scale(55))

    local documentationButton = vgui.Create('mvp.DualTextButton', topRow)
    documentationButton:SetStyle('primary')
    documentationButton:Dock(LEFT)
    documentationButton:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(55))
    documentationButton:DockMargin(0, 0, 0, 0)
    documentationButton:SetTopText('Documentation')
    documentationButton:SetBottomText('View our documentation')
    documentationButton:SetLeftIcon('f02d')
    documentationButton:SetTextAlign(TEXT_ALIGN_LEFT)

    local workshopButton = vgui.Create('mvp.DualTextButton', topRow)
    workshopButton:SetStyle('steam')
    workshopButton:Dock(FILL)
    workshopButton:DockMargin(mvp.ui.Scale(8), 0, mvp.ui.Scale(8), 0)
    workshopButton:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(55))
    -- workshopButton:DockMargin(0, 0, 0, 0)
    workshopButton:SetTopText('Workshop')
    workshopButton:SetBottomText('View our workshop')
    workshopButton:SetLeftIcon('f1b6')
    workshopButton:SetTextAlign(TEXT_ALIGN_LEFT)

    local discordButton = vgui.Create('mvp.DualTextButton', topRow)
    discordButton:SetStyle('discord')
    discordButton:Dock(RIGHT)
    discordButton:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(55))
    discordButton:DockMargin(0, 0, 0, 0)
    discordButton:SetTopText('Discord')
    discordButton:SetBottomText('Join our discord')
    discordButton:SetLeftIcon('f392')    
    discordButton:SetTextAlign(TEXT_ALIGN_LEFT)

    local bottomRow = vgui.Create('EditablePanel', quickLinks)
    bottomRow:Dock(BOTTOM)
    bottomRow:DockMargin(0, 0, 0, 0)
    bottomRow:SetTall(mvp.ui.Scale(55))

    local shopButton = vgui.Create('mvp.DualTextButton', bottomRow)
    shopButton:SetStyle('secondary')
    shopButton:Dock(LEFT)
    shopButton:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(55))
    shopButton:DockMargin(0, 0, 0, 0)
    shopButton:SetTopText('Shop')
    shopButton:SetBottomText('Buy new modules for Terminal')
    shopButton:SetLeftIcon('f07a')
    shopButton:SetTextAlign(TEXT_ALIGN_LEFT)

    local reportBugButton = vgui.Create('mvp.DualTextButton', bottomRow)
    reportBugButton:SetStyle('secondary')
    reportBugButton:Dock(FILL)
    reportBugButton:DockMargin(mvp.ui.Scale(8), 0, mvp.ui.Scale(8), 0)
    reportBugButton:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(55))
    reportBugButton:SetTopText('Report a bug')
    reportBugButton:SetBottomText('Help us improve Terminal')
    reportBugButton:SetLeftIcon('f188')
    reportBugButton:SetTextAlign(TEXT_ALIGN_LEFT)

    local customModuleButton = vgui.Create('mvp.DualTextButton', bottomRow)
    customModuleButton:SetStyle('secondary')
    customModuleButton:Dock(RIGHT)
    customModuleButton:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(55))
    customModuleButton:DockMargin(0, 0, 0, 0)
    customModuleButton:SetTopText('Custom module')
    customModuleButton:SetBottomText('Get a custom module for your Terminal')
    customModuleButton:SetLeftIcon('f0c0')
    customModuleButton:SetTextAlign(TEXT_ALIGN_LEFT)

    local modulesMockData = {
        [1] = {
            title = "Module 1",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur.",
            icon = Material("mvp/modules/icons/base.png", "smooth"),
            status = "up-to-date"
        },
        [2] = {
            title = "Module 2",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur.",
            icon = Material("mvp/modules/icons/perfecthands.png", "smooth"),
            status = "needs-update"
        },
        [3] = {
            title = "Module 3",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur.",
            icon = Material("mvp/modules/icons/circlemenu.png", "smooth"),
            status = "not-supported"
        },
        [4] = {
            title = "Module 4",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur. ",
            icon = Material("mvp/modules/icons/shop.png", "smooth"),
            status = "third-party"
        },
        [5] = {
            title = "Module 5",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur. ",
            icon = Material("mvp/modules/icons/base.png", "smooth"),
            status = "up-to-date"
        },
        [6] = {
            title = "Module 6",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur. ",
            icon = Material("mvp/modules/icons/base.png", "smooth"),
            status = "up-to-date"
        },
        [7] = {
            title = "Module 6",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur. ",
            icon = Material("mvp/modules/icons/base.png", "smooth"),
            status = "up-to-date"
        },
        [8] = {
            title = "Module 6",
            author = "Kot",
            description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sit amet ultrices ligula. Sed sagittis neque ac elit euismod consectetur. ",
            icon = Material("mvp/modules/icons/base.png", "smooth"),
            status = "up-to-date"
        }
    }

    local grid = vgui.Create("ThreeGrid", leftSide)
    grid:Dock(FILL)
    grid:DockMargin(0, mvp.ui.Scale(12), 0, 0)
    grid:InvalidateParent(true)

    grid:SetColumns(3)
    grid:SetHorizontalMargin(mvp.ui.Scale(8))
    grid:SetVerticalMargin(mvp.ui.Scale(8))

    local predictedWide = (grid:GetWide() - grid:GetHorizontalMargin() * (grid:GetColumns() - 1)) / grid:GetColumns()

    grid:GetVBar():SetWide(0)

    local ratio = 1.598802395209581

    local iconsBackgrounds = {
        ["needs-update"] = Color(255, 192, 92, 255 * .5),
        ["up-to-date"] = Color(120, 177, 89, 255 * .5),
        ["not-supported"] = Color(255, 68, 68, 255 * .5),
        ["third-party"] = Color(255, 255, 255, 255 * .3),
    }

    local icons = {
        ["needs-update"] = "f06a",
        ["up-to-date"] = "f058",
        ["not-supported"] = "f071",
        ["third-party"] = "f007",
    }

    local statusMap = {
        ["needs-update"] = "Needs update",
        ["up-to-date"] = "Up to date",
        ["not-supported"] = "Not supported",
        ["third-party"] = "Third party",
    }

    for k, v in ipairs(modulesMockData) do
        local pnl = vgui.Create("EditablePanel")
        pnl:SetTall(predictedWide / ratio)

        function pnl:Paint(w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(52, 52, 52))

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(v.icon)
            surface.DrawTexturedRect(mvp.ui.Scale(5), mvp.ui.Scale(5), mvp.ui.Scale(80), mvp.ui.Scale(80))

            -- mvp.ui.DrawDualText(x, y, topText, topFont, topColor, bottomText, bottomFont, bottomColor, alignment, centerSpacing)
            mvp.ui.DrawDualText(mvp.ui.Scale(5) + mvp.ui.Scale(80) + mvp.ui.Scale(5), mvp.ui.Scale(5) + mvp.ui.Scale(80) * .5 - mvp.ui.Scale(20), v.title, mvp.Font(20), Color(255, 255, 255), "By " .. v.author, mvp.Font(16), Color(150, 150, 150), TEXT_ALIGN_LEFT)

            draw.RoundedBox(mvp.ui.Scale(5), mvp.ui.Scale(5) + mvp.ui.Scale(80) + mvp.ui.Scale(5), mvp.ui.Scale(5) + mvp.ui.Scale(80) * .5 + mvp.ui.Scale(20) * .5, mvp.ui.Scale(20), mvp.ui.Scale(20), iconsBackgrounds[v.status])

            mvp.ui.DrawIcon(mvp.ui.Scale(5) + mvp.ui.Scale(80) + mvp.ui.Scale(5) + mvp.ui.Scale(20) * .5, mvp.ui.Scale(5) + mvp.ui.Scale(80) * .5 + mvp.ui.Scale(20) * .5 + mvp.ui.Scale(20) * .5, icons[v.status], 12 )

            draw.SimpleText(statusMap[v.status], mvp.Font(16), mvp.ui.Scale(5) + mvp.ui.Scale(80) + mvp.ui.Scale(5) + mvp.ui.Scale(20) + mvp.ui.Scale(5), mvp.ui.Scale(5) + mvp.ui.Scale(80) * .5 + mvp.ui.Scale(20) * .5 + mvp.ui.Scale(20) * .5, ColorAlpha(iconsBackgrounds[v.status], 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local wrappedText = mvp.utils.TextWrap(v.description, mvp.Font(16), w - mvp.ui.Scale(5) * 2)

            draw.DrawText(wrappedText, mvp.Font(16), mvp.ui.Scale(5), mvp.ui.Scale(5) + mvp.ui.Scale(80) + mvp.ui.Scale(5), Color(255, 255, 255), TEXT_ALIGN_LEFT)

        end

        grid:AddCell(pnl)
    end

    local rightSide = vgui.Create('DPanel', content)
    rightSide:Dock(RIGHT)
    rightSide:SetWide(mvp.ui.Scale(485))
end

local function createHomePage(content)
    if mvp.ui.terminalMenuAnimating then return end

    drawHomePage(animateContentChange(mvp.ui.terminalMenuContent))
end

local function drawUIPage(content)
    local buttons = vgui.Create("DPanel", content)
    buttons:SetPos(5, 5)
    buttons:SetSize(150, 35 * 4 + 20)
    buttons:DockPadding(5, 20, 5, 5)

    function buttons:Paint(w, h)
        surface.SetDrawColor(225, 0, 255, 128)
        surface.DrawOutlinedRect(0, 15, w, h - 15, 1)
        draw.SimpleText("Buttons", mvp.Font(18), 0, 0, color_white)
    end

    for i, k in pairs({"primary", "secondary", "red", "green"}) do
        local button = vgui.Create("mvp.Button", buttons)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetTall(30)
        button:SetStyle(k)
        button:SetText(string.upper(k))
    end

    local buttons = vgui.Create("DPanel", content)
    buttons:SetPos(165, 5)
    buttons:SetSize(150, 35 * 6 + 15 + 20)
    buttons:DockPadding(5, 20, 5, 5)

    function buttons:Paint(w, h)
        surface.SetDrawColor(225, 0, 255, 128)
        surface.DrawOutlinedRect(0, 15, w, h - 15, 1)
        draw.SimpleText("Buttons Variations", mvp.Font(18), 0, 0, color_white)
    end

    do
        local label = vgui.Create("DLabel", buttons)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Single icon")
        local button = vgui.Create("mvp.Button", buttons)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetTall(30)
        button:SetStyle("secondary")
        button:SetText("")
        button:SetLeftIcon("f06e")
        local label = vgui.Create("DLabel", buttons)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Icon with text")
        local button = vgui.Create("mvp.Button", buttons)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetTall(30)
        button:SetStyle("secondary")
        button:SetText("Learn more")
        button:SetLeftIcon("f06e")
        local label = vgui.Create("DLabel", buttons)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Right icon with text")
        local button = vgui.Create("mvp.Button", buttons)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetTall(30)
        button:SetStyle("secondary")
        button:SetText("Learn more")
        button:SetRightIcon("f06e")
        local label = vgui.Create("DLabel", buttons)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Double-icon with text")
        
        local button = vgui.Create("mvp.Button", buttons)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetTall(30)
        button:SetStyle("secondary")
        button:SetText("Learn more")
        button:SetLeftIcon("f06e")
        button:SetRightIcon("f0d7")

        button.DoClick = function()
            local menu = vgui.Create("mvp.Menu")

            menu:AddPlayerOption()
            menu:AddPlayerOption():SetSteamID("76561198181797231")
            menu:AddPlayerOption():SetSteamID("76561198062397700")
            menu:AddStringOption("Text option", function()
                print("Option 1")
            end)
            menu:AddStringOption("Text option with icon", function()
                print("Option 1")
            end):SetIcon("f06e")

            menu:Open()
        end
    end

    local textInputs = vgui.Create("DPanel", content)
    textInputs:SetPos(325, 5)
    textInputs:SetSize(300, 35 * 6 + 15 + 20)
    textInputs:DockPadding(5, 20, 5, 5)

    function textInputs:Paint(w, h)
        surface.SetDrawColor(225, 0, 255, 128)
        surface.DrawOutlinedRect(0, 15, w, h - 15, 1)
        draw.SimpleText("Text inputs", mvp.Font(18), 0, 0, color_white)
    end

    do
        local label = vgui.Create("DLabel", textInputs)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Basic input")
        local textarea = vgui.Create("mvp.TextInput", textInputs)
        textarea:Dock(TOP)
        textarea:SetTall(30)
        textarea:SetPlaceholderText("Placeholder text")
        textarea:DockMargin(0, 0, 0, 5)
        local label = vgui.Create("DLabel", textInputs)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Basic disabled input")
        local textarea = vgui.Create("mvp.TextInput", textInputs)
        textarea:Dock(TOP)
        textarea:SetTall(30)
        textarea:SetEnabled(false)
        textarea:DockMargin(0, 0, 0, 5)
        local label = vgui.Create("DLabel", textInputs)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Input with icon")
        local textarea = vgui.Create("mvp.TextInput", textInputs)
        textarea:Dock(TOP)
        textarea:SetTall(30)
        textarea:SetIcon("f002")
        textarea:SetPlaceholderText("Placeholder text")
        textarea:SetValue("<- Cool icon, bro")
        textarea:DockMargin(0, 0, 0, 5)
        local label = vgui.Create("DLabel", textInputs)
        label:Dock(TOP)
        label:SetFont(mvp.Font(18))
        label:SetText("Disabled input with icon")
        local textarea = vgui.Create("mvp.TextInput", textInputs)
        textarea:Dock(TOP)
        textarea:SetTall(30)
        textarea:DockMargin(0, 0, 0, 5)
        textarea:SetIcon("f023")
        textarea:SetEnabled(false)
    end

    local avatars = vgui.Create("DPanel", content)
    avatars:SetPos(5, 170)
    avatars:SetSize(150, 90)
    avatars:DockPadding(5, 20, 5, 5)

    function avatars:Paint(w, h)
        surface.SetDrawColor(225, 0, 255, 128)
        surface.DrawOutlinedRect(0, 15, w, h - 15, 1)
        draw.SimpleText("Avatars", mvp.Font(18), 0, 0, color_white)
    end

    do
        local avatar = vgui.Create("mvp.Avatar", avatars)
        avatar:SetPos(5, 20)
        avatar:SetSize(64, 64)
        avatar:SetPlayer(LocalPlayer(), 64)
        local avatar = vgui.Create("mvp.Avatar", avatars)
        avatar:SetPos(80, 20)
        avatar:SetSize(64, 64)
        avatar:SetOutlineColor(Color(120, 177, 89))
        avatar:SetPlayer(LocalPlayer(), 64)
    end

    local iconContainers = vgui.Create("DPanel", content)
    iconContainers:SetPos(635, 5)
    iconContainers:SetSize(270, 48 + 25)
    iconContainers:DockPadding(5, 20, 5, 5)

    function iconContainers:Paint(w, h)
        surface.SetDrawColor(225, 0, 255, 128)
        surface.DrawOutlinedRect(0, 15, w, h - 15, 1)
        draw.SimpleText("Icon containers", mvp.Font(18), 0, 0, color_white)
    end

    local icon = vgui.Create("mvp.IconContainer", iconContainers)
    icon:SetPos(5, 20)
    icon:SetSize(48, 48)
    icon:SetIcon("f06a")

    do
        local icon = vgui.Create("mvp.IconContainer", iconContainers)
        icon:SetPos(5 + (48 + 5), 20)
        icon:SetSize(48, 48)
        icon:SetStyle("green")
        icon:SetIcon("f058")
        local icon = vgui.Create("mvp.IconContainer", iconContainers)
        icon:SetPos(5 + (48 + 5) * 2, 20)
        icon:SetSize(48, 48)
        icon:SetStyle("red")
        icon:SetIcon("f057")
        local icon = vgui.Create("mvp.IconContainer", iconContainers)
        icon:SetPos(5 + (48 + 5) * 3, 20)
        icon:SetSize(48, 48)
        icon:SetStyle("info")
        icon:SetIcon("f05a")
        local icon = vgui.Create("mvp.IconContainer", iconContainers)
        icon:SetPos(5 + (48 + 5) * 4, 20)
        icon:SetSize(48, 48)
        icon:SetStyle("white")
        icon:SetIcon("f2bd")
    end

    local dropdownMenu = vgui.Create("mvp.DropdownMenu", content)
    dropdownMenu:SetPos(5, 300)
    dropdownMenu:SetStyle("secondary")
    dropdownMenu:SetSize(300, 30)

    dropdownMenu:AddStringOption("Default plain option", nil)
    dropdownMenu:AddStringOption("Option with icon", nil, "f006")
    dropdownMenu:AddPlayerOption(LocalPlayer())

    function dropdownMenu:OptionSelected(option, data)
        print(option, data)
    end
end

local function createUIPage()
    if mvp.ui.terminalMenuAnimating then return end

    drawUIPage(animateContentChange(mvp.ui.terminalMenuContent))
end

local terminalLogo = Material("mvp/terminal/logo2.png", "noclamp smooth")

function mvp.TerminalMenu()
    local frame = vgui.Create("mvp.Frame")
    frame:SetSize(mvp.ui.Scale(1600), mvp.ui.Scale(800))
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetID("terminalMenu5")

    local sidebar = vgui.Create("mvp.Sidebar", frame)
    sidebar:Dock(LEFT)
    sidebar:SetWide(mvp.ui.Scale(270))
    sidebar:SetShowCloseButton(true)

    local terminalHeader = vgui.Create("EditablePanel", sidebar)
    terminalHeader:SetPos(0, 0)
    terminalHeader:SetSize(mvp.ui.Scale(270), mvp.ui.Scale(90))

    function terminalHeader:Paint(w, h)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.SetMaterial(terminalLogo)

        surface.DrawTexturedRect(0, 0, mvp.ui.Scale(105), h)

        mvp.ui.DrawDualText(mvp.ui.Scale(80), h * .5, "Terminal", mvp.Font(32, 700), color_white, "Administrator", mvp.Font(21, 400), Color(150, 150, 150), TEXT_ALIGN_LEFT, mvp.ui.Scale(3))
    end

    local contentContainer = vgui.Create("EditablePanel", frame)
    contentContainer:Dock(FILL)

    mvp.ui.terminalMenuContent = vgui.Create("EditablePanel", contentContainer)
    mvp.ui.terminalMenuContent:Dock(FILL)

    sidebar:AddButton("f015", "Home", createHomePage, true)
    sidebar:AddButton("f013", "Settings", nil)
    sidebar:AddButton("f550", "Logs", nil)
    sidebar:AddButton("f53f", "UI", createUIPage)

    drawHomePage(mvp.ui.terminalMenuContent)
end