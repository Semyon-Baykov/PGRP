// You won't find this gamemode online, it's my private gm
hook.Add("Flux_LoadedGamemode", "aphone_LoadGMFlux", function()
    aphone.Gamemode = {}

    function aphone.Gamemode.Afford(ply, amt)
        return ply:canAfford(amt)
    end

    function aphone.Gamemode.AddMoney(ply, amt)
        return !ply:ChangeMoney(amt)
    end

    function aphone.Gamemode.Format(amt)
        return Flux:FormatMoney(amt)
    end

    function aphone.Gamemode.GetMoney(ply)
        return ply:GetMoney()
    end
end)
