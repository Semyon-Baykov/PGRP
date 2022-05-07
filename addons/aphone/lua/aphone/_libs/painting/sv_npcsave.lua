local function ReloadNPC()
    local datas = file.Read("aphone/npcdata.json")

    if datas then
        local datatbl = util.JSONToTable(datas)
        if datatbl then
            // delete old
            for k, v in ipairs(ents.GetAll()) do
                if v:GetClass() == "aphone_npc" then
                    v:Remove()
                end
            end

            // create new
            for k, v in pairs(datatbl) do
                local ent = ents.Create("aphone_npc")

                if IsValid(ent) then
                    ent:SetPos(v.pos)
                    ent:SetAngles(v.ang)
                    ent:Spawn()
                    ent:Activate()
                end
            end
            print("[APhone] Spawn NPCs")

            aphone.posinfos = datatbl
        else
            print("[APhone] Missing NPC pos ( Setup issue ? )")
        end
    end
end

concommand.Add("aphone_RemoveNPCs", function(ply)
    if IsValid(ply) and !ply:IsSuperAdmin() then return end

    for k,v in ipairs(ents.GetAll()) do
        if v:GetClass() == "aphone_resetnpc" then
            v:Remove()
        end
    end
end)

concommand.Add("aphone_SaveNPCs", function(ply)
    if IsValid(ply) and !ply:IsSuperAdmin() then return end
    aphone.posinfos = aphone.posinfos or {}

    for k,v in ipairs(ents.GetAll()) do
        if v:GetClass() == "aphone_npc" then
            table.insert(aphone.posinfos, {pos = v:GetPos(), ang = v:GetAngles()})
        end
    end

    if !file.Exists("aphone/", "DATA") then
        file.CreateDir("aphone")
    end

    file.Write("aphone/npcdata.json", util.TableToJSON(aphone.posinfos))
    ReloadNPC()
end)

hook.Add("InitPostEntity", "APhone_SecureNPCSpawn", function()
    ReloadNPC()
end)