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
ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	self:SetModel( "models/props/sycreations/workstation.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local RealisticPolicePhys = self:GetPhysicsObject()
	RealisticPolicePhys:EnableMotion(false)
	RealisticPolicePhys:Wake()
end

function ENT:Use(activator)
	if Realistic_Police.OpenComputer[team.GetName(activator:Team())] or Realistic_Police.HackerJob[team.GetName(activator:Team())] then 
		activator.AntiSpam = activator.AntiSpam or CurTime()
		if activator.AntiSpam > CurTime() then return end 
		activator.AntiSpam = CurTime() + 1 

		net.Start("RealisticPolice:Open")
			net.WriteString("OpenMainMenu")
			net.WriteEntity(self)
			net.WriteBool(false)
		net.Send(activator)
	else 
		Realistic_Police.SendNotify(activator, Realistic_Police.Lang[35][Realistic_Police.Langage])
	end 
end 