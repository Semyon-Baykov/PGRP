util.AddNetworkString("aphone_darkweb")

aphone.Deepweb_Contracts = aphone.Deepweb_Contracts or {}

local function delete(uid, refund)
    local t = aphone.Deepweb_Contracts[uid]
    if refund and IsValid(t.owner) then
        aphone.Gamemode.AddMoney(t.owner, t.price)
    end

    net.Start("aphone_darkweb")
        net.WriteBool(true)
        net.WriteUInt(uid, 32)
    net.Broadcast()

    hook.Run("aphone_deepwebdelete", t.owner, t.target, t.price)
    aphone.Deepweb_Contracts[uid] = nil
end

local function create(owner, target, price)
    if !IsValid(target) or price == 0 or !aphone.Gamemode.Afford(owner, price) or ent == owner then return end

    aphone.Gamemode.AddMoney(owner, -price)

    aphone.Deepweb_Contracts[owner:UserID()] = {
        target = target,
        price = price,
        owner = owner,
        start = CurTime(),
    }

    net.Start("aphone_darkweb")
        net.WriteBool(false)
        net.WriteEntity(owner)
        net.WriteEntity(target)
        net.WriteUInt(price, 32)
    net.Broadcast()

    timer.Simple(1800, function()
        if IsValid(owner) and aphone.Deepweb_Contracts[owner:UserID()] and aphone.Deepweb_Contracts[owner:UserID()].target == ent then
            delete(owner:UserID(), true)
        end
    end)
    hook.Run("aphone_deepweb", owner, target, price)
end

net.Receive("aphone_darkweb", function(_, ply)
    if !aphone.NetCD(ply, "darkweb", 1) then return end
    local remove = net.ReadBool()

    if !remove and !aphone.Deepweb_Contracts[ply:UserID()] then
        create(ply, net.ReadEntity(), net.ReadUInt(32))
    elseif remove then
        delete(ply:UserID(), true)
    end
end)

hook.Add("PlayerDeath", "aphone_darkrp_pay", function(victim, _, atk)
    if !atk:IsPlayer() then return end

    for k, v in pairs(aphone.Deepweb_Contracts) do
        if v.target == atk then continue end

        if v.target == victim then
            aphone.Gamemode.AddMoney(atk, v.price)
            delete(k)
        end
    end
end)

hook.Add("PlayerDisconnected", "aphone_darkrp_refund", function(ply)
    if aphone.Deepweb_Contracts[ply:UserID()] then
        aphone.Gamemode.AddMoney(ply, aphone.Deepweb_Contracts[ply:UserID()].price)
        delete(ply:UserID())
    end

    for k, v in pairs(aphone.Deepweb_Contracts) do
        if v.target == ply and IsValid(v.owner) then
            delete(k, true)
        end
    end
end)