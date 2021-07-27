--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

Realistic_Police = Realistic_Police or {}

-- Initialize Folder ( Criminal Record / Report )
hook.Add("Initialize", "RPT:InitializeServer", function()
    if not file.Exists("realistic_police", "DATA") then
        file.CreateDir("realistic_police")
    end
    if not file.Exists("realistic_police/report", "DATA") then
        file.CreateDir("realistic_police/report")
    end
    if not file.Exists("realistic_police/record", "DATA") then
        file.CreateDir("realistic_police/record")
    end

    -- Create a loop for broke sometime a camera 
    timer.Create("rpt_loop_camera", 400, 0, function()
    
        -- Check if count of camera Repairer is > 0 
        if Realistic_Police.CameraBroke then 
            local RandomId = math.random(1, #ents.FindByClass("realistic_police_camera"))
            if math.random(1, 2) == 1 then 
                for k,v in pairs(ents.FindByClass("realistic_police_camera")) do 
                    if k == RandomId && not IsValid(v:CPPIGetOwner()) then 
                       Realistic_Police.BrokeCamera(v)
                    end 
                end 
            end   
        end 
    end )
end )

hook.Add("onLockpickCompleted", "RPT:onLockpickCompleted", function(Player, Success, CuffedP)
    if IsValid(CuffedP) && CuffedP:IsPlayer() then 
        if istable(CuffedP.WeaponRPT) then 
            if CuffedP.WeaponRPT["Cuff"] then
                if Success then 
                    Realistic_Police.UnCuff(CuffedP, Player)
                end 
            end 
        end 
    end 
end)

hook.Add( "PlayerUse", "RPT:PlayerUse", function( ply, ent )
    if IsValid(ply) && ply:IsPlayer() then 
        if istable(ply.WeaponRPT) then 
            if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then
                return false
            end
        end 
    end 
end )

hook.Add("canLockpick", "RPT:canLockpick", function(Player, CuffedP, Trace)
    if IsValid(CuffedP) && CuffedP:IsPlayer() then 
        if istable(CuffedP.WeaponRPT) then 
            if CuffedP.WeaponRPT["Cuff"] then
                return true
            end
        end 
    end 
end)

hook.Add("lockpickTime", "RPT:lockpickTime", function(Player, Entity)
    if IsValid(Entity) && Entity:IsPlayer() then 
        if istable(Entity.WeaponRPT) then 
            if Entity.WeaponRPT["Cuff"] then
                return 10
            end
        end 
    end 
end)

hook.Add("canArrest", "RPT:canArrest", function(Player, ArrestedPlayer)
    if istable(ArrestedPlayer.WeaponRPT) then 
        if ArrestedPlayer.WeaponRPT["Cuff"] then
            Realistic_Police.UnCuff(ArrestedPlayer, Player)
        end 
    end 
end)

hook.Add("canUnarrest", "RPT:canUnarrest", function(Player, ArrestedPlayer)
    if istable(ArrestedPlayer.WeaponRPT) then 
        if ArrestedPlayer.WeaponRPT["Cuff"] then
            Realistic_Police.UnCuff(ArrestedPlayer, Player)
        end 
    end 
end)

-- All hook which are desactivate when the player is Cuffed or Surrender 
hook.Add("PlayerSwitchWeapon", "RPT:PlayerSwitchWeapon", function(ply, wp, wep)
    if timer.Exists("rpt_animation"..ply:EntIndex()) then 
        return true 
    end 
    if wep:GetClass() != "weapon_rpt_surrender" && wep:GetClass() != "weapon_rpt_cuffed" then 
        if istable(ply.WeaponRPT) then 
	        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return true end
        end 
    end 
end)

hook.Add("PlayerSpawnProp", "RPT:PlayerSpawnProp", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end ) 

hook.Add("CanPlayerSuicide","RPT:CanPlayerSuicide",function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end ) 

hook.Add("PlayerCanPickupWeapon", "RPT:PlayerCanPickupWeapon", function(ply, wep)
    if istable(ply.WeaponRPT) then 
        if wep:GetClass() != "weapon_rpt_surrender" && wep:GetClass() != "weapon_rpt_cuffed" then 
            if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
        end 
    end 
end)

hook.Add("canDropWeapon", "RPT:canDropWeapon", function(ply)
    if istable(ply.WeaponRPT) then 
	    if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end)

hook.Add("playerCanChangeTeam", "RPT:playerCanChangeTeam", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end 
    end 
end)

hook.Add("canBuyVehicle", "RPT:canBuyVehicle", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end 
    end 
end )

hook.Add("canBuyShipment", "RPT:canBuyShipment", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end)

hook.Add("canBuyPistol", "RPT:canBuyPistol", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end)

hook.Add("canBuyAmmo", "RPT:canBuyAmmo", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end)

hook.Add("canBuyCustomEntity", "RPT:canBuyCustomEntity", function(ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end
    end 
end)

hook.Add("VC_canSwitchSeat", "RPT:VC_canSwitchSeat", function(ply, ent_from, ent_to)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end 
    end 
end)

hook.Add("CanExitVehicle", "RPT:CanExitVehicle", function(vehc, ply)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["EnterExit"] then 
            if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then return false end 
        end 
    end 
end )
--------------------------------------------------------------------------------------

hook.Add("PlayerInitialSpawn", "RPT:PlayerInitialSpawn", function(ply)
    timer.Simple(8, function()
        if not IsValid(ply) or not ply:IsPlayer() then return end 

        ply.WeaponRPT = {}
        -- Generate a plate if the player doesn't have it 
        Realistic_Police.GeneratePlate(ply)

        -- Send the Table of Custom Vehicles ( Configurate by the owner of the server with the tool )
        local RealisticPoliceFil = file.Read("realistic_police/vehicles.txt", "DATA") or ""
        local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}
        local CompressTable = util.Compress(RealisticPoliceFil)

        net.Start("RealisticPolice:SendInformation")
            net.WriteInt( CompressTable:len(), 32)
            net.WriteData( CompressTable, CompressTable:len() )
        net.Send(ply)
    end ) 
end ) 

hook.Add("OnEntityCreated", "RPT:OnEntityCreated", function(ent)
    -- Set information of the plate on the vehicle 
    timer.Simple(1, function()
        if IsValid(ent) then 
            Realistic_Police.SetInfoVehc(ent)
        end 
    end ) 
end ) 

-- Check if the Vehicle have a fine and the player can enter into the vehicle
hook.Add("CanPlayerEnterVehicle", "RPT:PlayerEnteredVehicle", function(ply, vehc)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["EnterExit"] or ply.WeaponRPT["Surrender"] then return false end 
        if istable(vehc.WeaponRPT) then 
            if istable(vehc.WeaponRPT["TableFine"]) && not ply.WeaponRPT["EnterVehc"] then 
                net.Start("RealisticPolice:FiningSystem")
                    net.WriteTable(vehc.WeaponRPT["TableFine"])
                net.Send(ply)
                ply.WeaponRPT["Fine"] = vehc
                return false 
            end 
        end 
    end 
end ) 

-- Set the plate on the vehicle when the player buy the vehicle 
hook.Add("PlayerBuyVehicle", "RPT:PlayerBuyVehicle", function(ent)
    timer.Simple(1, function()
        if IsValid(ent) then 
            Realistic_Police.SetInfoVehc(ent)
        end 
    end ) 
end ) 

-- Add to the PVS Police Camera 
hook.Add("SetupPlayerVisibility", "RPT:SetupPlayerVisibility", function(ply) 
    if ply.RPTShowEntity != nil && IsValid(ply.RPTShowEntity) then 
        AddOriginToPVS(ply.RPTShowEntity:GetPos())
    end 
end )

hook.Add( "PlayerButtonDown", "RPT:PlayerButtonDownS", function( ply, button )
    -- Open the Tablet on the vehicle 
    if button == Realistic_Police.KeyOpenTablet then    
        if ply:InVehicle() then 
            if IsValid(ply:GetVehicle()) then 
                if Realistic_Police.PoliceVehicle[ply:GetVehicle():GetVehicleClass()] then 
                    if isbool(Realistic_Police.PoliceVehicle[ply:GetVehicle():GetVehicleClass()]) then 
                        net.Start("RealisticPolice:Open")
                            net.WriteString("OpenMainMenu")
                            net.WriteEntity(ply:GetVehicle())
                            net.WriteBool(true)
                        net.Send(ply)
                    end
                end 
            end
            if IsValid(ply:GetVehicle():GetParent()) then 
                if Realistic_Police.PoliceVehicle[ply:GetVehicle():GetParent():GetVehicleClass()] then 
                    if isbool(Realistic_Police.PoliceVehicle[ply:GetVehicle():GetParent():GetVehicleClass()]) then 
                        net.Start("RealisticPolice:Open")
                            net.WriteString("OpenMainMenu")
                            net.WriteEntity(ply:GetVehicle():GetParent())
                            net.WriteBool(true)
                        net.Send(ply)
                    end
                end 
            end
        end 
    end

    if Realistic_Police.SurrenderActivate then 
        if istable(ply.WeaponRPT) then 
            -- Check if the player is not cuffed for surrender
            if not ply.WeaponRPT["Cuff"] then 

                if button == Realistic_Police.SurrenderKey then 
                    if ply:InVehicle() then return end 
                    if not ply.WeaponRPT["Surrender"] then 
                        timer.Create("rpt_surrender"..ply:EntIndex(), 0.5, 1, function()
                            if IsValid(ply) then 
                                -- Save weapons of the player 
                                Realistic_Police.SaveLoadInfo(ply, true, false)

                                ply:StripWeapons()
                                ply:Give("weapon_rpt_surrender") 

                                ply.WeaponRPT["Surrender"] = true 
                            end 
                        end ) 
                    else 
                        ply:StripWeapon("weapon_rpt_surrender")
                        ply.WeaponRPT["Surrender"] = false 
                        
                        -- Give back his weapons 
                        ply:StripWeapons()
                        Realistic_Police.SaveLoadInfo(ply)
                        Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneSurrender, ply)    
                    end        
                end 
            end 
        end 
    end 
end)

