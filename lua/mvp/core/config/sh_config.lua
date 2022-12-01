--- @module mvp.config
mvp.config = mvp.config or {}

mvp.config.stored = mvp.config.stored or {}

mvp.permissions.Add( 'mvp.editConfigs', 'superadmin', 'Access to editing config' )

--- Creates a new config entry
-- @realm shared
-- @tparam string key The key of the config entry
-- @tparam any value the default value of the config entry
-- @tparam func callback The callback to run when the config entry is changed
-- @tparam table data Extra data to store with the config entry
-- @tparam bool isServerOnly Whether or not the config entry is server only
-- @tparam bool isMapOnly Whether or not the config entry is map only
function mvp.config.Add(key, value, callback, data, isServerOnly, isMapOnly)
    data = istable(data) and data or {}

    local oldConfig = mvp.config.stored[key]
    local type = data.type or mvp.utils.GetTypeFromValue(value)

    if not type then
        mvp.utils.Error('Invalid config type for key ' .. key .. '.')

        return 
    end

    data.type = nil

    local default = value

    if oldConfig ~= nil then
        if oldConfig.value ~= nil then
            value = oldConfig.value
        end

        if oldConfig.default ~= nil then
            default = oldConfig.default
        end
    end

    mvp.config.stored[key] = {
        type = type,
        data = data,
        value = value,
        default = default,

        serverOnly = isServerOnly,
        mapOnly = isMapOnly,

        callback = callback
    }

    mvp.utils.Print('Added config entry ', Color(140, 122, 230), key, color_white, '.')
end

--- Gets a config value
-- @realm shared
-- @tparam string key The key of the config entry
-- @tparam any default The default value to return if the config entry doesn't exist
-- @treturn any The value of the config entry
function mvp.config.Get(key, default)
    local config = mvp.config.stored[key]

    if config and config.type then
        if config.value ~= nil then
            return config.value
        end

        if config.default ~= nil then
            return config.default
        end
    end

    return default
end

--- Sets and saves a config value
-- @realm shared
-- @tparam string key The key of the config entry
-- @tparam any value The value to set the config entry to
function mvp.config.Set(key, value)
    local config = mvp.config.stored[key]

    if not config then
        return 
    end

    local oldValue = config.value
    config.value = value

    if SERVER then
        if not config.serverOnly then
            net.Start('mvpConfigSet')
                net.WriteString(key)
                net.WriteType(value)
            net.Broadcast()
        end

        if config.callback then
            config.callback(value, oldValue)
        end

        mvp.config.Save()
    else
        net.Start('mvpConfigSet')
            net.WriteString(key)
            net.WriteType(value)
        net.SendToServer()
    end
end

--- Loads the config from the config file
-- @realm server
-- @internal
function mvp.config.Load()
    if SERVER then
        local globals = mvp.data.Get('config', nil, false) -- global configs
        local data = mvp.data.Get('config', nil, true) -- map configs

        if globals then
            for k, v in pairs(globals) do
                mvp.config.stored[k] = mvp.config.stored[k] or {}
                mvp.config.stored[k].value = v
            end
        end

        if data then
            for k, v in pairs(data) do
                mvp.config.stored[k] = mvp.config.stored[k] or {}
                mvp.config.stored[k].value = v
            end
        end
    end

    mvp.config.LoadFromFolder('mvp/config')
end

--- Loads configs from folder with configs files
-- @realm shared
-- @internal
function mvp.config.LoadFromFolder(path)
    mvp.loader.LoadFolder(path, true)
end