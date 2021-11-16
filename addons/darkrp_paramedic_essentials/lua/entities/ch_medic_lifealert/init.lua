AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/paramedic_essentials/props/alarm.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
	
    self:PhysWake()
end

function ENT:Use( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1
	
		if caller.HasLifeAlert then
			DarkRP.notify( caller, 1, 5, CH_AdvMedic.Config.Lang["You are already equipped with a life alert!"][CH_AdvMedic.Config.Language] )
			return
		end
		
		DarkRP.notify( caller, 1, 5, CH_AdvMedic.Config.Lang["You have equipped a life alert!"][CH_AdvMedic.Config.Language] )
		caller.HasLifeAlert = true
		self:Remove()
	end
end