util.AddNetworkString("aphone_RadioVolume")
util.AddNetworkString("aphone_ChangeRadio")

net.Receive("aphone_RadioVolume", function(_, ply)
    if !aphone.NetCD(ply, "RadioVolume", 0.1) then return end
    local float = net.ReadUInt(7)

    if float < 0 or float > 100 then return end

    net.Start("aphone_RadioVolume")
        net.WriteEntity(ply)
        net.WriteUInt(float, 7)
    if aphone.OthersHearRadio then
        net.Broadcast()
    else
        net.Send(ply)
    end
end)

net.Receive("aphone_ChangeRadio", function(_, ply)
    if !aphone.NetCD(ply, "ChangeRadio", 0.33) then return end
    local id = net.ReadUInt(12)

    if id >= 0 and (aphone.RadioList[id] or id == 0) then
        net.Start("aphone_ChangeRadio")
            net.WriteEntity(ply)
            net.WriteUInt(id, 12)

        if aphone.OthersHearRadio then
            net.Broadcast()
        else
            net.Send(ply)
        end
    end
end)