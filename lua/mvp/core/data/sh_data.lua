--- @module mvp.data
mvp.data = mvp.data or {}

mvp.data.path = 'mvp/'
mvp.data.cache = mvp.data.cache or {
    global = {},
    map = {}
}

--- Sets value, and saves to file under `mvp/{map}/{key}.txt` or `mvp/global/{key}.txt`, and updates value in cache.
-- @realm shared
-- @tparam string key The key to set.
-- @tparam any value The value to set.
-- @tparam[opt=false] bool isMapOnly If true, the value will only be saved to the map folder.
function mvp.data.Set(key, value, isMapOnly)
    -- mvp/global/{key}.txt
    -- mvp/{map}/{key}.txt
    local path = mvp.data.path .. (isMapOnly and ( game.GetMap() .. '/') or 'global/') .. key .. '.txt'

    local preparedValue = util.TableToJSON({value})
    file.Write(path, preparedValue)

    mvp.data.cache[isMapOnly and 'map' or 'global'][key] = value
end

--- Gets value from data folder or cache.
-- @realm shared
-- @tparam string key The key to get.
-- @tparam any default The value if none present on `data/` folder.
-- @tparam[opt=false] bool isMapOnly If true, funcion will look in map folder insted of `global/`.
-- @tparam[opt=false] boll skipCache If true, will not use cache and will fetch from data folder insed of memory. If no value will be found in cache, this will try to find value in `data/` folder.
function mvp.data.Get(key, default, isMapOnly, skipCache)
    -- mvp/global/{key}.txt
    -- mvp/{map}/{key}.txt
    local path = mvp.data.path .. (isMapOnly and ( game.GetMap() .. '/') or 'global/') .. key .. '.txt'

    if not skipCache and mvp.data.cache[isMapOnly and 'map' or 'global'][key] then
        return mvp.data.cache[isMapOnly and 'map' or 'global'][key]
    end

    local preparedValue = file.Read(path, 'DATA')
    if preparedValue then
        return util.JSONToTable(preparedValue)[1]
    end

    return default
end