hook.Add( "PlayerButtonUp", "RPT:PlayerButtonUpS", function( ply, button )
    if istable(ply.WeaponRPT) then 
        if not ply.WeaponRPT["Cuff"] then 
            if button == Realistic_Police.SurrenderKey then 
                -- If timer of surrending exist then remove when the player up the button 
                if timer.Exists("rpt_surrender"..ply:EntIndex()) then 
                    timer.Remove("rpt_surrender"..ply:EntIndex())
                end
            end 
        end 
    end 
end)

local CMoveData = FindMetaTable("CMoveData")
function CMoveData:RemoveKeys(ADLKey)
	local ADLButtons = bit.band(self:GetButtons(), bit.bnot(ADLKey))
	self:SetButtons(ADLButtons)
end

hook.Add("SetupMove", "RPT:Move", function(ply, data)
    if istable(ply.WeaponRPT) then 
        if ply.WeaponRPT["Cuff"] or ply.WeaponRPT["Surrender"] then 
            data:SetMaxClientSpeed( 80 )
            if data:KeyDown(IN_JUMP) then
                data:RemoveKeys(IN_JUMP)
            end
        end 
        -- this hook is the hook for drag the player 
        if IsValid(ply.WeaponRPT["DragedBy"]) then 
            if ply:GetPos():DistToSqr(ply.WeaponRPT["DragedBy"]:GetPos()) < 40000 then 
                if IsValid(ply.WeaponRPT["DragedBy"]) then 
                    local VectorDrag = ply.WeaponRPT["DragedBy"]:GetPos() - ply:GetPos()
                    data:SetVelocity(Vector(VectorDrag.x*4, VectorDrag.y*4, -100))
                end 
            else 
                ply.WeaponRPT["DragedBy"] = nil 
            end 
        end
    else 
        ply.WeaponRPT = {}
    end  
end )

