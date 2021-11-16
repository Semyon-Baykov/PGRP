AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/Items/battery.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    
	self:PhysWake()
end

function ENT:Use( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1
	
		if caller:Armor() >= CH_AdvMedic.Config.MaximumArmor then
			DarkRP.notify( caller, 1, 5, CH_AdvMedic.Config.Lang["You've reached the maximum amount of armor that you can have!"][CH_AdvMedic.Config.Language] )
			return
		end
		
		if caller:Armor() + 25 >= CH_AdvMedic.Config.MaximumArmor then
			caller:SetArmor( CH_AdvMedic.Config.MaximumArmor )
			DarkRP.notify( caller, 1, 5, CH_AdvMedic.Config.Lang["Your armor has been filled to the maximum!"][CH_AdvMedic.Config.Language] )
		else
			caller:SetArmor( caller:Armor() + 25 )
			DarkRP.notify( caller, 1, 5, "+25 ".. CH_AdvMedic.Config.Lang["Armor"][CH_AdvMedic.Config.Language] )
		end
		self:Remove()
	end
end