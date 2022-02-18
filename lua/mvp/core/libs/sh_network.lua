mvp.network = mvp.network or {}

NETWORK_PUBLIC = 1
NETWORK_PRIVATE = 2

mvp.network.manager = mvp.network.manager or {idenity = 'mvpNWManager'}
mvp.network.storage = mvp.network.storage or {}
mvp.network.publicStorage = mvp.network.publicStorage or {}

function mvp.network.Get(ent, key)
    local entIndex = ent:EntIndex()

    return mvp.network.storage[entIndex] and (mvp.network.storage[entIndex][key] or false) or false
end

if SERVER then
    util.AddNetworkString(mvp.network.manager.idenity .. 'DataStream')
    util.AddNetworkString(mvp.network.manager.idenity .. 'SetupStorage')

    function mvp.network.Set(ent, key, value, protocol)
        local entIndex = ent:EntIndex()
        protocol = protocol or NETWORK_PRIVATE
        
        mvp.network.storage[entIndex] = mvp.network.storage[entIndex] or {}
        mvp.network.storage[entIndex][key] = value

        if protocol == NETWORK_PUBLIC then
            mvp.network.publicStorage[entIndex] = mvp.network.publicStorage[entIndex] or {}
            mvp.network.publicStorage[entIndex][key] = value
        end

        net.Start(mvp.network.manager.idenity .. 'DataStream')
            net.WriteInt(entIndex, 32)
            net.WriteString(key)
            net.WriteTable({value})
        net[protocol == NETWORK_PUBLIC and 'Broadcast' or 'Send'](ent)
    end

    function mvp.network.SetupStorage(ent)
        net.Start(mvp.network.manager.idenity .. 'SetupStorage')
            net.WriteTable(mvp.network.publicStorage)
        net.Send(ent)
    end
else
    net.Receive(mvp.network.manager.idenity .. 'DataStream', function()
        local index = net.ReadInt(32)
        local key = net.ReadString()
        local value = net.ReadTable()[1]

        mvp.network.storage[index] = mvp.network.storage[index] or {}
        mvp.network.storage[index][key] = value

        hook.Run('NetworkDataUpdated', index, key, value)
    end)

    net.Receive(mvp.network.manager.idenity .. 'SetupStorage', function()
        local storage = net.ReadTable()

        mvp.network.storage = storage
    end)
end