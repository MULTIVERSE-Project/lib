--- @module mvp.config
mvp.config = mvp.config or {}

function mvp.config.GetChangedValues(sanitaze)
    local data = {}
    local configs = mvp.config.stored

    for key, config in pairs(configs) do
        if sanitaze and config.serverOnly then
            continue
        end

        if config.value ~= config.default then
            data[key] = config.value
        end
    end

    return data
end

function mvp.config.Save()
    local globals = mvp.data.Get('config', {}, false, true) -- global configs
    local data = mvp.data.Get('config', {}, true, true) -- map only configs

    for k, v in pairs(mvp.config.GetChangedValues(false)) do
        if mvp.config.stored[k].mapOnly then
            data[k] = v
        else
            globals[k] = v
        end
    end

    mvp.data.Set('config', globals, false) -- save global configs
    mvp.data.Set('config', data, true) -- save map only configs
end

net.Receive('mvpConfigSet', function(_, ply)
    local key = net.ReadString()
    local value = net.ReadType()

    local config = mvp.config.stored[key]
    
    if type(config.default) ~= type(value) then
        return 
    end

    mvp.config.Set(key, value)
end)