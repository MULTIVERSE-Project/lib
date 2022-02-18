mvp = mvp or {}

surface.CreateFont('mvp.Thx.Title', {
    font = 'Proxima Nova Rg',
    size = 24,
    extended = true
})
surface.CreateFont('mvp.Thx.Text', {
    font = 'Proxima Nova Rg',
    size = 18,
    extended = true
})

function mvp.sayThanks()
    if not LocalPlayer():IsSuperAdmin() or file.Exists('mvp/thx.txt', 'DATA') then return end

    local logo = Material('mvp/logo.png', 'mips smooth')
    local frame = vgui.Create('mvp.Frame')
    frame:SetSize(400, 480)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle('Thank you!')

    local text = [[At MULTIVERSE Project we want to make only unique, interesting and cool content, and you've ALREADY become part of our small community. Thank you for supporting and using our work on your server!

    This message will only appear once, and only to the SuperAdmins, we won't disturb your players.
    
    If someone recommended you to install our base and a couple of modules for it and you don't know yet that we have a discord, please come and take a look :)]]

    text = mvp.utils.TextWrap(text, 'mvp.Thx.Text', 390)

    function frame:OnPaint(w, h)

        surface.SetMaterial(logo)
        surface.SetDrawColor(COLOR_WHITE)
        surface.DrawTexturedRect(w * .5 - 64, 36, 128, 128)

        draw.SimpleText('Thank you very much ', 'mvp.Thx.Title', w * .5, 45 + 128, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText('for using our scripts', 'mvp.Thx.Text', w * .5, 65 + 128, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.DrawText(text, 'mvp.Thx.Text', w * .5, 85 + 128, COLOR_WHITE, TEXT_ALIGN_CENTER)
    end
    
    local checkDiscord = vgui.Create('mvp.Button', frame)
    checkDiscord:DockMargin(5, 0, 5, 0)
    checkDiscord:Dock(BOTTOM)
    checkDiscord:SetText('Open link to Discord server')

    function checkDiscord:DoClick()
        gui.OpenURL('https://discord.gg/Ah5q4zqhgn')
    end

    file.Write('mvp/thx.txt', 'This is indicator that you already seen Thank you screen. Please don\'t delete this file.')
end

hook.Add('RecivedMVPConfigs', 'mvp.hook.sayThx', function()
    mvp.sayThanks()
end)