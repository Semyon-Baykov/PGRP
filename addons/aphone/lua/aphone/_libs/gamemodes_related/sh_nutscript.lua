hook.Add("PostGamemodeLoaded", "APhone_GR_Nut", function()
    if nut then
        aphone.Gamemode = {}

        function aphone.Gamemode.Afford(ply, amt)
            return ply:canAfford(amt)
        end
    
        function aphone.Gamemode.AddMoney(ply, amt)
            local c = ply:getChar()
    
            local money = c:getMoney()
            if money + amt < 0 then return false end
    
            c:addMoney(c:getMoney() + amt)
            return true
        end
    
        function aphone.Gamemode.Format(amt)
            return nut.currency.get(amt)
        end

        function aphone.Gamemode.GetMoney(ply)
            return ply:getChar():getMoney()
        end
    end
end)
