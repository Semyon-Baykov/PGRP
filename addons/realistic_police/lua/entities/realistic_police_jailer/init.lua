--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/Female_02.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
	print(activator)
	if Realistic_Police.CheckJailPos() then 
		if IsValid(activator.WeaponRPT["Drag"]) && activator.WeaponRPT["Drag"]:IsPlayer() then 
			if Realistic_Police.CanCuff[team.GetName(activator:Team())] then 			
				net.Start("RealisticPolice:HandCuff")
					net.WriteString("Jailer")
					net.WriteString(activator.WeaponRPT["Drag"]:GetName())
				net.Send(activator)
			end
		else 
			Realistic_Police.SendNotify(activator, Realistic_Police.Lang[63][Realistic_Police.Langage])
		end  
	else 
		Realistic_Police.SendNotify(activator, Realistic_Police.Lang[73][Realistic_Police.Langage])
	end 
end 

function ENT:OnTakeDamage()
    return 0
end