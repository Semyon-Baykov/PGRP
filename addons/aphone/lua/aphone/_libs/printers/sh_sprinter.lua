hook.Add("PostGamemodeLoaded", "Aphone_SPrinter", function()
    if sPrinter then
        aphone.Printer = aphone.Printer or {}

        function aphone.Printer.GetPrinters(ply)
            local tbl = {}
    
            for k, ent in ipairs(ents.FindByClass("sprinter_tier*") or {}) do
                local data = ent.data
                local team = ply:Team()
                local team_name = RPExtraTeams[team].name
                local isListed = data.cantwithdrawjobs and data.cantwithdrawjobs[team_name]
    
                if (tobool(isListed) ~= tobool(data.withdrawjobswhitelist)) or (data.cantwithdrawusergroups and data.cantwithdrawusergroups[ply:GetUserGroup()]) then continue end
    
                table.insert(tbl, ent)
            end
    
            return tbl
        end
    
        function aphone.Printer.FormatMoney(amt)
            return aphone.Gamemode.Format(amt)
        end
    
        function aphone.Printer.GetInfo(ents)
            local capacity = 0
            local money = 0
            local sec = 0
            local danger = 0
    
            for k, v in ipairs(ents) do
                if IsValid(v) then
                    if v:GetBattery() <= 0 or !v:GetPower() then continue end
    
                    money = money + v:GetMoney()
                    capacity = capacity + v.data.maxstorage
    
                    if v.data.maxstorage > v:GetMoney() then
                        sec = sec + v:GetPrintSpeed()
                    end
    
                    local temp = v:GetTemperature()
                    local rack = v:GetRack()
    
                    if IsValid(rack) then
                        local racktemp = 0
                        if rack:GetSkin() == 1 then
                            racktemp = math.random(10, 15)
                        else
                            racktemp = math.random(25, 40)
                        end
    
                        if rack.printers then
                            racktemp = racktemp + (racktempsplit * table.Count(rack.printers))
                        end
    
                        temp = temp + racktemp
                    end
    
                    danger = danger + (v:GetTemperature() > 80 and 1 or 0)
                else
                    ents[k] = nil
                end
            end
    
            return {
                [1] = {
                    val = money,
                    name = "money",
                },
    
                [2] = {
                    val = sec,
                    name = "sec",
                },
    
                [3] = {
                    val = capacity,
                    name = "capacity",
                },
    
                [4] = {
                    val = danger,
                    name = "danger",
                },
            }, ents
        end
    end
end)