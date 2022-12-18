local currency = {}

function currency:GetPlayerMoney(ply)
    return ply:getDarkRPVar('money') or 0
end

function currency:AddMoney(ply, amount)
    return ply:addMoney(amount)
end

function currency:CanAfford(ply, amount)
    return ply:canAfford(amount)
end

function currency:FormatMoney(money)
    return DarkRP.formatMoney(money)
end

mvp.currencies.Register('darkrp', currency)