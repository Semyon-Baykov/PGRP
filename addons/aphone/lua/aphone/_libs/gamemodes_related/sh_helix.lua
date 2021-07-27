// I don't know if i'm dumb, but I didn't found any hooks post load
hook.Add("PostGamemodeLoaded", "APhone_GR_Helix", function()
    if ix then
        aphone.Gamemode = {}

        function aphone.Gamemode.Afford(ply, amt)
            return ply:GetCharacter():GetMoney() > amt
        end

        function aphone.Gamemode.AddMoney(ply, amt)
            local c = ply:GetCharacter()

            local money = c:GetMoney()
            if money + amt < 0 then return false end

            c:SetMoney(c:GetMoney() + amt)
            return true
        end

        function aphone.Gamemode.Format(amt)
            return ix.currency.Get(amt)
        end

        function aphone.Gamemode.GetMoney(ply)
            return ply:GetCharacter():GetMoney()
        end
    end
end)
