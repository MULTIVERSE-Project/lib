local currency = {}

function currency:GetPlayerMoney(ply)
    return 99999
end

function currency:CanAfford(ply, amount)
    return true
end

function currency:AddMoney(ply, amount)
    return true
end

function currency:FormatMoney(amount)
    return amount .. ' mvp$'
end

mvp.currencies.Register('blank', currency)