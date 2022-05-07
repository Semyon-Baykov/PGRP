-- aphone.RegisterNumber(name, icon, func, desc, showcondition)
hook.Add("aphone_PostLoad", "Load_Compatibilities", function()
    -- 911 Emergency
    if CLIENT then
        aphone.RegisterNumber({
            name = aphone.L("Police"),
            icon = "akulla/aphone/specialcall_police.png",
            func = function()
                EmergencyResponse:CreateVictimInterface(false, "")
            end,
            desc = aphone.L("Police_Desc"),
            showcondition = function() return tobool(EmergencyResponse) end,
            clr = Color(55, 79, 107)
        })

        aphone.RegisterNumber({
            name = aphone.L("Services"),
            icon = "akulla/aphone/specialcall_services.png",
            func = function()
                RunConsoleCommand("fleodon_services")
            end,
            desc = aphone.L("Services_Desc"),
            showcondition = function()
                return tobool(FleodonServices)
            end,
            clr = Color(55, 79, 107)
        })

        for k, v in pairs(aphone.SpecialCalls) do
            if !v.name or !v.icon or !v.teams or table.IsEmpty(v.teams) then continue end

            aphone.RegisterNumber({
                name = v.name,
                icon = v.icon,
                func = function()
                    net.Start("aphone_SpecialCall")
                        net.WriteUInt(k, 8)
                    net.SendToServer()
                end,
                desc = v.desc,
                clr = Color(125, 125, 125)
            })
        end
    end
end)