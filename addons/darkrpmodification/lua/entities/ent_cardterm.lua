AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "GPortalRP Car Terminal"
ENT.Author			= "KaiL"
ENT.Category 		= "GPRP"

ENT.AdminSpawnable 	= false
ENT.Spawnable 		= true

if SERVER then
	
	function ENT:Initialize()

		self:SetModel( 'models/chamcontent/terminal.mdl' )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		
		local phys = self:GetPhysicsObject()

		if phys:IsValid() then
			phys:Wake()
		end

	end

	function ENT:Use( a, c )

		c:OpenSpawnMenu( self )

	end

end


if CLIENT then

	function ENT:Draw()
	
		self:DrawModel()
	
	end

	function ENT:Think()

			local dlight = DynamicLight( self:EntIndex() )
			if ( dlight ) then
				dlight.pos = self:LocalToWorld( Vector( 0,  self:OBBMaxs().y+7, 65 ) )
				dlight.r = 100
				dlight.g = 100
				dlight.b = 255
				dlight.brightness = 0.7
				dlight.Decay = 1000
				dlight.Size = 256
				dlight.DieTime = CurTime() + 1
			end

	end

end
