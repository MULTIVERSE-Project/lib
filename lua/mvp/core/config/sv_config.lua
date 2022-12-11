--- @module mvp.config
mvp.config = mvp.config or {}

util.AddNetworkString('mvpConfigList')
util.AddNetworkString('mvpConfigSet')

util.AddNetworkString('mvpConfigCommand')

util.AddNetworkString('mvpConfigRequestFullConfig')

--- Gets changed values in config
-- @realm server
-- @bool sanitaze if values should be sanitazed (removese server-only configurations)
-- @treturn table changed values
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

--- Send information about configs to the player
-- @realm server
-- @tparam Player ply Player that will recive configs
-- @bool sanitaze If values should be sanitazed
function mvp.config.Send(ply, sanitaze)
    local configs = mvp.config.GetChangedValues(sanitaze)

    net.Start('mvpConfigList')
        net.WriteTable(configs)
    net.Send(ply)
end

--- Saves config values
-- @realm server
-- @internal
function mvp.config.Save()
    local globals = {} -- mvp.data.Get('config', {}, false, true) -- global configs
    local data = {} -- mvp.data.Get('config', {}, true, true) -- map only configs

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

-- Handle config change request
net.Receive('mvpConfigSet', function(_, ply)
    if not mvp.permissions.Check(ply, 'mvp.editConfigs') then
        return 
    end

    local key = net.ReadString()
    local value = net.ReadType()

    local config = mvp.config.stored[key]
    
    if type(config.default) ~= type(value) then
        return 
    end

    local success, value = mvp.config.Set(key, value)

    if not success then
        return 
    end

    mvp.utils.Print(Color(0, 0, 255), ply:Nick(), Color(255, 255, 255), ' changed ', Color(0, 255, 0), key, Color(255, 255, 255), ' to ', (type(value) == 'boolean' and (value and Color(0, 255, 0) or Color(255, 0, 0))) or Color(0, 0, 255), value)
end)

net.Receive('mvpConfigRequestFullConfig', function(_, ply)
    if ply.mvpHasRequestedConfigs then
        return 
    end

    ply.mvpHasRequestedConfigs = true
    mvp.config.Send(ply, true)
end)
