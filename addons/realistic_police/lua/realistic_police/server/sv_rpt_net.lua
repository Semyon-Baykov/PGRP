--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]
Realistic_Police = Realistic_Police or {}

util.AddNetworkString("RealisticPolice:Open")
util.AddNetworkString("RealisticPolice:Report")
util.AddNetworkString("RealisticPolice:CriminalRecord")
util.AddNetworkString("RealisticPolice:SecurityCamera")
util.AddNetworkString("RealisticPolice:NameCamera")
util.AddNetworkString("RealisticPolice:FiningSystem")
util.AddNetworkString("RealisticPolice:HandCuff")
util.AddNetworkString("RealisticPolice:StunGun")
util.AddNetworkString("RealisticPolice:SetupVehicle")
util.AddNetworkString("RealisticPolice:SendInformation")
util.AddNetworkString("RealisticPolice:UpdateInformation")
util.AddNetworkString("RealisticPolice:PlaceProp")

-- Check if the player is near a computer / jailer or a police vehicle 
local function CheckEnts(Player)
    for k,v in pairs(ents.FindInSphere(Player:GetPos(), 600)) do 
        if IsValid(v) then 
            if v:GetClass() == "realistic_police_computer" or v:GetClass() == "realistic_police_jailer" then 
                return true 
            end 
        end 
        if IsValid(v) && v:IsVehicle() then
            if Realistic_Police.PoliceVehicle[v:GetVehicleClass()] then 
                return true 
            end 
        end 
        if IsValid(v:GetParent()) && v:GetParent():IsVehicle() then 
            if Realistic_Police.PoliceVehicle[v:GetParent():GetVehicleClass()] then 
                return true 
            end 
        end  
    end 
    return false 
end 

-- Net For the setup a license plate on a vehicle 
net.Receive("RealisticPolice:SetupVehicle", function(len,ply)

    -- Check if the Player is valid and have the correct rank for setup the vehicle 
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    if not Realistic_Police.AdminRank[ply:GetUserGroup()] then return end

    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 0.1 

    -- This table contains the position , size , rotation of the plate
    local Table = net.ReadTable() or {}
    if not istable(Table) then return end 

    -- This entity is the vehicle to configure 
    local EntityDelete = net.ReadEntity()
    if not IsValid(EntityDelete) then return end 

    local RealisticPoliceFil = file.Read("realistic_police/vehicles.txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}

    -- Remove before position of the vehicle in the data 
    RealisticPoliceTab[EntityDelete:GetModel()] = nil 
    table.Merge(RealisticPoliceTab, Table)

    file.Write("realistic_police/vehicles.txt", util.TableToJSON(RealisticPoliceTab))
    
    -- Here we send the table to the client for have the license plate information 
    timer.Simple(0.1, function()
        
        -- Compress the table for send information 
        local RealisticPoliceFil = file.Read("realistic_police/vehicles.txt", "DATA") or ""
        local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}
        local CompressTable = util.Compress(RealisticPoliceFil)
        net.Start("RealisticPolice:SendInformation")
            net.WriteInt(CompressTable:len(), 32)
            net.WriteData(CompressTable, CompressTable:len() )
        net.Broadcast()
        
        -- Delete the vehicle preview 
        if IsValid(EntityDelete) then 
            EntityDelete:Remove()
        end 
    end ) 

end ) 

