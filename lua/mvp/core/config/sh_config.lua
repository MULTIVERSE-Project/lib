--- @module mvp.config
mvp.config = mvp.config or {}

mvp.config.stored = mvp.config.stored or {}

mvp.permissions.Add( 'mvp.editConfigs', 'superadmin', 'Access to editing config' )

--- Creates a new config entry
-- @realm shared
-- @tparam string key The key of the config entry
-- @tparam any value the default value of the config entry
-- @tparam func callback The callback to run when the config entry is changed
-- @tparam ConfigExtraData data Extra data to store with the config entry
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

--- Config addittional data
-- @table ConfigExtraData
-- @realm shared
-- @tfield mvp.type|string type of the config value can be any of `mvp.type` or `"select"`
-- @tfield string category Category of config entry. If not specified will be "Other".
-- @tfield function pre Function that calls before config entry will change.
-- @tfield function post Function that calls after config entry changed, similar to `callback`, but called only on server.
-- @tfield function GetValues Function that called when combobox are being build, should return data in form of table `{1 = {value = "value that will be saved to config file", text = "text displayed to user"}}`
-- @tfield number min Minimum value. Only works if `mvp.type.number` used as type
-- @tfield number max Maxmimum value. Only works if `mvp.type.number` used as type
-- @tfield KeyTable key Information about key, if `mvp.type.array` used as type
-- @tfield ValueTable value Information about value, if `mvp.type.array` used as type
-- @see mvp.config.Add
-- @usage
-- 
-- mvp.config.Add('myConfigValue', 5, function(new, old) print("this callbacl called on both sides") end, {
--     category = 'categId',
--     type = mvp.type.number,
--     min = 1,
--     max = 50,
--     pre = function(new, old)
--         return math.Round(new) -- this will round value before saving
--     end,
--     post = function(new, old)
--          print(new, old)
--          print("this 'post' function will be called only on server-side")
--     end
-- }, false, false)

--- Key table structure
-- @table KeyValue
-- @realm shared
-- @tfield mvp.type type Type of the key, based on this, UI will choose needed input type
-- @tfield string hint Placeholder for the input, if `mvp.type.string` was used.

--- Value table structure
-- @table ValueTable
-- @realm shared
-- @tfield mvp.type type Type of the value, based on this, UI will choose needed input type
-- @tfield string hint Placeholder for the input, if `mvp.type.string` was used.

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
-- @treturn bool Is operation was successful, `true` or `false`
-- @treturn any Value that was set. Can be affected by `pre` function, but always be the same type.
function mvp.config.Set(key, value)
    local config = mvp.config.stored[key]

    if not config then
        return 
    end

    local oldValue = config.value
    config.value = value

    if SERVER then
        if config.data.pre then
            local owValue = config.data.pre(value, oldValue)

            if owValue and type(owValue) == type(value) then
                config.value = owValue
                value = owValue
            else
                error(Format('Cannot change values type in "pre" function on config key %s. (Expected "%s", got "%s")\n', key, type(value), type(owValue)))
                return false
            end
        end

        if not config.serverOnly then
            net.Start('mvpConfigSet')
                net.WriteString(key)
                net.WriteType(value)
            net.Broadcast()
        end

        if config.data.post then
            config.data.post(value, oldValue)
        end
        if config.callback then
            config.callback(value, oldValue)
        end 

        mvp.config.Save()

        return true, value
    else
        net.Start('mvpConfigSet')
            net.WriteString(key)
            net.WriteType(value)
        net.SendToServer()

        return true, value
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

    hook.Run('mvp.hooks.configsAdded')
end

--- Loads configs from folder with configs files
-- @realm shared
-- @internal
function mvp.config.LoadFromFolder(path)
    mvp.loader.LoadFolder(path, true)
end