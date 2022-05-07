SDNA.Ragdolls = SDNA.Ragdolls or {}
SDNA.RemoveTime = 150
util.AddNetworkString('SDNA#')

net.Receive('SDNA#', function(len, ply)
    local entity = net.ReadEntity()
    local wtype = net.ReadUInt(2)

    if entity.data.score ~= 0 then
        if wtype == 1 then
            if entity.data['attacker']:Alive() then
                SDNA.SetData(entity, 'score', entity.data['score'] - 1)
                SDNA.SetData(ply, 'DNAR', entity)
                SDNA.SetData(ply, 'DNAA', entity.data['attacker'])
                SDNA.SetData(ply, 'DNAP', entity.data['victim'])
                SDNA.SetData(ply, 'DNAT', CurTime())
                SDNA.SetData(entity.data['attacker'], 'DNAWanted', 1)
            else
                SDNA.SetData(entity, 'DNAFinded', 1)
                ply:ChatPrint('Убийца мертв.')
            end
        else
            if (CurTime() - entity.last_mark) >= 60 then
                ply:ConCommand('darkrp 911 ' .. '"Здесь убитый ' .. string.lower(entity.data['job']) .. '!"')
                entity.last_mark = CurTime()
                umsg.Start('markmsg')
                umsg.Vector(entity:GetPos())
                umsg.String('Здесь убитый ' .. string.lower(entity.data['job']))
                umsg.String('police')
                umsg.End()
            end
        end
    end
end)

function SDNA.GetReason(victim, inflictor, attacker)
    if (victim == attacker and victim == inflictor) or (attacker == Entity(0) and inflictor == Entity(0)) then
        return 'суицид'
    elseif attacker:IsVehicle() and inflictor:IsVehicle() then
        return 'ДТП'
    elseif attacker:IsPlayer() then
        return 'убийство'
    elseif attacker:IsNPC() then
        return 'NPC'
    elseif attacker:GetClass() == 'prop_physics' then
        return 'предмет'
    else
        return 'неизвестно'
    end
end

function SDNA.RemoveRagdolls()
    if table.Count(SDNA.Ragdolls) ~= 0 then
        for k, v in pairs(SDNA.Ragdolls) do
            if IsValid(v) then
                v:Remove()
            end
        end

        SDNA.Ragdolls = {}

        return true
    end

    return false
end

function SDNA.SetData(entity, vname, value)
    entity.data = entity.data or {}
    entity.data[vname] = value

    if isstring(value) then
        return entity:SetNWString(vname, value)
    elseif isnumber(value) then
        return entity:SetNWInt(vname, value)
    elseif isentity(value) then
        return entity:SetNWEntity(vname, value)
    end
end

function SDNA.toRealUnits(units)
    return (units * 0.75) * 0.0254
end

function SDNA.CreateRagdoll(ply, inflictor, attacker)
    local oldragdoll = ply:GetRagdollEntity()

    if IsValid(oldragdoll) then
        oldragdoll:Remove()
    end

    if not IsValid(ply) then return end

    if IsValid(SDNA.Ragdolls[ply]) then
        SDNA.Ragdolls[ply]:Remove()
    end

    ply.data = ply.data or {}
    --/////////////////////////////
    --		 CreateRagdoll 		//
    --///////////////////////////
    local Ragdoll = ents.Create('prop_ragdoll')
    Ragdoll:SetModel(ply:GetModel() or 'models/kleiner.mdl')
    Ragdoll:SetPos(ply:GetPos())
    Ragdoll:Spawn()
    ply:SetNWEntity('DeathRagdoll', Ragdoll)
    SDNA.Ragdolls[ply] = Ragdoll
    Ragdoll.last_mark = CurTime() - 60
    --/////////////////////////////
    --		 Setting data 		//
    --///////////////////////////
    SDNA.SetData(Ragdoll, 'victim', ply)
    SDNA.SetData(Ragdoll, 'attacker', attacker)
    SDNA.SetData(Ragdoll, 'reason', SDNA.GetReason(ply, inflictor, attacker))
    SDNA.SetData(Ragdoll, 'weapon', (attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon())) and attacker:GetActiveWeapon():GetClass() or 'none')
    SDNA.SetData(Ragdoll, 'job', ply:getDarkRPVar('job') or 'none')
    SDNA.SetData(Ragdoll, 'model', ply:GetModel() or 'models/kleiner.mdl')
    SDNA.SetData(Ragdoll, 'distance', SDNA.toRealUnits(ply:GetPos():Distance(attacker:GetPos()) or 0))
    SDNA.SetData(Ragdoll, 'time', CurTime())
    SDNA.SetData(Ragdoll, 'removetime', SDNA.RemoveTime)
    SDNA.SetData(Ragdoll, 'score', 3)
    --///////////////////////////////
    --	 Setting bones and other  //
    --/////////////////////////////
    Ragdoll:GetPhysicsObject():SetMaterial('armorflesh')

    for i = 1, Ragdoll:GetPhysicsObjectCount() do
        local phys = Ragdoll:GetPhysicsObjectNum(i)

        if IsValid(phys) then
            phys:SetMaterial('armorflesh')
        end
    end

    --////////////////////////////
    local Vel = ply:GetVelocity()

    for i = 1, Ragdoll:GetPhysicsObjectCount() - 1 do
        local PhysBone = Ragdoll:GetPhysicsObjectNum(i)

        if IsValid(PhysBone) then
            local Pos, Ang = ply:GetBonePosition(Ragdoll:TranslatePhysBoneToBone(i))
            PhysBone:SetPos(Pos)
            PhysBone:SetAngles(Ang)
            PhysBone:AddVelocity(Vel)
        end
    end

    if ply.data.DNAWanted then
        SDNA.DNAFinded(ply or 'nil', 'убит' .. (attacker:IsPlayer() and (attacker:Team() == 24 and ' сотрудником ФСБ' or '') or ''))
    end

    timer.Simple( 2.5, function()

        if IsValid( Ragdoll ) then

            Ragdoll:SetCollisionGroup(2)

        end

    end)

    timer.Create('DNA#' .. Ragdoll:EntIndex(), SDNA.RemoveTime, 1, function()
        if IsValid(Ragdoll) then
            Ragdoll:Remove()
        end
    end)
