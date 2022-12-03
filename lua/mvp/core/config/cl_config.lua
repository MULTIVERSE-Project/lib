--- @module mvp.config
mvp.config = mvp.config or {}

net.Receive('mvpConfigList', function()
    local data = net.ReadTable()

    for k, v in pairs(data) do
        if not mvp.config.stored[k] then
            mvp.config.stored[k] = {} -- create dummy config
        end

        mvp.config.stored[k].value = v
    end

    hook.Run('mvp.hooks.configLoaded')
end)

net.Receive('mvpConfigSet', function()
    local key = net.ReadString()
    local value = net.ReadType()

    local config = mvp.config.stored[key]

    if config then
        if config.callback then
            config.callback(config.value, value)
        end        

        config.value = value
    end
end)