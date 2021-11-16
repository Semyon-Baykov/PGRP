AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then
		return
	end
	
	local SpawnPos = tr.HitPos + tr.HitNormal
	
	local ent = ents.Create( "ch_recharge_station" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/paramedic_essentials/recharge_station.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:SetNWInt( "RechargesLeft", CH_AdvMedic.Config.DefaultCharges )
end

function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1

		if table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( caller:Team() ) ) then
			if caller:GetActiveWeapon():GetClass() == "med_kit_advanced" then
				if self.Entity:GetNWInt( "RechargesLeft" ) <= 0 then
					DarkRP.notify( caller, 2, 5,  CH_AdvMedic.Config.Lang["There are no recharges available at this moment!"][CH_AdvMedic.Config.Language] )
					return
				end
				
				if caller:GetActiveWeapon():GetNWInt( "WeaponCharge" ) <= CH_AdvMedic.Config.MinimumCharge then
					caller:GetActiveWeapon():SetNWInt( "WeaponCharge", 100 )
					DarkRP.notify( caller, 2, 5,  CH_AdvMedic.Config.Lang["Your medkit has been fully recharged!"][CH_AdvMedic.Config.Language] )
					self.Entity:SetNWInt( "RechargesLeft", self.Entity:GetNWInt("RechargesLeft") - 1 )
				else
					DarkRP.notify( caller, 2, 5,  CH_AdvMedic.Config.Lang["You can only recharge your medkit when it's under"][CH_AdvMedic.Config.Language] .." ".. CH_AdvMedic.Config.MinimumCharge .."%" )
				end
			else
				DarkRP.notify( caller, 2, 5,  CH_AdvMedic.Config.Lang["You need to equip the medkit to recharge it!"][CH_AdvMedic.Config.Language] )
			end
		else
			DarkRP.notify( caller, 1, 5,  CH_AdvMedic.Config.Lang["Only paramedics can use the recharge station!"][CH_AdvMedic.Config.Language] )
		end
	end
end

function ENT:OnTakeDamage( dmg )
	return 0
end