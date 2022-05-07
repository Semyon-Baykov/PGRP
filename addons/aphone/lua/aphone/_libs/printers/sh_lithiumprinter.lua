hook.Add("PostGamemodeLoaded", "APhone_LoadPrinter_LthiumPrinter", function()
    if lp then
        aphone.Printer = aphone.Printer or {}

        function aphone.Printer.GetPrinters(ply)
            local tbl = {}

            for k, v in ipairs(ents.FindByClass("lithium_*_printer")) do
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
                    money = money + v.data.stored
                    capacity = capacity + v.data.storage

                    if v.data.status and v.data.stored < v.data.storage and !v.data.isMalfunction then
                        sec = sec + (v.data.delay / v.data.delay)
                    end

                    danger = danger + (v.data.isOverheat and 1 or 0)
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