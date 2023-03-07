--- @module mvp.currencies

mvp.currencies = mvp.currencies or {}
mvp.currencies.list = mvp.currencies.list or {}

--- Registers a currency.
-- @realm shared
-- @tparam string id The currency ID.
-- @tparam table tbl The currency table.
-- @treturn table The currency table.
function mvp.currencies.Register(id, tbl)
    if not tbl or not isfunction(tbl.GetPlayerMoney) then
        return mvp.utils.Error(Format('Can\'t add a currency without the GetPlayerMoney method! Currency ID "%s". Skipping.', id))
    end
    if not tbl or not isfunction(tbl.CanAfford) then
        return mvp.utils.Error(Format('Can\'t add a currency without the CanAfford method! Currency ID "%s". Skipping.', id))
    end
    if not tbl or not isfunction(tbl.AddMoney) then
        return mvp.utils.Error(Format('Can\'t add a currency without the AddMoney method! Currency ID "%s". Skipping.', id))
    end
    if not tbl or not isfunction(tbl.FormatMoney) then
        return mvp.utils.Error(Format('Can\'t add a currency without the FormatMoney method! Currency ID "%s". Skipping.', id))
    end

    mvp.currencies.list[id] = tbl

    mvp.utils.Print('Registered ', Color(140, 122, 230), id, color_white, ' currency.')

    return mvp.currencies.list[id]
end

--- Gets a currency.
-- @realm shared
-- @tparam string id The currency ID.
function mvp.currencies.Get(id)
    return mvp.currencies.list[id] or nil
end

--- Gets the active currency.
-- @realm shared
-- @treturn table The active currency table.
function mvp.currencies.GetActive()
    return mvp.currencies.list[mvp.config.Get('currency')] or nil
end

--- Gets the player's money.
-- @realm shared
-- @tparam Player ply The player.
-- @treturn[1] number The player's money.
-- @treturn[2] boolean `false` if the currency doesn't have the GetPlayerMoney method.
function mvp.currencies.GetMoney(ply)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.GetPlayerMoney) then
        return false
    end

    return activeCurrency:GetPlayerMoney(ply)
end

--- Checks if the player can afford the amount.
-- @realm shared
-- @tparam Player ply The player.
-- @tparam number amount The amount.
-- @treturn boolean Is the player able to afford the amount?
function mvp.currencies.CanAfford(ply, amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.CanAfford) then
        return false
    end

    return activeCurrency:CanAfford(ply, amount)
end

--- Adds money to the player.
-- @realm shared
-- @tparam Player ply The player.
-- @tparam number amount The amount.
-- @return The result of the currency's AddMoney method.
function mvp.currencies.AddMoney(ply, amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.AddMoney) then
        return false
    end

    return activeCurrency:AddMoney(ply, amount)
end

--- Formats the money.
-- @realm shared
-- @tparam number amount The amount.
-- @return The result of the currency's FormatMoney method.
function mvp.currencies.FormatMoney(amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.FormatMoney) then
        return false
    end

    return activeCurrency:FormatMoney(amount)
end

--- Loads a currencies files.
-- @realm shared
-- @tparam string path The path to the currency file.
function mvp.currencies.LoadFromFolder(path)
    mvp.loader.LoadFolder(path, true)
end

--- Initializes the currencies.
-- @realm shared
-- @internal
function mvp.currencies.Init()
    mvp.currencies.LoadFromFolder('mvp/currencies')
end