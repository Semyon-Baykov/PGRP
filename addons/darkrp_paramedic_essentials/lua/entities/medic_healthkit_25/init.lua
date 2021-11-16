AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/paramedic_essentials/weapons/w_medpack.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    
	self:PhysWake()
end

function ENT:Use( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1
	
		if caller:Health() >= caller:GetMaxHealth() then
			DarkRP.notify( caller, 1, 5,  CH_AdvMedic.Config.Lang["You've reached the maximum amount of health that you can have!"][CH_AdvMedic.Config.Language] )
			return
		end
		
		if caller:Health() + 25 >= caller:GetMaxHealth() then
			caller:SetHealth( caller:GetMaxHealth() )
			DarkRP.notify( caller, 1, 5,  CH_AdvMedic.Config.Lang["Your health has been filled to the maximum!"][CH_AdvMedic.Config.Language] )
		else
			caller:SetHealth( caller:Health() + 25 )
			DarkRP.notify( caller, 1, 5,  "+25 ".. CH_AdvMedic.Config.Lang["Health"][CH_AdvMedic.Config.Language] )
		end
		
		-- Check to fixs injuries
		if caller:Health() >= CH_AdvMedic.Config.MinHealthFixInjury then
			if caller:HasInjury() then
				ADV_MEDIC_DMG_FixInjuries( caller, true )
			end
		end
		
		self:Remove()
	end
end