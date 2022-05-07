AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName		= "Russian chocolate"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "MRE Pack"

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

		self:SetModel( "models/sngration/sngr_choco.mdl" )
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

		local buffhealth = math.random(15,25)
		local maxhealth =100

				if activator:getDarkRPVar('Energy') == maxhealth then
					self:Remove()
					activator:EmitSound( Sound( "lel/omnomnom.wav" ) )
				else
					self:Remove()
					activator:EmitSound( Sound( "lel/omnomnom.wav" ) )
					activator:SetEnergy( activator:getDarkRPVar('Energy') + buffhealth )
						if activator:getDarkRPVar('Energy') >= 100 then
						activator:SetEnergy( maxhealth )
						end
				end

	end

	function ENT:Think()
	end

end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
