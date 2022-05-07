AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "brax_atm" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:BreakOpen(ply)
	local m = ents.Create("spawned_money")
	m:SetPos(self:GetPos() + (self:GetForward()*35) + (self:GetUp()*30) )
	m:Spawn()
	m:Setamount(GetConVarNumber("brax_crowbar_money_atm") or 1000)
end

function ENT:Initialize()

	self.BreakOpenHealthMax = 10
	self.BreakOpenHealth = 10
	self.BreakOpenBroken = false

	self:SetModel("models/props_unique/atm01.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
end