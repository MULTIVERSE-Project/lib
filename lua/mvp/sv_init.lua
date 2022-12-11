--- @module mvp
mvp = mvp or {}

-- Send essential files to client first
AddCSLuaFile('mvp/core/sh_loader.lua')
include('mvp/core/sh_loader.lua')

-- Force load font awesome for icons
resource.AddFile('resource/fonts/fa-brands.ttf')
resource.AddFile('resource/fonts/fa-regular.ttf')
resource.AddFile('resource/fonts/fa-solid.ttf')

util.AddNetworkString('mvpMenu')

-- handle menu command
hook.Add('PlayerSay', 'mvp.hooks.OpenConfig', function(ply, text)      
    if string.Trim(string.lower(text)) ~= mvp.config.Get('chatCommand', '!mvp') then return end
    if not mvp.permissions.Check(ply, 'mvp.admin') then return end

    net.Start('mvpMenu')
    net.Send(ply)

    return true
end)

hook.Add('PlayerInitialSpawn', 'mvp.PlayerDetector', function(ply1)
    hook.Add( 'SetupMove', 'mvp.waitPlayer.' .. ply1:UserID(), function( ply2, _, cmd )
        if ply1 == ply2 and not cmd:IsForced() then
            hook.Run( 'mvp.hooks.PlayerReady', ply2 )
            hook.Remove( 'SetupMove', 'mvp.waitPlayer.' .. ply2:UserID() )
        end
    end )
end)