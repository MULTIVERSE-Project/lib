mvp = {}
mvp.ENV = 'dev'

AddCSLuaFile()

if mvp.ENV == 'dev' then
    _include = _include or include

    include = function(...) _include(...) end
end

if SERVER then
    AddCSLuaFile('mvp/cl_init.lua')
    AddCSLuaFile('mvp/sh_init.lua')
    AddCSLuaFile('mvp/sv_init.lua') 

    include('mvp/sv_init.lua') 
else
    include('mvp/cl_init.lua')
end

include('mvp/sh_init.lua')