net.Receive("RealisticPolice:Report", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    
    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 0.1

    -- RPTInt = Int for delete / Edit 
    local RPTInt = net.ReadUInt(10)

    -- RPTString = Information of the action 
    local RPTString = net.ReadString()
    if string.len(RPTString) > 30 then return end 

    -- RPTSteamID64 = Steamid64 of the player
    local RPTEntity = net.ReadEntity()

    -- RPTText = Text of the Report 
    local RPTText = net.ReadString()
    if string.len(RPTText) > 1184 then return end 
    
    local RPTSteamID64 = ""

    -- Check if it's a unknow report or a player report 
    local RPTName = ""
    if IsValid(RPTEntity) && RPTEntity:IsPlayer() then 
        RPTSteamID64 = RPTEntity:SteamID64()
        RPTName = RPTEntity:Name() 
    else 
        RPTSteamID64 = "unknown"
        RPTName = Realistic_Police.Lang[12][Realistic_Police.Langage]
    end 

    local RealisticPoliceFil = file.Read("realistic_police/report/"..RPTSteamID64..".txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}

    -- Create the table of the report for save it after 
    local TableReport = {
        RPTText = RPTText, 
        RPTDate = os.date("%d/%m/%Y", os.time()), 
        RPTPolice = ply:Name(), 
        RPTCriminal = RPTName, 
        RPTSteamID64 = RPTSteamID64, 
    }

    -- Check if the player is near a Computer or a vehicle for add the report 
    if not CheckEnts(ply) then return end 
    
    -- Save the report into the data 
    if RPTString == "SaveReport" then 

        -- Check if the player have the job for add a report 
        if Realistic_Police.JobEditReport[team.GetName(ply:Team())] then 

            -- Check if the Player is not the PoliceMan 
            if ply == RPTEntity then return end 

            -- Check if RealisticPoliceTab contains more report than the max report
            if #RealisticPoliceTab >= Realistic_Police.MaxReport then 
                table.remove(RealisticPoliceTab, 1) 
            end 

            -- If the RPTSteamID64 is unknow then I set the model to "" 
            if RPTSteamID64 != "unknown" then 
                TableReport["Model"] = RPTEntity:GetModel()
            else
                TableReport["Model"] = ""
            end 

            RealisticPoliceTab[#RealisticPoliceTab + 1] = TableReport
            file.Write("realistic_police/report/"..RPTSteamID64..".txt", util.TableToJSON(RealisticPoliceTab, true))

            -- Send The table of the player to the client
            Realistic_Police.SendReport(RPTSteamID64, ply)
        end 

    elseif RPTString == "SendInformation" then

        Realistic_Police.SendReport(RPTSteamID64, ply)

    elseif RPTString == "EditReport" then 

        -- Check if the player can edit the report 
        if Realistic_Police.JobEditReport[team.GetName(ply:Team())] then 
            
             -- Check if the Player is not the PoliceMan 
            if ply == RPTEntity then return end  

            RealisticPoliceTab[RPTInt]["RPTText"] = TableReport["RPTText"]
            file.Write("realistic_police/report/"..RPTSteamID64..".txt", util.TableToJSON(RealisticPoliceTab, true))
            
            Realistic_Police.SendReport(RPTSteamID64, ply)
        end 

    elseif RPTString == "RemoveReport" then

        -- Check if the player can remove the report 
        if Realistic_Police.JobDeleteReport[team.GetName(ply:Team())] then  
            
            -- Check if the Player is not the PoliceMan 
            if ply == RPTEntity then return end 
            
            table.remove(RealisticPoliceTab, RPTInt) 
            file.Write("realistic_police/report/".."unknown"..".txt", util.TableToJSON(RealisticPoliceTab, true))

            Realistic_Police.SendReport(RPTSteamID64, ply)
        end 

    end 
end ) 

net.Receive("RealisticPolice:CriminalRecord", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 0.1

    -- RPTInt = Int for delete a criminal record
    local RPTInt = net.ReadUInt(10)

    -- RPTString = Information of the action 
    local RPTString = net.ReadString()
    if string.len(RPTString) > 50 then return end 

    local RPTEntity = net.ReadEntity()
    if not IsValid(RPTEntity) then return end 

    -- RPTText = Text of the criminal record 
    local RPTText = net.ReadString()
    if string.len(RPTText) > 1050 then return end 
    
    -- Create the table of the criminal record for save it after 
    local Table = {
        Date = os.date("%d/%m/%Y", os.time()),
        Motif = RPTText, 
    }

    -- Check if the Policeman is near a Jail , A computer or a Vehicle for add a criminal record 
    if not IsValid(RPTEntity) or not CheckEnts(ply) then return end 

    local RealisticPoliceFil = file.Read("realistic_police/record/"..RPTEntity:SteamID64()..".txt", "DATA") or ""
    local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}

    if RPTString == "AddRecord" then 

        if Realistic_Police.JobEditRecord[team.GetName(ply:Team())] then 
            
            -- Check if the Player is not the PoliceMan 
            if ply == RPTEntity then return end 

            -- Add a criminal Record 
            Realistic_Police.AddCriminalRecord(RPTEntity, Table)
            
            -- Send The table of the player to the client 
            Realistic_Police.SendRecord(RPTEntity:SteamID64(), ply)
        end 

    elseif RPTString == "SendRecord" then 

        Realistic_Police.SendRecord(RPTEntity:SteamID64(), ply)

    elseif RPTString == "RemoveRecord" then 
        
        if Realistic_Police.JobDeleteRecord[team.GetName(ply:Team())] then 

            -- Check if the Player is not the PoliceMan 
            if ply == RPTEntity then return end 

            RealisticPoliceTab[RPTInt] = nil 
            file.Write("realistic_police/record/"..RPTEntity:SteamID64()..".txt", util.TableToJSON(RealisticPoliceTab, true))

            Realistic_Police.SendRecord(RPTEntity:SteamID64(), ply)
        end 

    end 
end ) 

net.Receive("RealisticPolice:SecurityCamera", function(len, ply) -- Send Police Camera 
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 0.1

    -- RPTString = Information of the action 
    local RPTString = net.ReadString() 
    if string.len(RPTString) > 60 then return end 

    -- RPTEnt = This entity is the camera which the player want to rotate 
    local RPTEnt = net.ReadEntity() 

    -- RPTStringRotate = Rotate on the left or on the Right 
    local RPTStringRotate = net.ReadString()
    if string.len(RPTStringRotate) > 30 then return end 

    -- Check if the player is near a Computer or a vehicle 
    if not CheckEnts(ply) then return end 

    if RPTString == "RotateCamera" then 

        if not isentity(RPTEnt) or RPTEnt:GetClass() != "realistic_police_camera" then return end 
        RPTEnt:SetRptRotate(RPTStringRotate)

    elseif RPTString == "ShowCamera" then 

        ply.RPTShowEntity = RPTEnt

    elseif RPTString == "DontShowCamera" then 

        ply.RPTShowEntity = nil 

    elseif RPTString != "RotateCamera" && RPTString != "ShowCamera" then 

        -- Send all administrator camera to the client for the police 
        local TableToSend = {}
        for k,v in pairs(ents.FindByClass("realistic_police_camera")) do 
            if v.RPTCam then 
                table.insert(TableToSend, v)
            end 
        end 
        
        -- Send the table to the client 
        net.Start("RealisticPolice:SecurityCamera")
            net.WriteTable(TableToSend)
        net.Send(ply) 
    end 
end )

net.Receive("RealisticPolice:FiningSystem", function(len,ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    
    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 1

    -- RPTString = Information of the action 
    local RPTString = net.ReadString()
    
    -- RPTStringTbl = All infraction send on this string
    local RPTStringTbl = net.ReadString()
    if #RPTStringTbl > 1000 then return end 

    -- Convert the string to a table for use it 
    local FineTable = string.Explode("§", RPTStringTbl)
    table.remove(FineTable, 1)
    
    local rptEnt = nil 
    if IsValid(ply.WeaponRPT["Fine"]) then 
        rptEnt = ply.WeaponRPT["Fine"]
    end 
    if IsValid(rptEnt) then if not istable(rptEnt.WeaponRPT) then rptEnt.WeaponRPT = {} end end 

    if RPTString == "SendFine" then 

        -- Check if the Player have the correct job for add a fine 
        if Realistic_Police.JobCanAddFine[team.GetName(ply:Team())] then 
            if IsValid(rptEnt) then 
                
                -- Check if the Player or the Vehicle is near the PoliceMan 
                if rptEnt:GetPos():DistToSqr(ply:GetPos()) > 40000 then return end
                if #FineTable > Realistic_Police.MaxPenalty or #FineTable == 0 then return end 

                -- Check if the Ent is a vehicle and check if the vehicle is owned by the Policeman 
                if rptEnt:IsVehicle() then 
                    if rptEnt:CPPIGetOwner() == ply then Realistic_Police.SendNotify(ply, Realistic_Police.Lang[60][Realistic_Police.Langage]) return end 
                end 

                -- Check if the player have already a fine or not 
                if rptEnt:IsPlayer() then 
                    if isnumber(rptEnt.WeaponRPT["AmountFine"]) then
                        rptEnt:Freeze(false) 
                        Realistic_Police.SendNotify(ply, Realistic_Police.Lang[52][Realistic_Police.Langage])
                        return 
                    end 
                end 

                -- Check if the vehicle have already a fine or not 
                if istable(rptEnt.WeaponRPT["TableFine"]) then 
                    Realistic_Police.SendNotify(ply, Realistic_Police.Lang[53][Realistic_Police.Langage])
                    return 
                end 

                -- Calculate the amount of the fine 
                local Amount = 0 
                for k,v in pairs(Realistic_Police.FiningPolice) do 
                    if table.HasValue(FineTable, v.Name) then 
                        Amount = Amount + v.Price
                    end 
                end     

                if rptEnt:IsPlayer() then 

                    -- Check if the Player Can have a fine or not 
                    if not Realistic_Police.JobCantHaveFine[team.GetName(rptEnt:Team())] then 
                        rptEnt.WeaponRPT["AmountFine"] = Amount
                        rptEnt.WeaponRPT["PlayerFiner"] = ply
                        net.Start("RealisticPolice:FiningSystem")
                            net.WriteTable(FineTable)
                        net.Send(rptEnt) 

                        hook.Call("RealisticPolice:FinePlayer", GAMEMODE, ply, rptEnt )
                    else 
                        Realistic_Police.SendNotify(ply, Realistic_Police.Lang[56][Realistic_Police.Langage])
                    end 
                    rptEnt:Freeze(false)

                elseif rptEnt:IsVehicle() then 

                    -- Check if the vehicle can have a fine or not 
                    if not Realistic_Police.VehicleCantHaveFine[rptEnt:GetClass()] then 
                        rptEnt.WeaponRPT["AmountFine"] = Amount
                        rptEnt.WeaponRPT["TableFine"] = FineTable
                        rptEnt.WeaponRPT["PlayerFiner"] = ply

                        hook.Call("RealisticPolice:FineVehicle", GAMEMODE, ply, rptEnt )
                    else 
                        Realistic_Police.SendNotify(ply, Realistic_Police.Lang[54][Realistic_Police.Langage])
                    end 

                end 
            end 

            -- Play the sound/animation of the weapon 
            ply:GetActiveWeapon():EmitSound("rptfiningsound.mp3")
            ply:GetActiveWeapon():SendWeaponAnim( ACT_VM_PRIMARYATTACK )
            ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() + ply:GetActiveWeapon():SequenceDuration() )

            timer.Create("rpt_animation"..ply:EntIndex(), ply:GetActiveWeapon():SequenceDuration(), 1, function()	
                if IsValid(ply) && ply:IsPlayer() then 
                    ply:GetActiveWeapon():SendWeaponAnim( ACT_VM_IDLE )
                end 
            end)
            
            ply.WeaponRPT["Fine"] = nil
        else 
            -- Send the notification if the person can't add a fine 
            Realistic_Police.SendNotify(ply, Realistic_Police.Lang[55][Realistic_Police.Langage])
        end 

    elseif RPTString == "BuyFine" then 

        if ply:IsPlayer() && not IsValid(rptEnt) then 

            -- Check if is valid amount for the fine 
            if isnumber(ply.WeaponRPT["AmountFine"]) then 

                -- Check if the Player can buy the fine 
                if ply:canAfford(ply.WeaponRPT["AmountFine"]) then 
                    ply:addMoney(-ply.WeaponRPT["AmountFine"])
                else 
                    if Realistic_Police.PlayerWanted then 
                        ply:wanted(nil, Realistic_Police.Lang[51][Realistic_Police.Langage], 120)
                    end 
                end 

                -- Send Money & Notification to the Police Man and the person who receive the fine 
                if IsValid(ply.WeaponRPT["PlayerFiner"]) && ply.WeaponRPT["PlayerFiner"]:IsPlayer() then 
                    ply.WeaponRPT["PlayerFiner"]:addMoney((ply.WeaponRPT["AmountFine"]*Realistic_Police.PourcentPay)/100)
                    Realistic_Police.SendNotify(ply.WeaponRPT["PlayerFiner"], Realistic_Police.Lang[36][Realistic_Police.Langage].." "..DarkRP.formatMoney((ply.WeaponRPT["AmountFine"]*Realistic_Police.PourcentPay)/100))
                    Realistic_Police.SendNotify(ply, Realistic_Police.Lang[64][Realistic_Police.Langage].." "..DarkRP.formatMoney(ply.WeaponRPT["AmountFine"]))
                end 

                -- Reset Variables of the player 
                ply.WeaponRPT["TableFine"] = nil
                ply.WeaponRPT["PlayerFiner"] = nil 
                ply.WeaponRPT["AmountFine"] = nil 
                ply:Freeze(false)
            end 

        elseif rptEnt:IsVehicle() then 

            -- Check if is valid amount for the fine 
            if isnumber(rptEnt.WeaponRPT["AmountFine"]) then 

                -- Send Money & Notification to the Police Man and the person who receive the fine 
                if IsValid(rptEnt.WeaponRPT["PlayerFiner"]) && rptEnt.WeaponRPT["PlayerFiner"]:IsPlayer() then 
                    rptEnt.WeaponRPT["PlayerFiner"]:addMoney((rptEnt.WeaponRPT["AmountFine"]*Realistic_Police.PourcentPay)/100)
                    Realistic_Police.SendNotify(rptEnt.WeaponRPT["PlayerFiner"], Realistic_Police.Lang[36][Realistic_Police.Langage].." "..DarkRP.formatMoney((rptEnt.WeaponRPT["AmountFine"]*Realistic_Police.PourcentPay)/100))
                    Realistic_Police.SendNotify(ply, Realistic_Police.Lang[64][Realistic_Police.Langage].." "..DarkRP.formatMoney(rptEnt.WeaponRPT["AmountFine"]))
                end 

                -- Check if the Player can buy the fine & reset variables of the player
                if ply:canAfford(rptEnt.WeaponRPT["AmountFine"]) then 
                    ply:addMoney(-rptEnt.WeaponRPT["AmountFine"])
                    rptEnt.WeaponRPT["TableFine"] = nil
                    rptEnt.WeaponRPT["PlayerFiner"] = nil 
                    rptEnt.WeaponRPT["AmountFine"] = nil 
                end 
            end 
        end 
        
    elseif RPTString == "RefuseFine" then 

        ply:Freeze(false)
        if Realistic_Police.PlayerWanted then 
            -- Check if the Fine is on a vehicle or a Player ( If the fine is on a vehicle and the player don't pay the fine he's not gonna be wanted )
            if not istable(ply.WeaponRPT["TableFine"]) then 
                if IsValid(ply.WeaponRPT["PlayerFiner"]) then 
                    ply:wanted(ply.WeaponRPT["PlayerFiner"], Realistic_Police.Lang[51][Realistic_Police.Langage], 120)
                end 
            end 
        end 

        -- Reset Amount and unfreeze the player also add a wanted 
        ply.WeaponRPT["PlayerFiner"] = nil 
        ply.WeaponRPT["AmountFine"] = nil 
        ply.WeaponRPT["Fine"] = nil

    elseif RPTString == "StopFine" then 
        
        -- Stop the fine && reset variables 
        if IsValid(rptEnt) && rptEnt:IsPlayer() then 
            rptEnt:Freeze(false)
            ply.WeaponRPT["Fine"] = nil 
        end 

    end 
end )

net.Receive("RealisticPolice:HandCuff", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 0.1

    -- RPTString = Information of the action 
    local RPTString = net.ReadString()
	local ent = ply:getEyeSightHitEntity(nil, nil, function(p) return p ~= ply and p:IsPlayer() and p:Alive() and p:IsSolid() end)

    if RPTString == "ArrestPlayer" then  
		
        -- RPTInt = Jail Time 
        local RPTInt = net.ReadUInt(10)
        if RPTInt > Realistic_Police.MaxDay then 
			ent:UnLock()
			return 
		end 

        -- RPTText = Why the player is arrested 
        local RPTText = net.ReadString()
        if string.len(RPTText) > 1050 then 
			ent:UnLock()
			return 
		end  
        
        -- Check if the Police Man drag a player and if the player is cuffed 
        --if IsValid(ply.WeaponRPT["Drag"]) && ply.WeaponRPT["Drag"].WeaponRPT["Cuff"] then 
		if IsValid(ent) then

            -- Check if RPTTableBailer is not a table
            --if not istable(RPTTableBailer) then 
            --    RPTTableBailer = {}
            --end 

            -- Arrest the Player 
            ent:arrest(RPTInt, ply)--Realistic_Police.ArresPlayer(ent, RPTInt*Realistic_Police.DayEqual)
            Realistic_Police.SendNotify(ent, Realistic_Police.Lang[82][Realistic_Police.Langage].." "..ply:Name())
            Realistic_Police.SendNotify(ply, Realistic_Police.Lang[83][Realistic_Police.Langage].." "..ent:Name())
--[[
            -- Create The table to add on the Criminal Record
            local Table = {
                Date = os.date("%d/%m/%Y", os.time()),
                Motif = RPTText, 
            }

            -- Add autaumatically a penalty on the criminal record 
			
            Realistic_Police.AddCriminalRecord(ent, Table)

            -- Insert into the bailer table the player 
            table.insert(RPTTableBailer, {
                vEnt = ent, 
                vName = ent:Name(),
                vMotif = RPTText,
                vPrice = RPTInt*Realistic_Police.PriceDay,
                vModel = ent:GetModel(),
            })
            --ply.WeaponRPT["Drag"] = nil ]]--
            ent:UnLock()
			ent = nil
        end

    elseif RPTString == "Bailer" then 

        local PlayerArrested = net.ReadEntity()

        -- RPTInt = Int of the bailer menu 
        local RPTInt = net.ReadUInt(10)

        -- Check if the player is valid 
        if IsValid(PlayerArrested) then 

            -- Check if the Player can buy
            if ply:canAfford(25000) then 

                -- Remove the timer arrest and prisoner's release 
                if timer.Exists("rpt_timerarrest"..PlayerArrested:EntIndex()) then 
                    ply:addMoney(-RPTTableBailer[RPTInt]["vPrice"])
                    Realistic_Police.UnArrest(PlayerArrested)
                    Realistic_Police.SendNotify(PlayerArrested, Realistic_Police.Lang[81][Realistic_Police.Langage].." "..ply:Name())
                    Realistic_Police.SendNotify(ply, Realistic_Police.Lang[64][Realistic_Police.Langage].." "..DarkRP.formatMoney(RPTTableBailer[RPTInt]["vPrice"]))
                    RPTTableBailer[RPTInt] = nil
                end 

            else 
                -- Send a notification if the player don't have enought money
                Realistic_Police.SendNotify(ply, Realistic_Police.Lang[65][Realistic_Police.Langage])
            end 
        end 

    elseif RPTString == "StripWeapon" then 

        local PlayerArrested = net.ReadEntity()
        
        -- RPTInt = Int of the weapon to remove
        local RPTInt = net.ReadUInt(10)

        
        if IsValid(PlayerArrested) && PlayerArrested:IsPlayer() then 

            -- Check if the player is near the Police Man 
            if PlayerArrested:GetPos():DistToSqr(ply:GetPos()) < 40000 && PlayerArrested.WeaponRPT["Cuff"] then 
                -- Check if the Player can confiscate this weapon 
                if not Realistic_Police.CantConfiscate[PlayerArrested.WeaponRPT["Weapon"][RPTInt]["ClassW"]] then 
                    PlayerArrested.WeaponRPT["Weapon"][RPTInt] = nil
                end 
            end 

        end 
    end 
end )

net.Receive("RealisticPolice:PlaceProp", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 0.1

    -- RPTString = String of the props into the table of the trunk 
    local RPTString = net.ReadString()

    -- Check if the Player can Open the trunk 
    if not Realistic_Police.CanOpenTrunk[team.GetName(ply:Team())] then return end 

    -- Check if the props is on the table of the trunk 
    if not istable(Realistic_Police.Trunk[RPTString]) then return end 

    if Realistic_Police.GetPoliceProps(ply) > Realistic_Police.MaxPropsTrunk then Realistic_Police.SendNotify(ply, Realistic_Police.Lang[79][Realistic_Police.Langage]) return end 

    -- Create The props 
    local RPTProps = ents.Create( "prop_physics" )
    RPTProps:SetModel( RPTString )
    RPTProps:SetPos( ply:GetEyeTrace().HitPos + Realistic_Police.Trunk[RPTString]["GhostPos"] )
    RPTProps:SetAngles(Angle(0,ply:GetAngles().y + 90,0))
    RPTProps:CPPISetOwner(ply)
    RPTProps:Spawn()

    -- Add the props to the undo list 
    undo.Create("prop")
	undo.AddEntity(RPTProps)
        undo.SetPlayer(ply)
    undo.Finish()
end ) 

net.Receive("RealisticPolice:Open", function(len,ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    ply.RPTAntiSpam = ply.RPTAntiSpam or CurTime()
    if ply.RPTAntiSpam > CurTime() then return end 
    ply.RPTAntiSpam = CurTime() + 1

    local EntityC = net.ReadEntity()
    if EntityC:GetClass() != "realistic_police_computer" && ply:GetPos():DistToSqr(EntityC:GetPos()) > 10000 then return end 

    -- check if the player is near a computer or a vehicle 
    if not CheckEnts(ply) then return end 

    -- Set the Boolen on the vehicle / the computer for the hack 
    if IsValid(EntityC) && EntityC:GetClass() == "realistic_police_computer" or EntityC:IsVehicle() then 
        EntityC:SetNWBool("rpt_hack", true)
        timer.Create("rpt_resolve"..EntityC:EntIndex(), Realistic_Police.ResolveHack, 1, function()
            if IsValid(EntityC) then 
                EntityC:SetNWBool("rpt_hack", false)
            end 
        end ) 
    end 
end ) 

net.Receive("RealisticPolice:NameCamera", function(len, ply)
    local RPTEntity = net.ReadEntity()
    if not IsValid(RPTEntity) then return end 
    
    local String = net.ReadString() or ""
    RPTEntity:SetNWString("rpt_name_camera", String)
end )



