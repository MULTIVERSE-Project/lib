---@module mvp.modules
mvp = mvp or {}
mvp.modules = mvp.modules or {}
mvp.modules.list = mvp.modules.list or {}
mvp.modules.disabledModules = mvp.modules.disabledModules or {}

MVP_HOOK_CACHE = MVP_HOOK_CACHE or {}

if SERVER then 
    util.AddNetworkString('mvp.SendDisabledModules')
    util.AddNetworkString('mvp.DisableModule')
end

mvp.permissions.Add('mvp.manageModules', 'superadmin')

for name, hooks in pairs(MVP_HOOK_CACHE) do
    for id, _ in pairs(hooks) do
        hook.Remove(name, 'mvp.generatedHook.' .. name .. '.' .. id)
        MVP_HOOK_CACHE[name][id] = nil
    end
end

--- Loads module from path with specified ID
-- @string id ID of the module.
-- @string path Path to folder/file that contains module.
-- @bool single If true, module will be loaded from file, otherwise from folder.
-- @string[opt='MODULE'] var custom var, for internal use only.
-- @realm shared
function mvp.modules.Load(id, path, single, var)
    MODULE = nil -- clear old info about module

    local disabledModules = mvp.modules.disabledModules or {}

    var = var or 'MODULE'
    -- local oldPlugin = MODULE

    if disabledModules[id] then
        mvp.utils.Print('Module ', Color(140, 122, 230), id, Color(255, 255, 255), ' is disabled. Skipping...')
        mvp.modules.list[id] = MODULE
        
        MODULE.loading = false

        return
    end

    MODULE = setmetatable({}, {__index = mvp.meta.module})

    MODULE:SetID(id)
    MODULE:SetPath(path)

    MODULE:SetName(id)

    if mvp.modules.list[id] then
        MODULE = mvp.modules.list[id]
    end

    MODULE.loading = true -- сообщим о том что модуль загружаеться

    if not single then
        mvp.languages.LoadFromFolder(path .. '/languages')
        mvp.config.LoadFromFolder(path .. '/config')
        mvp.modules.LoadFromFolder(path .. '/modules')
        mvp.modules.LoadEntites(path .. '/entities')
    end
    mvp.loader.LoadFile(single and path or path .. '/sh_' .. var:lower() .. '.lua')
    
    MODULE.loading = false

    hook.Run('mvp.hooks.ModuleLoaded', id, MODULE)

    if MODULE.OnLoaded then
        MODULE:OnLoaded()
    end

    if MODULE.registerAsTable then
        mvp[MODULE.systemID or MODULE.id] = MODULE
    end
    
    mvp.modules.list[id] = MODULE

    mvp.utils.Print('Module ', Color(0, 0, 255), MODULE:GetName(), color_white, ' ( ', Color(0, 255, 0), id, color_white,' ) loaded')

    MODULE = nil
end

