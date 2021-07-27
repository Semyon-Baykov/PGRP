--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]
Realistic_Police = Realistic_Police or {}

-- Send a notification to a player 
function Realistic_Police.SendNotify(ply, msg)
    net.Start("RealisticPolice:Open")
        net.WriteString("Notify")
        net.WriteString(msg)
    net.Send(ply)
end 

-- This function generate a random plate 
function Realistic_Police.GeneratePlate(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    local RealisticPoliceFil = file.Read("realistic_police/rpt_plate.txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {} 
    local String = Realistic_Police.Letters().." "..Realistic_Police.Number().." "..Realistic_Police.Letters()
    
    -- Check if the plate does not exist and check if the player don't have already a data 
    if not Realistic_Police.CheckExist(String) && not Realistic_Police.PlayerData(ply) then 
        RealisticPoliceTab[ply:SteamID()] = {
            ["Plate"] = String,
            ["CustomPlate"] = "", 
        }
        file.Write("realistic_police/rpt_plate.txt", util.TableToJSON(RealisticPoliceTab, true))
    elseif not Realistic_Police.PlayerData(ply) then 
        Realistic_Police.GeneratePlate(ply)
    end
end 

-- Check if the Plate already exist 
function Realistic_Police.CheckExist(Plate)
    if not isstring(Plate) then return end 

    local RealisticPoliceFil = file.Read("realistic_police/rpt_plate.txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {} 

    for k,v in pairs(RealisticPoliceTab) do 
        if v.Plate == Plate then 
            return true 
        end 
    end 
    return false 
end 

-- Check if the player have already a license plate 
function Realistic_Police.PlayerData(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    
    local RealisticPoliceFil = file.Read("realistic_police/rpt_plate.txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {} 
    
    return istable(RealisticPoliceTab[ply:SteamID()]) 
end 

-- Get the Plate of the player by his steamid 
function Realistic_Police.GetPlate(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    local RealisticPoliceFil = file.Read("realistic_police/rpt_plate.txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {} 

    if not istable(RealisticPoliceTab[ply:SteamID()]) then return end 

    return RealisticPoliceTab[ply:SteamID()]["Plate"] 
end 

-- Compress the Report table and Send the table to client 
function Realistic_Police.SendReport(RPTSteamID64, ply) 
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    local RealisticPoliceFil = file.Read("realistic_police/report/"..RPTSteamID64..".txt", "DATA") or ""
    local CompressTable = util.Compress(RealisticPoliceFil)
    
    net.Start("RealisticPolice:Report")
        net.WriteInt(CompressTable:len(), 32)
        net.WriteData(CompressTable, CompressTable:len() )
    net.Send(ply)
end 

-- Compress the Criminal Record table and Send the table to client 
function Realistic_Police.SendRecord(RPTSteamID64, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    if not IsValid(player.GetBySteamID64(RPTSteamID64)) or not player.GetBySteamID64(RPTSteamID64):IsPlayer() then return end 

    local RealisticPoliceFil = file.Read("realistic_police/record/"..RPTSteamID64..".txt", "DATA") or ""
    local CompressTable = util.Compress(RealisticPoliceFil)

    net.Start("RealisticPolice:CriminalRecord")
        net.WriteInt(CompressTable:len(), 32)
        net.WriteData(CompressTable, CompressTable:len())
        net.WriteEntity(player.GetBySteamID64(RPTSteamID64))
    net.Send(ply)
end 

-- Random letters for the license plate
function Realistic_Police.Letters()
    return string.char( math.random(65,90 ))..string.char( math.random(65,90 )) 
end 

-- Random numbers for the license plate 
function Realistic_Police.Number()
    return tostring(math.random(1, 9)..math.random(1, 9)..math.random(1, 9)) 
end 

function Realistic_Police.SetInfoVehc(ent)
    -- Set the License plate of the player on the vehicle
    if not IsValid(ent) or not ent:IsVehicle() && ent:GetClass() != "gmod_sent_vehicle_fphysics_base" then return end 
    ent:SetNWString("rpt_plate", Realistic_Police.GetPlate(ent:CPPIGetOwner()))
end 

-- Reset position of all bones for surrender and cuffed 
function Realistic_Police.ResetBonePosition(Table, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    for k,v in pairs(Table) do 
        if isnumber(ply:LookupBone( k )) then 
		    ply:ManipulateBoneAngles(ply:LookupBone( k ), Angle(0,0,0))
        end 
	end 
    ply:StripWeapon("weapon_rpt_cuffed")
    ply:StripWeapon("weapon_rpt_surrender")
end 

-- Check if the name of the fine is on the configuration 
function Realistic_Police.CheckValidFine(String)
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if v.Name == String then 
            return true 
        end 
    end 
end

function Realistic_Police.AddCriminalRecord(ply, Table)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    local RealisticPoliceFil = file.Read("realistic_police/record/"..ply:SteamID64()..".txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}
    
    -- Check if RealisticPoliceTab contains more criminal record than the max
    if #RealisticPoliceTab >= Realistic_Police.MaxCriminalRecord then 
        table.remove(RealisticPoliceTab, 1)
    end 

    RealisticPoliceTab[#RealisticPoliceTab + 1] = Table 
    file.Write("realistic_police/record/"..ply:SteamID64()..".txt", util.TableToJSON(RealisticPoliceTab, true))
end 

function Realistic_Police.SaveLoadInfo(ply, bool, info)
    if bool then 
        -- Save the weapon of the player 
        local WeaponSave = {}
        for k,v in pairs(ply:GetWeapons()) do 
            WeaponSave[v:GetClass()] = {
                ["Clip1"] = v:Clip1(),
                ["Clip2"] = v:Clip2(),
            }
        end 
        
        -- Save some information of the player ( Weapon , Health & Armor ) 
        ply.RPTInfo = {
            RArmor = ply:Armor(), 
            RWeapon = WeaponSave,
            Ammo = ply:GetAmmo(), 
            RModel = info and ply:GetModel() or nil, 
            RHealth = info and ply:Health() or nil,
            RPos = info and ply:GetPos() or nil, 
            RDarkrpVar = info and table.Copy(ply.DarkRPVars) or nil, 
        }
    else 
        -- SetPos the player 
        if isvector(ply.RPTInfo["RPos"]) then 
            ply:SetPos(ply.RPTInfo["RPos"])
        end 

        -- Give back the health of the player 
        ply:SetHealth((ply.RPTInfo["RHealth"] or 100))

        -- Give back the armor of the player 
        ply:SetArmor((ply.RPTInfo["RArmor"] or 0))
        
        -- Set the model of the player    
        if isstring(ply.RPTInfo["RModel"]) then 
            ply:SetModel(ply.RPTInfo["RModel"])
        end 
         
        if istable(ply.RPTInfo["RDarkrpVar"]) then 
            for k,v in pairs(ply.RPTInfo["RDarkrpVar"]) do 
                ply:setDarkRPVar(k, v)
            end      
        end 
        
        -- Give back his weapons 
        ply:StripWeapons()
        for k,v in pairs(ply.RPTInfo["RWeapon"]) do 
            local wep = ply:Give(k, true)
            wep:SetClip1(v["Clip1"])
            wep:SetClip2(v["Clip2"])
        end 

        for k,v in pairs(ply.RPTInfo["Ammo"]) do 
            ply:SetAmmo(v,k)
        end
        
        ply.RPTInfo = nil 
    end 
end 

function Realistic_Police.Tazz(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    if timer.Exists("rpt_stungun_unfreeze"..ply:EntIndex()) then return end 

    -- Save info of the player 
    Realistic_Police.SaveLoadInfo(ply, true, true)

    -- Create the Ragdoll Player 
    ply:CreateRagdoll()
    timer.Simple(0, function()
        ply:Spectate( OBS_MODE_CHASE )
        ply:SpectateEntity( ply:GetRagdollEntity() )
        ply:StripWeapons()
        ply:StripAmmo()
    end ) 

    if IsValid(ply.WeaponRPT["DragedBy"]) then 
        ply.WeaponRPT["DragedBy"] = nil 
    end 
    ply.WeaponRPT["Cuff"] = true 
    
    -- Send the animation of the corpse 
    timer.Create("rpt_stungun_send"..ply:EntIndex(), 1, 1, function()
        if IsValid(ply) then 
            net.Start("RealisticPolice:StunGun")
                net.WriteEntity(ply)
            net.Broadcast()
        end 
    end ) 

    -- Timer when the player is not stun 
    timer.Create("rpt_stungun"..ply:EntIndex(), 5, 1, function()
        if IsValid(ply) then 

            -- Unspectacte and Freeze player 
            ply.WeaponRPT["Cuff"] = false 
            ply:UnSpectate()
            ply:Spawn()

            if IsValid(ply:GetRagdollEntity()) then 
                ply:GetRagdollEntity():Remove()
            end 

            Realistic_Police.SaveLoadInfo(ply)
            
            ply:Freeze(true)

            timer.Simple(1, function()
                ply.RPTStunTable = {}
            end ) 

            timer.Create("rpt_stungun_unfreeze"..ply:EntIndex(), 7, 1, function()
                if IsValid(ply) then  
                    ply:Freeze(false)
                end 
            end )
        end 
    end ) 
end 

function Realistic_Police.Cuff(ply, officer)
    if not IsValid(ply) or not IsValid(officer) then return end 
    if ply:GetPos():DistToSqr(officer:GetPos()) > 15625 then return end  

    if timer.Exists("rpt_timerarrest"..ply:EntIndex()) then
        timer.Remove("rpt_timerarrest"..ply:EntIndex())
    end 

    -- Check if the Police Man Can Cuff the player
    if not Realistic_Police.CanCuff[team.GetName(officer:Team())] then 
        Realistic_Police.SendNotify(officer, Realistic_Police.Lang[61][Realistic_Police.Langage]) 
        return 
    end 
    
    -- Check if the player can be cuff or not 
    if Realistic_Police.CantBeCuff[team.GetName(ply:Team())] then 
        Realistic_Police.SendNotify(officer, Realistic_Police.Lang[62][Realistic_Police.Langage]) 
        return
    end 
    
    if ply.WeaponRPT["Surrender"] then 
        Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneSurrender, ply)
    end 
    
    RPTWepTable = {}
    if not istable(ply.WeaponRPT["Weapon"]) or #ply.WeaponRPT["Weapon"] == 0 then 
        for k,v in pairs(ply:GetWeapons()) do 
            table.insert(RPTWepTable, {
                ModelW = v:GetModel(),
                ClassW = v:GetClass(), 
                Clip1W = v:Clip1(), 
            })
        end 
    else 
        RPTWepTable = ply.WeaponRPT["Weapon"] 
    end 
    
    ply.WeaponRPT = {
        Weapon = RPTWepTable, 
        Cuff = true, 
        EnterExit = true, 
    }
    
    ply:StripWeapons()
    -- Cuff the Player 
    ply:Give("weapon_rpt_cuffed")
    
    ply:Freeze(false)
    officer:Freeze(false)

    hook.Call("RealisticPolice:Cuffed", GAMEMODE, ply, officer )
end 

function Realistic_Police.UnCuff(ply, officer)
    if not IsValid(ply) or not IsValid(officer) then return end 
    if ply:GetPos():DistToSqr(officer:GetPos()) > 15625 then return end  

    if ply.WeaponRPT["Cuff"] then 
        
        if timer.Exists("rpt_timerarrest"..ply:EntIndex()) then
            timer.Remove("rpt_timerarrest"..ply:EntIndex())
        end 
        -- UnCuff the Player ( For give weapons )
        ply.WeaponRPT["Cuff"] = false 

        -- Give back his weapons 
        if istable(ply.WeaponRPT["Weapon"]) then 
            for k,v in pairs(ply.WeaponRPT["Weapon"]) do 
                if isstring(v["ClassW"]) then 
                    ply:Give(v["ClassW"])
                    ply:GetWeapon(v["ClassW"]):SetClip1(v.Clip1W)
                end 
            end 
        end 

        -- Reset the Player Table
        ply.WeaponRPT = {} 

        Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, ply)
        
        ply:Freeze(false)
        officer:Freeze(false)

        hook.Call("RealisticPolice:UnCuffed", GAMEMODE, ply, officer )
    end 
end 

-- Check if there's a jail position. 
function Realistic_Police.CheckJailPos()
    local directory = file.Read("realistic_police/" .. game.GetMap() .. "_rpt_jailpos" .. ".txt", "DATA") or ""
    local RptTable = util.JSONToTable(directory) or {}

    if #RptTable > 0 then 
        return true 
    end 
end 

-- Find an empty jail place
function Realistic_Police.GetPlaceArrest()
    local directory = file.Read("realistic_police/" .. game.GetMap() .. "_rpt_jailpos" .. ".txt", "DATA") or ""
    local RptTable = util.JSONToTable(directory) or {}

    local RPTid = 1 
    for k,v in pairs(ents.FindInSphere(RptTable[RPTid]["Pos"], 50)) do 
        if v:IsPlayer() then 
            RPTid = RPTid + 1 
        end 
    end 
    return RptTable[RPTid]["Pos"]
end 
 
-- Arrest the player if he is cuffed 
function Realistic_Police.ArresPlayer(ply, Time) 
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    if timer.Exists("rpt_timerarrest"..ply:EntIndex()) then
        timer.Remove("rpt_timerarrest"..ply:EntIndex())
    end 

    if ply.WeaponRPT["Cuff"] then 
        ply:SetPos(Realistic_Police.GetPlaceArrest())
        ply.WeaponRPT["DragedBy"] = nil
        
        ply:SetNWInt("rpt_arrest_time", CurTime() + Time)

        hook.Call("RealisticPolice:Jailed", GAMEMODE, ply, Time )
        -- Create the Jail Timer 
        timer.Create("rpt_timerarrest"..ply:EntIndex(), Time, 1, function()
            if IsValid(ply) then 
                ply:StripWeapons()
                Realistic_Police.UnArrest(ply)
            end 
        end ) 
    end 
end 

function Realistic_Police.UnArrest(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    -- Check if the timer Exist 
    if timer.Exists("rpt_timerarrest"..ply:EntIndex()) then
        -- Reset Variables / Bone / Speed of the player 
        Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, ply)

        -- UnCuff the Player ( For give weapons )
        ply.WeaponRPT["Cuff"] = false   
        ply:Spawn()

        -- Give back his weapons 
        if istable(ply.WeaponRPT["Weapon"]) then 
            for k,v in pairs(ply.WeaponRPT["Weapon"]) do 
                if isstring(v["ClassW"]) then 
                    ply:Give(v["ClassW"])
                    ply:GetWeapon(v["ClassW"]):SetClip1(v.Clip1W)
                end 
            end 
        end 
        
        hook.Call("RealisticPolice:UnJailed", GAMEMODE, ply )

        ply.WeaponRPT = {}
        -- Remove the arrest timer 
        timer.Remove("rpt_timerarrest"..ply:EntIndex())
    end 
end 

function Realistic_Police.Drag(ply, officer)
    if not IsValid(ply) or not IsValid(officer) then return end 
    if ply:GetPos():DistToSqr(officer:GetPos()) > 15625 then return end  

    if ply.WeaponRPT["Cuff"] then 
        if not IsValid(ply.WeaponRPT["DragedBy"]) && not IsValid(officer.WeaponRPT["Drag"]) then 
            ply.WeaponRPT["DragedBy"] = officer
            officer.WeaponRPT["Drag"] = ply
        else 
            ply.WeaponRPT["DragedBy"] = nil
            officer.WeaponRPT["Drag"] = nil
        end 
    end 
end 

function Realistic_Police.PlaceVehicle(officer, vehc)
	local RPTPlace = nil 
	local DistancePlace = 1000 
	-- Get the Place with vcmod 
	if istable(vehc:VC_getSeatsAvailable()) then 
		for k,v in ipairs(table.Reverse(vehc:VC_getSeatsAvailable())) do 
			if v:GetPos():DistToSqr(officer:GetPos()) < DistancePlace ^ 2 then 
                if IsValid(v:GetDriver()) then continue end 
				RPTPlace = v 
                break 
			end 
		end 
	end 
	return RPTPlace 
end 

function Realistic_Police.GetPoliceProps(ply)
    local Count = 0 
    for k,v in pairs(ents.FindByClass("prop_physics")) do 
        if v:CPPIGetOwner() == ply then 
            if istable(Realistic_Police.Trunk[v:GetModel()]) then 
                Count = Count + 1 
            end 
        end 
    end 
    return Count 
end 

function Realistic_Police.CountRepairMan()
	local Count = 0 
	for k,v in pairs(player.GetAll()) do 
		if Realistic_Police.CameraWorker[team.GetName(v:Team())] then 
			Count = Count + 1 
		end 
	end 
	return Count 
end 

function Realistic_Police.BrokeCamera(ent)
    ent:ResetSequence("desactiv")
    ent:SetSequence("desactiv")
    ent:SetRptCam(true)
    ent.DestroyCam = true 
    ent:SetRptRotate("nil")  

    -- Restore the health and the animation of the camera 
    timer.Create("camera_respawn"..ent:EntIndex(), Realistic_Police.CameraRestart, 0, function()
        if IsValid(ent) then 
            if ent:GetRptCam() then 
                if Realistic_Police.CountRepairMan() == 0 then 
                    ent:ResetSequence("active")
                    ent:SetSequence("active")
                    ent:SetRptCam(false)
                    ent.HealthEntity = Realistic_Police.CameraHealth 
                    ent.DestroyCam = false 
                    timer.Remove("camera_respawn"..ent:EntIndex())
                end  
            else 
                timer.Remove("camera_respawn"..ent:EntIndex()) 
            end 
        end
    end) 
end 