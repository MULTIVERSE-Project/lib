local currency = {}

function currency:GetPlayerMoney(ply)
    return ply:GetCharacter():GetMoney() or 0
end

function currency:AddMoney(ply, amount)
    local character = ply:GetCharacter()
    if amount > 0 then
        return character:GiveMoney(amount)
    else
        return character:TakeMoney(amount)
    end
end

function currency:CanAfford(ply, amount)
    return ply:GetCharacter():HasMoney(amount)
end

function currency:FormatMoney(money)
    return ix.currency.Get(amount)
end

mvp.currencies.Register('helix', currency)