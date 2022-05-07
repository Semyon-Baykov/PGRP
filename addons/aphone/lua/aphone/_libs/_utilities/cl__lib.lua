aphone.SpecialNumbers = aphone.SpecialNumbers or {}

function aphone.RegisterNumber(info)
    if not isstring(info.name) or not isfunction(info.func) or not isstring(info.icon) then return end
    info.icon = Material(info.icon, "smooth 1")

    if info.icon and !info.icon:IsError() then
        aphone.SpecialNumbers[info.name] = info

        return true
    end
end

function aphone.playringtone()
    local id
    local l = aphone.L("Ringtones")

    for k, v in pairs(aphone.Params[l]) do
        if aphone:GetParameters(l, k, false) then
            id = tonumber(string.sub(k, 11))
            break
        end
    end

    if id and aphone.Ringtones and aphone.Ringtones[id] then
        sound.PlayURL(aphone.Ringtones[id].url, "", function( station, errorID, errorname)
            if ( IsValid( station ) ) then
                station:Play()
            else
                surface.PlaySound("akulla/phone_ringing.mp3")
            end
        end )
    else
        surface.PlaySound("akulla/phone_ringing.mp3")
    end
end

-- Load Player
net.Receive("aphone_GiveID", function()
    local e = net.ReadEntity()

    if IsValid(e) then
        e.aphone_ID = net.ReadUInt(32)
        e.aphone_number = net.ReadUInt(30)
    end
end)

net.Receive("aphone_OldID", function()
    local p = LocalPlayer()

    for k, v in pairs(player.GetHumans()) do
        if v ~= p then
            v.aphone_ID = net.ReadUInt(32)
            v.aphone_number = net.ReadUInt(30)
        end
    end
end)

hook.Add("InitPostEntity", "aphone_AskSQL", function()
    net.Start("aphone_AskSQL")
    net.SendToServer()
end)