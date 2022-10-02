---@modules mvp.modules
mvp = mvp or {}
mvp.modules = mvp.modules or {}
mvp.modules.list = mvp.modules.list or {}

MVP_HOOK_CACHE = MVP_HOOK_CACHE or {}

for name, hooks in pairs(MVP_HOOK_CACHE) do
    for id, _ in pairs(hooks) do
        hook.Remove(name, 'mvp.generatedHook.' .. id)
        MVP_HOOK_CACHE[name][id] = nil
    end
end

---
-- @string id
-- @string path
-- @bool single
-- @string[opt='MODULE'] var
-- @realm shared
function mvp.modules.Load(id, path, single, var)
    -- @todo Проверка на то стоит ли модулю загружаться (отключение модулей?)
    var = var or 'MODULE'
    -- local oldPlugin = MODULE

    MODULE = {
        folder = path,
        id = id,
        name = 'Undefined',
        description = 'No description',
        author = 'Unknown author'
    }

    if mvp.modules.list[id] then
        MODULE = mvp.modules.list[id]
    end

    MODULE.loading = true -- сообщим о том что модуль загружаеться

    function MODULE:Include(fileName, realm)
        mvp.utils.Include(self.folder .. '/' .. fileName)
    end

    function MODULE:IncludeFolder(folder, realm)
        mvp.utils.IncludeFolder(self.folder .. '/' .. folder, true, true)
    end

    function MODULE:Hook(name, func, uuid)
        local generated = false
        uuid = uuid or mvp.utils.UUID(6)

        if not uuid then
            uuid = mvp.utils.UUID(6)
            generated = true
        end

        MVP_HOOK_CACHE[name] = MVP_HOOK_CACHE[name] or {}
        
        if MVP_HOOK_CACHE[name][uuid] and generated then
            self:Hook(name, uuid, func)
            return 
        end

        MVP_HOOK_CACHE[name][uuid] = true

        hook.Add(name, 'mvp.generatedHook.' .. uuid, function(v1, v2, v3, v4, v5, v6)
            return func(self, v1, v2, v3, v4, v5, v6)
        end)
    end

    mvp.utils.Include(single and path or path .. '/sh_' .. var:lower() .. '.lua')

    if not single then
        mvp.language.LoadFromDir(path .. '/languages')
        mvp.config.LoadFromDir(path .. '/config')
        mvp.modules.LoadFromDir(path .. '/modules')
        mvp.modules.LoadEntites(path .. '/entities')
    end

    MODULE.loading = false

    function MODULE:SetData(value, global, ignoreMap)
        mvp.data.Set(id, value, global, ignoreMap)
    end

    function MODULE:GetData(default, global, ignoreMap, refresh)
        return mvp.data.Get(id, default, global, ignoreMap, refresh)
    end

    hook.Run('ModuleLoaded', id, MODULE)
    if MODULE.OnLoaded then
        MODULE:OnLoaded()
    end

    if MODULE.registerAsTable then
        mvp[MODULE.systemID or MODULE.id] = MODULE
    end
    
    mvp.modules.list[id] = MODULE

    MODULE = nil
end

--- 
-- @realm shared
-- @tparam string path
function mvp.modules.LoadEntites(path)
    local files, folders

    local function IncludeFiles(path2, bClientOnly)
        if (SERVER and not bClientOnly) then
            if (file.Exists(path2 .. 'init.lua', 'LUA')) then
                mvp.utils.Include(path2 .. 'init.lua', 'server')
            elseif (file.Exists(path2 .. 'shared.lua', 'LUA')) then
                mvp.utils.Include(path2 .. 'shared.lua')
            end

            if (file.Exists(path2 .. 'cl_init.lua', 'LUA')) then
                mvp.utils.Include(path2 .. 'cl_init.lua', 'client')
            end
        elseif (file.Exists(path2 .. 'cl_init.lua', 'LUA')) then
            mvp.utils.Include(path2 .. 'cl_init.lua', 'client')
        elseif (file.Exists(path2 .. 'shared.lua', 'LUA')) then
            mvp.utils.Include(path2 .. 'shared.lua')
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
                complete(_G[variable])
            end

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

            mvp.utils.Include(path .. '/' .. folder .. '/' .. v, clientOnly and 'client' or 'shared')

            if (clientOnly) then
                if (CLIENT) then
                    register(_G[variable], niceName)
                end
            else
                register(_G[variable], niceName)
            end

            if (isfunction(complete)) then
                complete(_G[variable])
            end

            _G[variable] = nil
        end
    end

    -- Include entities.
    HandleEntityInclusion('entities', 'ENT', scripted_ents.Register, {
        Type = 'anim',
        Base = 'base_gmodentity',
        Spawnable = true
    }, false, nil, function(ent)
        
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

---
-- @string path
-- @realm shared
function mvp.modules.LoadFromDir(path)
    local files, folders = file.Find(path .. '/*', 'LUA')

    for k, v in pairs(files) do
        mvp.modules.Load(string.StripExtension(v), path .. '/' .. v, true)
    end

    for k, v in pairs(folders) do
        mvp.modules.Load(v, path .. '/' .. v)
    end
end

---
-- @number id
-- @realm shared
function mvp.modules.Get(id)
    return mvp.modules.list[id]
end

---
-- @internal
-- @realm shared
function mvp.modules.Load()
    mvp.modules.LoadFromDir('mvp/modules')
    hook.Run('mvp.hooks.InitedCoreModules')
end