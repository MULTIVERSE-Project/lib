--- @module mvp.currencies

mvp.currencies = mvp.currencies or {}
mvp.currencies.list = mvp.currencies.list or {}

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

function mvp.currencies.Get(id)
    return mvp.currencies.list[id] or nil
end

function mvp.currencies.GetActive()
    return mvp.currencies.list[mvp.config.Get('currency')] or nil
end

function mvp.currencies.GetMoney(amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.GetPlayerMoney) then
        return false
    end

    return activeCurrency:GetPlayerMoney(amount)
end
function mvp.currencies.CanAfford(ply, amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.CanAfford) then
        return false
    end

    return activeCurrency:CanAfford(ply, amount)
end
function mvp.currencies.AddMoney(ply, amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.AddMoney) then
        return false
    end

    return activeCurrency:AddMoney(ply, amount)
end
function mvp.currencies.FormatMoney(amount)
    local activeCurrency = mvp.currencies.GetActive()

    if not activeCurrency or not isfunction(activeCurrency.FormatMoney) then
        return false
    end

    return activeCurrency:FormatMoney(amount)
end

function mvp.currencies.LoadFromFolder(path)
    mvp.loader.LoadFolder(path, true)
end

function mvp.currencies.Init()
    mvp.currencies.LoadFromFolder('mvp/currencies')
end