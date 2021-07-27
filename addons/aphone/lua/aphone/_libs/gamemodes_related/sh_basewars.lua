-- My own basewars gamemode, not the gmodstore one
if basewars and basewars.config and basewars.config.jetski then
    aphone.Gamemode = {}

    function aphone.Gamemode.Afford(ply, amt)
        return ply:GetMoney() >= amt
    end

    function aphone.Gamemode.AddMoney(ply, amt)
        if ply:GetMoney() + amt < 0 then return false end

        ply:SetNWString("Money", ply:GetMoney() + amt)
        ply:SetNWString("MoneyMade", tostring(tonumber(ply:GetNWString("MoneyMade")) + amt))
        ply:SendNotif("Vous avez reçu " .. tostring(pretty_value(math.Round(amt))), "blue", "You received " .. tostring(pretty_value(math.Round(amt))))
        ply:SaveSQL(ply:GetNWString("Money"), "money")
        ply:SaveSQL(ply:GetNWString("MoneyMade"), "moneymade")
    end

    function aphone.Gamemode.Format(amt)
        return pretty_value(amt, 0)
    end
end
