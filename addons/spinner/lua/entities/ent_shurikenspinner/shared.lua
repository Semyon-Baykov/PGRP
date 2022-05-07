ENT.Type = "anim"
ENT.PrintName		= ""
ENT.Author			= "Pyro: Model / Diablos: Code"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable = false

function ENT:Initialize()
	self:SetModel("models/weapons/w_fidget_spinner.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	if SERVER then self:PhysicsInit(SOLID_VPHYSICS) end
	
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then phys:Wake() end
end