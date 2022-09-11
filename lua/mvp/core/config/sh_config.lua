--- @module mvp.config
mvp.config = mvp.config or {}

mvp.config.stored = mvp.config.stored or {}

if (SERVER) then
    util.AddNetworkString('mvpConfigList')
    util.AddNetworkString('mvpConfigSet')

    util.AddNetworkString('mvpConfigRequestFullConfig')
end

function mvp.config.Add(key, value, description, callback, data, isServerOnly, isMapOnly)
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
        description = description,

        serverOnly = isServerOnly,
        mapOnly = isMapOnly,

        callback = callback
    }
end

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
    end
end

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

    mvp.loader.LoadFile('mvp/config/base.lua')
end