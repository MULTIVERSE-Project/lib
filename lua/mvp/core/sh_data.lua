mvp = mvp or {}
mvp.data = mvp.data or {}
mvp.data.stored = mvp.data.stored or {}

local dirToSave = 'mvp/data/'

file.CreateDir(dirToSave)

function mvp.data.Set(key, value, bIgnoreMap)
    
    local path = dirToSave .. (bIgnoreMap and '' or game.GetMap() .. '/')

    file.CreateDir(path)

    file.Write(path .. key .. '.txt', util.TableToJSON({value}))

    mvp.data.stored[key] = value
end

function mvp.data.Get(key, default, bIgnoreMap, bRefresh)
    
    if not bRefresh then
        local stored = mvp.data.stored[key]
        if stored ~= nil then
            return stored
        end
    end

    local path = dirToSave .. (bIgnoreMap and '' or game.GetMap() .. '/')
    local contents = file.Read(path ..  key .. '.txt', 'DATA')

    if contents and contents ~= '' then
        local status, result = pcall(util.JSONToTable, contents)

        if status then
            local value = result[1]
            if value ~= nil then
                mvp.data.stored[key] = value
                return value
            end
        end
    else
        print('Not found', key)
        -- @todo Добавить лог о проебе даты
    end

    return default
end

function mvp.data.Delete(key, bIgnoreMap)
    local path = dirToSave .. (bIgnoreMap and '' or game.GetMap() .. '/')
    local contents = file.Read(path .. key .. '.txt', 'DATA')

    if contents and contents ~= '' then
        file.Delete(path .. key .. '.txt')
        mvp.data.stored[key] = nil
        return true
    end

    return false
end