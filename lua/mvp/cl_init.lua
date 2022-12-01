--- @module mvp
mvp = mvp or {}

include('mvp/core/sh_loader.lua')

-- Let server know we're ready to receive data
hook.Add('InitPostEntity', 'mvpPlayerReady', function()
    net.Start('mvpPlayerReady')
    net.SendToServer()
end)


-- Handle menu opening
net.Receive('mvpMenu', function()
    mvp.Menu()
end)

concommand.Add('mvp_menu', function(ply)
    if ply ~= LocalPlayer() then return end
    if not mvp.config.Get('allowConsoleCommand') then 
        mvp.utils.Print('Console command is', Color(255, 0, 0), ' disabled ', color_white, 'on this server')
        mvp.utils.Print('Use the ', Color(0, 255, 0), mvp.config.Get('chatCommand', '!mvp'), color_white, ' chat command to open the menu')
        return
    end

    if not mvp.permissions.Check(ply, 'mvp.admin') then return end

    mvp.Menu()
end)