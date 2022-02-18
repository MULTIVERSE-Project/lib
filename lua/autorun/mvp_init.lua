mvp = {}

if SERVER then
    AddCSLuaFile('mvp/init.lua')
    AddCSLuaFile('mvp/cl_init.lua')
    AddCSLuaFile('mvp/shared.lua')

    include('mvp/init.lua')
else
    include('mvp/cl_init.lua')
end

include('mvp/shared.lua')
