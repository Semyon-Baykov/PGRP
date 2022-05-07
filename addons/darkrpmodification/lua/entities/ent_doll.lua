ENT.Base = "base_gmodentity"

ENT.PrintName = 'а'
ENT.Author = 'а'
ENT.Information = 'а'
ENT.Category = 'GPortalRP'
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = false



if SERVER then

	function ENT:Initialize()

		self:SetModel( "models/props_c17/doll01.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
	 
        local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	
		self:SetUseType( SIMPLE_USE )

	end
 
 
	function ENT:Use( activator, caller )
		if self.used then return end
		self.used = true
		activator:SendLua( 'sound.PlayURL("https://file.coffee/lEbimhUP9.mp3", "mono", function() end)' )
		self:SetAngles( Angle(activator:GetAngles().x, activator:GetAngles().y-180, activator:GetAngles().z) )
	end
	 
	function ENT:Think()

	end
else
	function ENT:Draw()
    	self:DrawModel()
	end
end