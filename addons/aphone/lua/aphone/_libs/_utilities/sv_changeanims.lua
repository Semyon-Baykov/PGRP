-- I can't simulate keys, because it won't trigger the reload/secondary attack SWEP hooks, so I need this
local tbl = {
    [1] = ACT_VM_HITCENTER,
    [2] = ACT_VM_HITCENTER2
}

util.AddNetworkString("aphone_AskAnim")

net.Receive("aphone_AskAnim", function(_, ply)
    if not aphone.NetCD(ply, "AskAnimation", 0.9) then return end
    local wep = ply:GetActiveWeapon()

    if wep and IsValid(wep) and wep:GetClass() == "aphone" then
        local id = net.ReadUInt(4)

        if tbl[id] then
            wep:SendWeaponAnim(tbl[id])
        end
    end
end)