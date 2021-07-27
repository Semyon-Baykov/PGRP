util.AddNetworkString("aphone_bank")

net.Receive("aphone_bank", function(_, ply)
    local actid = net.ReadUInt(4)
    local amt = net.ReadUInt(32)

    if !aphone.NetCD(ply, "Bank", 2) or amt < 0 or actid < 1 or actid > 3 or !aphone.Bank then return end

    if actid == 1 then
        if aphone.bank_onlytransfer then return end

        ply:aphone_bankDeposit(amt)
    elseif actid == 2 then
        if aphone.bank_onlytransfer then return end

        ply:aphone_bankWithdraw(amt)
    elseif actid == 3 then
        local ent = net.ReadEntity()
        if !IsValid(ent) or ent == ply or !ent:IsPlayer() then return end

        ply:aphone_bankTransfer(ent, amt)
    end
end)