--- Loads all entities from specified folder.
-- @realm shared
-- @tparam string path Path to folder that contains entities.
function mvp.modules.LoadEntites(path)
    local files, folders

    local function IncludeFiles(path2, bClientOnly)
		if (SERVER and !bClientOnly) then
			if (file.Exists(path2..'init.lua', 'LUA')) then
				mvp.loader.LoadFile(path2..'init.lua', 'server')
			elseif (file.Exists(path2..'shared.lua', 'LUA')) then
				mvp.loader.LoadFile(path2..'shared.lua')
			end

			if (file.Exists(path2..'cl_init.lua', 'LUA')) then
				mvp.loader.LoadFile(path2..'cl_init.lua', 'client')
			end
		elseif (file.Exists(path2..'cl_init.lua', 'LUA')) then
			mvp.loader.LoadFile(path2..'cl_init.lua', 'client')
		elseif (file.Exists(path2..'shared.lua', 'LUA')) then
			mvp.loader.LoadFile(path2..'shared.lua')
		end
	end

    local function HandleEntityInclusion(folder, variable, register, default, clientOnly, create, complete)
        files, folders = file.Find(path .. '/' .. folder .. '/*', 'LUA')
        default = default or {}

        for _, v in ipairs(folders) do
            local path2 = path .. '/' .. folder .. '/' .. v .. '/'
            v = mvp.utils.StripRealmPrefix(v)
            _G[variable] = table.Copy(default)

            if (not isfunction(create)) then
                _G[variable].ClassName = v
            else
                create(v)
            end

            IncludeFiles(path2, clientOnly)

            if (clientOnly) then
                if (CLIENT) then
                    register(_G[variable], v)
                end
            else
                register(_G[variable], v)
            end

            if (isfunction(complete)) then
                complete(v, _G[variable])
            end

            mvp.utils.Print('Loaded entity ', v)
            PrintTable(ents.FindByClass(v))

            _G[variable] = nil
        end

        for _, v in ipairs(files) do
            local niceName = mvp.utils.StripRealmPrefix(string.StripExtension(v))
            _G[variable] = table.Copy(default)

            if (not isfunction(create)) then
                _G[variable].ClassName = niceName
            else
                create(niceName)
            end

            mvp.loader.LoadFile(path .. '/' .. folder .. '/' .. v, clientOnly and 'client' or 'shared')

            if (clientOnly) then
                if (CLIENT) then
                    register(_G[variable], niceName)
                end
            else
                register(_G[variable], niceName)
            end

            mvp.utils.Print('Loaded entity (file)', v)
            PrintTable(ents.FindByClass(niceName) or {nothing = true})

            if (isfunction(complete)) then
                complete(niceName, _G[variable])
            end

            _G[variable] = nil
        end
    end

    -- Include entities.
    HandleEntityInclusion('entities', 'ENT', scripted_ents.Register, {
        Type = 'anim',
        Base = 'base_gmodentity',
        Spawnable = true
    }, false, nil, function(name, ent)
        for _, entity in pairs( ents.FindByClass( name ) ) do

			table.Merge( entity, ent )
			if ( entity.OnReloaded ) then
				entity:OnReloaded()
			end

		end

		for _, e in pairs( ents.GetAll() ) do
			if ( scripted_ents.IsBasedOn( e:GetClass(), name ) ) then
				table.Merge( e, scripted_ents.Get( e:GetClass() ) )
				if ( e.OnReloaded ) then
					e:OnReloaded()
				end
			end
		end
    end)

    -- Include weapons.
    HandleEntityInclusion('weapons', 'SWEP', weapons.Register, {
        Primary = {},
        Secondary = {},
        Base = 'weapon_base'
    })

    -- Include effects.
    HandleEntityInclusion('effects', 'EFFECT', effects and effects.Register, nil, true)
end

--- Loads all modules from specified folder.
-- @string path Path to folder
-- @realm shared
function mvp.modules.LoadFromFolder(path)
    local files, folders = file.Find(path .. '/*', 'LUA')

    for k, v in pairs(files) do
        mvp.modules.Load(string.StripExtension(v), path .. '/' .. v, true)
    end

    for k, v in pairs(folders) do
        mvp.modules.Load(v, path .. '/' .. v)
    end

    if CLIENT then
        RunConsoleCommand('spawnmenu_reload') -- dirty thing, but hey, it's working
    end
end

--- Gets module by id.
-- @number id Module ID.
-- @realm shared
function mvp.modules.Get(id)
    return mvp.modules.list[id]
end

--- Load all modules from main folder.
-- @internal
-- @realm shared
function mvp.modules.Init()    
    if SERVER then
        mvp.modules.disabledModules = mvp.data.Get('disabled_modules')
        
        hook.Add('mvp.hooks.PlayerReady', 'SendDisabledModules', function(ply)
            net.Start('mvp.SendDisabledModules')
                net.WriteTable(mvp.modules.disabledModules)
            net.Send(ply)
        end)

        mvp.modules.LoadFromFolder('mvp/modules')
        hook.Run('mvp.hooks.InitedCoreModules')
    end
end

if SERVER then
    --- Reloads all modules on server
    -- @internal
    -- @realm server
    function mvp.modules.Reload()
        for name, modules in pairs(MVP_HOOK_CACHE) do
            for module, hooks in pairs(modules) do
                for id, _ in pairs(hooks) do
                    hook.Remove(name, 'mvp.generatedHook.' .. module .. '.' .. id)
                    MVP_HOOK_CACHE[name][id] = nil
                end
            end
        end
    
        mvp.modules.Init()
    end
    
    concommand.Add('mvp_reload', function()
        mvp.modules.Reload()

        for k, v in pairs(player.GetAll()) do
            v:SendLua('mvp.modules.LoadFromFolder("mvp/modules")')
        end
    end)
end

if CLIENT then
    net.Receive('mvp.SendDisabledModules', function()
        mvp.modules.disabledModules = net.ReadTable()

        mvp.modules.LoadFromFolder('mvp/modules')
        hook.Run('mvp.hooks.InitedCoreModules')
    end)
end

if SERVER then
    net.Receive('mvp.DisableModule', function(_, ply)
        if not mvp.permissions.Check(ply, 'mvp.manageModules') then
            return 
        end

        local id = net.ReadString()
        local state = net.ReadBool()

        local mod = mvp.modules.Get(id)

        if not mod then return end

        mod:SetDisabled(state)
    end)
end

hook.Add('InitPostEntity', 'mvp.init.ent.test', function()
    PrintTable(ents.FindByClass('test_entity'))
end)