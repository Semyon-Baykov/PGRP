AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("LEDDamaged")

function ENT:Initialize()
	
	self:SetText("Made by Mac with <3")
	self:SetTColor(Vector(2.55,2,0))
	self:SetType(1)
	self:SetSpeed(1.5)
	self:SetWide(6)
	self:SetFX(1)
	self:SetOn(1)
	
	self:SetModel("models/squad/sf_plates/sf_plate1x"..self:GetWide()..".mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial("phoenix_storms/mat/mat_phx_carbonfiber")
	self:SetColor(Color(0,0,0))
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetNWInt("LastDamaged", 0)
	local phys = self:GetPhysicsObject()
	self.nodupe = true
	self.ShareGravgun = true

	phys:Wake()
	
end

function ENT:Think()

	if self:GetModel() != "models/squad/sf_plates/sf_plate1x"..self:GetWide()..".mdl" then
		self:SetModel("models/squad/sf_plates/sf_plate1x"..self:GetWide()..".mdl")
	end
	
	self:NextThink( CurTime() + 1 )
	return true
	
end

function ENT:OnTakeDamage(data)
	
	if data:GetDamagePosition() then
		self:EmitSound("ambient/energy/spark".. math.random(1,6) ..".wav")
		local effectdata = EffectData()
		effectdata:SetOrigin( data:GetDamagePosition() )
		util.Effect( "StunstickImpact", effectdata )
		self:SetNWInt("LastDamaged", math.Round(CurTime()+2))
	end
	
end