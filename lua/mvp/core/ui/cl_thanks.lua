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

    local text = mvp.language.Get('thx#MainText')

    text = mvp.utils.TextWrap(text, 'mvp.Thx.Text', 390)

    function frame:OnPaint(w, h)

        surface.SetMaterial(logo)
        surface.SetDrawColor(COLOR_WHITE)
        surface.DrawTexturedRect(w * .5 - 64, 36, 128, 128)

        draw.SimpleText(mvp.language.Get('thx#FirstLine'), 'mvp.Thx.Title', w * .5, 45 + 128, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(mvp.language.Get('thx#SecondLine'), 'mvp.Thx.Text', w * .5, 65 + 128, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.DrawText(text, 'mvp.Thx.Text', w * .5, 85 + 128, COLOR_WHITE, TEXT_ALIGN_CENTER)
    end
    
    local checkDiscord = vgui.Create('mvp.Button', frame)
    checkDiscord:DockMargin(5, 0, 5, 0)
    checkDiscord:Dock(BOTTOM)
    checkDiscord:SetText(mvp.language.Get('thx#DiscordURL'))

    function checkDiscord:DoClick()
        gui.OpenURL('https://discord.gg/Ah5q4zqhgn')
    end

    file.Write('mvp/thx.txt', 'This is indicator that you already seen Thank you screen. Please don\'t delete this file.')
end

hook.Add('RecivedMVPConfigs', 'mvp.hook.sayThx', function()
    mvp.sayThanks()
end)