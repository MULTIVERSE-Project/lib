local currency = {}

function currency:GetPlayerMoney(ply)
    return ply:getMoney() or 0
end

function currency:AddMoney(ply, amount)
    if amount > 0 then
        ply:getChar():giveMoney(amount)
    else
        ply:getChar():takeMoney(amount)
    end
end

function currency:CanAfford(ply, amount)
    if not ply:getChar():hasMoney(amount) then
        return false
    else
        return true
    end
end

function currency:FormatMoney(amount)
    return nut.currency.get(amount)
end

mvp.currencies.Register('nutscript', currency)
