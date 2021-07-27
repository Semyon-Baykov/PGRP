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

local function GetCameras(Players)
    local Tbl = {}
    for k,v in pairs(ents.FindByClass("realistic_police_camera")) do 
        if IsValid(v:CPPIGetOwner()) then 
            if v:CPPIGetOwner() == Players then 
                if IsValid(v) then 
                    Tbl[#Tbl + 1] = v
                end   
            end 
        end 
    end 
    return Tbl 
end 

function ENT:Initialize()
	self:SetModel( "models/props/cs_office/tv_plasma.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetNWInt("CameraId", 1)
	local RealisticPolicePhys = self:GetPhysicsObject()
	RealisticPolicePhys:EnableMotion(false)
	RealisticPolicePhys:Wake()

	timer.Create("rpt_refresh_camera:"..self:EntIndex(), 3, 0, function()
		if not IsValid(self) then return end  
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 100)) do 
			if IsValid(v) && v:IsPlayer() then 
				v.RPTShowEntity = GetCameras(v)[self:GetNWInt("CameraId")]
			end 
		end 
	end)
end

function ENT:Use(activator)
	if IsValid(self:CPPIGetOwner()) then 
		if self:GetNWInt("CameraId") < #GetCameras(self:CPPIGetOwner()) then 
			self:SetNWInt("CameraId", self:GetNWInt("CameraId") + 1) 
		else 
			self:SetNWInt("CameraId", 1) 
		end 
		activator.RPTShowEntity = GetCameras(self:CPPIGetOwner())[self:GetNWInt("CameraId")]
	end 
end 