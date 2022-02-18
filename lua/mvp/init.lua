mvp = mvp or {}

AddCSLuaFile('mvp/core/sh_utils.lua')
AddCSLuaFile('mvp/core/sh_data.lua')
AddCSLuaFile('mvp/core/sh_config.lua')

util.AddNetworkString('mvpHotReload')

hook.Add('PlayerInitialSpawn', 'mvp.PlayerDetector', function(ply)
    hook.Add( 'SetupMove', ply, function( self, ply, _, cmd )
        if self == ply and not cmd:IsForced() then
            hook.Run( 'mvpPlayerLoaded', self )
            hook.Remove( 'SetupMove', self )
        end
    end )
end)

hook.Add('mvpPlayerLoaded', 'mvp.config.Send', function(ply)
    mvp.config.Send(ply)
end)