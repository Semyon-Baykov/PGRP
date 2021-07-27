AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName		= "Spawn plz"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "GPRP"

ENT.AdminSpawnable 	= false
ENT.Spawnable 		= true

if SERVER then

	function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create( self.ClassName )
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
	end

	function ENT:Initialize()

		self:SetModel( "models/props_c17/statue_horse.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetSkin( math.random(0,0) )

			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end

	function ENT:Use( activator, caller )
		activator:Spawn()
	end
	function ENT:Think()
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
