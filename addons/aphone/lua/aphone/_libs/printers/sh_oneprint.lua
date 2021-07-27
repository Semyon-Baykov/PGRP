hook.Add("PostGamemodeLoaded", "APhone_LoadPrinter_OnePrint", function()
    if OnePrint then
        aphone.Printer = aphone.Printer or {}

        function aphone.Printer.GetPrinters(ply)
            local tbl = {}

            for k, v in ipairs(ents.FindByClass("oneprint")) do
                if !v:IsLocked() or ( v:GetOwnerObject() == pPlayer ) or !v:GetPowered() then
                    table.insert(tbl, v)
                    continue
                end

                for i, j in pairs( v:GetUsers() ) do
                    if ( j == pPlayer ) then
                        table.insert(tbl, v)
                        continue
                    end
                end
            end

            return tbl
        end

        function aphone.Printer.FormatMoney(amt)
            return OnePrint:FormatMoney( amt )
        end

        function aphone.Printer.GetInfo(ents)
            local capacity = 0
            local money = 0
            local sec = 0
            local danger = 0

            for k, v in ipairs(ents) do
                if IsValid(v) then
                    money = money + v:GetMoney()
                    capacity = capacity + v:GetStorage()

                    if !v:IsStorageFull() then
                        sec = sec + v:GetTotalIncome()
                    end

                    danger = danger + (v:GetTemperature() >= 80 and 0 or 1)
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