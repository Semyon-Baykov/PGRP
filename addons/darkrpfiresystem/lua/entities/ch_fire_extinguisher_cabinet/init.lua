AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString( "CH_FIRE_ExtCabinet_StartCooldown" )

function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then
		return
	end
	
	local SpawnPos = tr.HitPos + tr.HitNormal
	
	local ent = ents.Create( "ch_fire_extinguisher_cabinet" )
	ent:SetPos( SpawnPos + Vector( 0, 0, 10 ) )
	ent:SetAngles( ply:GetAngles() + Angle( 0, 180, 0 ) )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self:SetModel( "models/sterling/rustry_extinguisher_cabinet.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD  )
	
	self.ExtCooldown = false
end

function ENT:AcceptInput( ply, caller )
	if caller:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1
		
		if self.ExtCooldown then
			DarkRP.notify( caller, 2, 5,  CH_FireSystem.Config.Lang["You cannot take an extinguisher at the moment."][CH_FireSystem.Config.Language] )
			return
		end
		
		if not caller:IsFireFighter() then
			-- Put cabinet on cooldown
			self.ExtCooldown = true
			
			timer.Simple( CH_FireSystem.Config.CabinetCooldown, function()
				if IsValid( self ) then
					self.ExtCooldown = false
				end
			end )
			
			-- Cooldown timer on cabinet
			net.Start( "CH_FIRE_ExtCabinet_StartCooldown" )
				net.WriteUInt( CH_FireSystem.Config.CabinetCooldown, 10 )
				net.WriteEntity( self )
			net.Send( caller )
			
			caller:Give( "fire_extinguisher" )
			DarkRP.notify( caller, 2, 5,  CH_FireSystem.Config.Lang["Succesfully took a citizen extinguisher from the cabinet."][CH_FireSystem.Config.Language] )
		end
	end
end

function ENT:OnTakeDamage( dmg )
	return 0
end