hook.Add("playerBoughtCustomEntity", "RPT:BoughtEntity", function(ply, enttbl, ent, price)
    -- Set the owner of the Camera and the Screen 
    if ent:GetClass() == "realistic_police_camera" or ent:GetClass() == "realistic_police_screen" then 
        ent:CPPISetOwner(ply)
    end 
end )

-- Give ammo 
hook.Add("WeaponEquip", "RPT:WeaponEquip", function(weapon, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end  
    
    if weapon:GetClass() == "weapon_rpt_stungun" then 
        ply:GiveAmmo((Realistic_Police.StungunAmmo or 40), "Pistol", false) 
    end 
end )

-- When the Police Man disconnect unfreez the player 
hook.Add("PlayerDisconnected", "RPT:PlayerDisconnected", function(ply)
    if IsValid(ply) then 
        if istable(ply.WeaponRPT) then 
            if IsValid(ply.WeaponRPT["Fine"]) && ply.WeaponRPT["Fine"]:IsPlayer() then 
                ply.WeaponRPT["Fine"]:Freeze(false)
            end 
        end 
    end 
end )

hook.Add("PlayerDeath", "RPT:PlayerDeath", function(ply)

    if timer.Exists("rpt_stungun"..ply:EntIndex()) then 
        timer.Remove("rpt_stungun"..ply:EntIndex())
    end 

    if timer.Exists("rpt_timerarrest"..ply:EntIndex()) then
        timer.Remove("rpt_timerarrest"..ply:EntIndex())
    end 

    ply.WeaponRPT = {}
    -- Reset Bone position
    Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, ply)
    Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneSurrender, ply)    

    for k,v in pairs(ents.GetAll()) do 
        if v:GetClass() == "realistic_police_camera" or v:GetClass() == "realistic_police_screen" then 
            if v:CPPIGetOwner() == ply then 
                v:Remove()
            end     
        end 
    end 
end )

hook.Add("OnPlayerChangeTeam", "RPT:OnPlayerChangeTeam", function(ply)

    if timer.Exists("rpt_stungun"..ply:EntIndex()) then 
        timer.Remove("rpt_stungun"..ply:EntIndex())
    end 

    ply.WeaponRPT = {}
    -- Reset Bone position
    Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, ply)
    Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneSurrender, ply)    

    for k,v in pairs(ents.GetAll()) do 
        if v:GetClass() == "realistic_police_camera" or v:GetClass() == "realistic_police_screen" then 
            if v:CPPIGetOwner() == ply then 
                v:Remove()
            end     
        end 
    end 
end )
