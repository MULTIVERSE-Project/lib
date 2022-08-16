mvp = {}

AddCSLuaFile()

if SERVER then
    AddCSLuaFile('mvp/cl_init.lua')
    AddCSLuaFile('mvp/sh_init.lua')
    AddCSLuaFile('mvp/sv_init.lua') 

    include('mvp/sv_init.lua') 
else
    include('mvp/cl_init.lua')
end

include('mvp/sh_init.lua')  