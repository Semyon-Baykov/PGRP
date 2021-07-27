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
ENT.Editable = true

function ENT:Initialize()
	self:SetModel( "models/wasted/wasted_kobralost_camera.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local RealisticPolicePhys = self:GetPhysicsObject()
	RealisticPolicePhys:EnableMotion(false)
	RealisticPolicePhys:EnableGravity(true)
	RealisticPolicePhys:Wake()
	self.HealthEntity = Realistic_Police.CameraHealth
	self.DestroyCam = false  
	self.RotateBack = false 
	self:SetRptRotate("nil")
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	if(self.HealthEntity <= 0) then return end
	self.HealthEntity = self.HealthEntity - dmg:GetDamage()
	if(self.HealthEntity <= 0) then
		Realistic_Police.BrokeCamera(self)
	end
end

function ENT:Think()
	if self:GetRptRotate() != "nil" then 
		if self:GetRptRotate()  == "Left" then 
			if not isnumber(self.RotateAngleY) then 
				self.RotateAngleY = 0 
			end 
			if self.RotateAngleY < 50 then 
				self.RotateAngleY = self.RotateAngleY + 2
				self:ManipulateBoneAngles( 2, Angle(self.RotateAngleY,0,0) )
			end 
		end 
		if self:GetRptRotate()  == "Right" then 
			if not isnumber(self.RotateAngleY) then 
				self.RotateAngleY = 0 
			end 
			if self.RotateAngleY > -50 then
				self.RotateAngleY = self.RotateAngleY - 2
				self:ManipulateBoneAngles( 2, Angle(self.RotateAngleY,0,0) )
			end 
		end 
	end  
end 

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "RptCam" )
	self:NetworkVar( "String", 1, "RptRotate" )
end

function ENT:UpdateTransmitState()    
    return TRANSMIT_ALWAYS 
end

