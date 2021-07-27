hook.Add("PostGamemodeLoaded", "APhone_LoadPrinter_RPrint", function()
    if rPrint then
        aphone.Printer = aphone.Printer or {}

        function aphone.Printer.GetPrinters(ply)
            local tbl = {}

            for k, v in ipairs(ents.FindByClass("rprint*")) do
                if v:CPPIGetOwner() == ply or v:Getowning_ent() == ply then
                    table.insert(tbl, v)
                end
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

            for k, v in ipairs(ents or {}) do
                if IsValid(v) then
                    money = money + v:GetMoney()
                    capacity = money

                    if (v:GetPower() > 0) then
                        sec = sec + v.Params.PrintRate*60
                    end

                    danger = danger + (v:GetTemp() < v.Params.TempMax and 0 or 1)
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