end

function SDNA.DNAFinded(criminal, how)
    for k, v in pairs(player.GetAll()) do
        if v:Team() == 24 and v.data.DNAA == criminal then
            v:ChatPrint('[ДНК] ' .. criminal:Nick() or 'nil' .. ' - убийца ' .. v.data.DNAP:Nick() or 'nil' .. ' был ' .. how .. '.')
            v.data = v.data or {}
            SDNA.SetData(v.data.DNAR, 'DNAFinded', 1)
            v:SetNWEntity('DNAP', nil)
            v.data.DNAP = nil
            v:SetNWEntity('DNAA', nil)
            v.data.DNAA = nil
            v:SetNWInt('DNAT', nil)
            v.data.DNAT = nil
            v:SetNWInt('DNAR', nil)
            v.data.DNAR = nil
            SDNA.SetData(criminal, 'DNAWanted', 0)
            v:ConCommand('dna_remove')
        end
    end
end

function ulx.removebodies(calling_ply)
    ulx.fancyLogAdmin(calling_ply, '#A очистил карту от трупов')
end

local removebodies = ulx.command("Utility", "ulx removebodies", ulx.removebodies, "!removebodies")
removebodies:defaultAccess(ULib.ACCESS_SUPERADMIN)
removebodies:help("Удалить трупы игроков.")
--hook.Add('PlayerDeath', 'SDNA', SDNA.CreateRagdoll)

    -- hook.Add( 'Think', 'SDNA', function() хуйня все это

    --   if table.Count(SDNA.Ragdolls) ~= 0 then

    --     for k, v in pairs(SDNA.Ragdolls) do
    --         if IsValid(v) and IsValid( v:GetNWEntity( 'victim' ) ) then
                
    --             v:GetNWEntity( 'victim' ):SetPos( v:GetPos() )

    --         end
    --     end

    --     SDNA.Ragdolls = {}

    --     return true

    -- end


    -- end)

hook.Add('playerArrested', 'SDNA', function(criminal, time, actor)
    criminal.data = criminal.data or {}

    if criminal.data.DNAWanted then
        SDNA.DNAFinded(criminal, 'арестован')
    end
end)

hook.Add('PlayerDisconnected', 'SDNA', function(ply)
    ply.data = ply.data or {}

    if ply.data.DNAWanted then
        SDNA.DNAFinded(ply, 'застрелен на границе Украины')
    end
end)

hook.Add('KeyPress', 'SDNA', function(ply, key)
    local trace = ply:GetEyeTrace()
    if key ~= IN_USE then return end

    if trace.Entity.data and trace.Entity:GetClass() == 'prop_ragdoll' and ply:GetPos():Distance(trace.Entity:GetPos()) < 60 then
        local rag = trace.Entity
        ply:SendLua([[ SDNA.Show( Entity( ]] .. rag:EntIndex() .. [[ ) ) ]])
    end
end)