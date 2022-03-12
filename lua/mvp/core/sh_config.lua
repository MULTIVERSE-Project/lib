if SERVER then
    util.AddNetworkString('mvpConfigSet')
    util.AddNetworkString('mvpConfigList')
end

mvp = mvp or {}
mvp.config = mvp.config or {}
mvp.config.stored = mvp.config.stored or {}

mvp.config.validators = {
    ['string'] = function(value, defaultValue)
        return (value ~= nil) and (value ~= '') and type(value) == type(defaultValue)
    end,
    ['select'] = function(value, defaultValue, avaibleValues)
        return avaibleValues[value] ~= nil
    end,
    ['bool'] = function(value, defaultValue)
        return true
    end,
    ['number'] = function(value, defaultValue) -- type(defaultValue) == number
        return (value ~= nil) and (value ~= '') and type(value) == type(defaultValue)
    end,
}

function mvp.config.Add(key, value, description, callback, data, onlySchema, onlyServer)
    data = istable(data) and data or {}

    local oldConfig = mvp.config.stored[key]

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
        data = data,
        value = value,
        default = default,
        description = description,
        onlyServer = onlyServer,
        global = not onlySchema,
        callback = callback
    }
end

function mvp.config.Set(key, value)
    local config = mvp.config.stored[key]
    
    if config then
        
        if config.data.type == 'number' then
            value = tonumber(value)
            
            if value == nil then
                return 
            end
        end        

        if SERVER then
            local oldValue = config.value
            config.value = value

            if not config.onlyServer then
                net.Start('mvpConfigSet')
                    net.WriteString(key)
                    net.WriteType(value)
                net.Broadcast()
            end

            if config.callback then
                config.callback(oldValue, value)
            end

            mvp.config.Save()
        else
            if not mvp.permission.Check(LocalPlayer(), 'mvp/EditConfigs') then
                return 
            end

            net.Start('mvpConfigSet')
                net.WriteString(key)
                net.WriteType(value)
            net.SendToServer()
        end
    end
end

function mvp.config.Get(key, default) 
    local config = mvp.config.stored[key]

    if (config) then
        if (config.value ~= nil) then
    		return config.value
    	elseif (config.default ~= nil) then
    		return config.default
    	end
    end 

    return default
end

function mvp.config.Load()
    mvp.permission.Add('mvp/EditConfigs', 'superadmin', 'It is used to determine who can edit the config. THIS RIGHT ALLOWS YOU TO VIEW SENSITIVE INFORMATION')
    
    if SERVER then
        local globals = mvp.data.Get('config', {}, true, true)
        local data = mvp.data.Get('config', {}, false , true)

        for k, v in pairs(globals) do
            mvp.config.stored[k] = mvp.config.stored[k] or {}
            mvp.config.stored[k].value = v
        end

        for k, v in pairs(data) do
            mvp.config.stored[k] = mvp.config.stored[k] or {}
            mvp.config.stored[k].value = v
        end
    end

    mvp.config.LoadFromDir('mvp/core/config')

    if SERVER then
        hook.Run('InitializedConfig')
    end
end

function mvp.config.LoadFromDir(path)
    local files, folders = file.Find(path .. '/*.lua', 'LUA')

    for k, v in pairs(files) do
        mvp.utils.Include(path .. '/' .. v, 'shared')
    end

    if SERVER then
        hook.Run('InitializedFileConfig')
    end
end

if SERVER then
    function mvp.config.GetChangedValues(sanitize)
        local data = {}

        for k,v in pairs(mvp.config.stored) do
            if sanitize and v.onlyServer then
                continue 
            end

            if v.default ~= v.value then
                data[k] = v.value
            end
        end

        return data
    end

    function mvp.config.Send(client)
        net.Start('mvpConfigList')
            net.WriteTable(mvp.config.GetChangedValues(true))
        net.Send(client)
    end

    function mvp.config.Save()
        local globals = {}
        local data = {}

        for k, v in pairs(mvp.config.GetChangedValues()) do
            if mvp.config.stored[k].global then
                globals[k] = v
            else
                data[k] = v
            end
        end

        mvp.data.Set('config', globals, true, true)
        mvp.data.Set('config', data, false, true)
    end

    net.Receive('mvpConfigSet', function(length, client)
        if not mvp.permission.Check(client, 'mvp/EditConfigs') then
            return 
        end

        local key = net.ReadString()
        local value = net.ReadType()

        local configEntry = mvp.config.stored[key]

        local validator = configEntry.validator or mvp.config.validators[configEntry.type] or function(value, defaultValue)
            return (value ~= nil) and (value ~= '') and type(value) == type(defaultValue)
        end

        local avaibleValues = {}

        if configEntry.data.from and isfunction(configEntry.data.from) then
            avaibleValues = configEntry.data.from()
        elseif configEntry.data.from then
            avaibleValues = configEntry.data.from
        end

        if validator(value, configEntry.default, avaibleValues) then
            mvp.config.Set(key, value)
        end
    end)
else
    net.Receive('mvpConfigList', function()
        local data = net.ReadTable()

        for k, v in pairs(data) do
            if mvp.config.stored[k] then
                mvp.config.stored[k].value = v
            end
        end

        hook.Run('RecivedMVPConfigs')
    end)

    net.Receive('mvpConfigSet', function()
        local key = net.ReadString()
        local value = net.ReadType()

        local config = mvp.config.stored[key]

        if config then
            if config.callback then
                config.callback(config.value, value)
            end

            if mvp.config.Get('canPlayersSeeConfigPopups') then
                mvp.utils.Popup(5, nil, COLOR_WHITE, 'Config value "' .. key .. '" set to "' .. tostring(value) .. '"!')
            elseif LocalPlayer():IsAdmin() then
                mvp.utils.Popup(5, nil, COLOR_WHITE, 'Config value "' .. key .. '" set to "' .. tostring(value) .. '"!')
            end
            

            config.value = value
        end
    end)
end