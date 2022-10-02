--- @module mvp
mvp = mvp or {}

-- Send essential files to client first
AddCSLuaFile('mvp/core/sh_loader.lua')
include('mvp/core/sh_loader.lua')

-- Force load font awesome for icons
resource.AddFile('resource/fonts/fa-brands.ttf')
resource.AddFile('resource/fonts/fa-regular.ttf')
resource.AddFile('resource/fonts/fa-solid.ttf')

util.AddNetworkString('mvpPlayerReady')
util.AddNetworkString('mvpMenu')

-- Player ready
net.Receive('mvpPlayerReady', function(len, ply)
    if ply.mvpReady then return end

    -- Set player ready
    ply.mvpReady = true
    hook.Run('mvp.hooks.PlayerReady', ply)
end)

-- handle menu command
hook.Add('PlayerSay', 'mvp.hooks.OpenConfig', function(ply, text)      
    if string.Trim(string.lower(text)) ~= mvp.config.Get('chatCommand', '!mvp') then return end
    if not mvp.permissions.Check(ply, 'mvp.admin') then return end

    net.Start('mvpMenu')
    net.Send(ply)

    return true
end)