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
	self:SetModel("models/humans/group02/female_02.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE) 
end

function ENT:Use(activator)
	if Realistic_Police.CheckJailPos() then 
		RPTTableBailer = RPTTableBailer or {}
		for k,v in pairs(RPTTableBailer) do 
			if not IsValid(RPTTableBailer[k]["vEnt"]) or not timer.Exists("rpt_timerarrest"..RPTTableBailer[k]["vEnt"]:EntIndex()) then 
				RPTTableBailer[k] = nil 
			end 
		end 
		if #RPTTableBailer != 0 then 
			net.Start("RealisticPolice:HandCuff")
				net.WriteString("Bailer")
				net.WriteTable(RPTTableBailer)
			net.Send(activator)
		else 
			Realistic_Police.SendNotify(activator, Realistic_Police.Lang[72][Realistic_Police.Langage])
		end 
	else 
		Realistic_Police.SendNotify(activator, Realistic_Police.Lang[73][Realistic_Police.Langage])
	end 
end 

function ENT:OnTakeDamage()
    return 0
end