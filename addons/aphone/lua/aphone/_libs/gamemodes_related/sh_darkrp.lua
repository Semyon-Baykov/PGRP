hook.Add("DarkRPFinishedLoading", "aphone_LoadGMDarkRP", function()
    aphone.Gamemode = {}

    function aphone.Gamemode.Afford(ply, amt)
        return ply:canAfford(amt)
    end

    function aphone.Gamemode.AddMoney(ply, amt)
        local money = ply:getDarkRPVar("money")
        if money + amt < 0 then return false end

        ply:addMoney(amt)
        return true
    end

    function aphone.Gamemode.GetMoney(ply)
        if CLIENT then
            return LocalPlayer():getDarkRPVar("money")
        else
            return ply:getDarkRPVar("money")
        end
    end

    function aphone.Gamemode.Format(amt)
        return DarkRP.formatMoney(amt)
    end
end)
