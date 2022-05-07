AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/power/rtg.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()
	
	self:SetHealth( CH_Bitminers.Config.RTGGeneratorHealth )
	self:SetMaxHealth( CH_Bitminers.Config.RTGGeneratorHealth )
	
	self:SetWattsGenerated( 0 )
	self:SetPowerOn( true )
	
	self.IsPluggedIn = false
	self.ConnectedEntity = nil
	
	self:CPPISetOwner( self:Getowning_ent() )
end

local RTG_RandomSounds = {
	"craphead_scripts/bitminers/rtg_geiger1.wav",
	"craphead_scripts/bitminers/rtg_geiger2.wav",
	"craphead_scripts/bitminers/rtg_geiger3.wav"
}

function ENT:RTGPluggedIn()
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_rtg_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_rtg_decreasewatts_".. self:EntIndex() )
	end
	
	-- Start generating power/watts
	self:GenerateWatts()
	
	-- Start emitting radiation (damage players close)
	if CH_Bitminers.Config.RTGRadiationEnabled then
		self:EmitRadiation()
	end
	
	-- Set shelf power source status
	if IsValid( self.ConnectedEntity ) then
		if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
			local connected_shelf = self.ConnectedEntity.Parent.ConnectedEntity
			
			if connected_shelf:GetClass() != "ch_bitminer_shelf" then
				return
			end
			
			connected_shelf:SetHasPower( true )
		end
	end
end

function ENT:RTGPluggedOut()	
	-- Remove watt generator timer
	if timer.Exists( "bitminer_rtg_generatewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_rtg_generatewatts_".. self:EntIndex() )
	end
	
	-- Remove radiation timer
	if timer.Exists( "bitminer_rtg_radiation_".. self:EntIndex() ) then
		timer.Remove( "bitminer_rtg_radiation_".. self:EntIndex() )
	end
	
	-- Start decreasing watts
	self:DecreaseWatts()
	
	-- Set shelf power source status
	if IsValid( self.ConnectedEntity ) then
		if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
			local connected_shelf = self.ConnectedEntity.Parent.ConnectedEntity
			
			if connected_shelf:GetClass() != "ch_bitminer_shelf" then
				return
			end
			
			connected_shelf:SetHasPower( false )
			
			if connected_shelf:GetIsMining() then
				connected_shelf:PowerOff()
			end
		end
	end
end

function ENT:GenerateWatts()
	timer.Create( "bitminer_rtg_generatewatts_".. self:EntIndex(), CH_Bitminers.Config.RTGWattsInterval, 0, function()

		self:EmitSound( table.Random( RTG_RandomSounds ), 75, 100, 1, CHAN_AUTO )
		
		local rand_watts_generated = math.random( CH_Bitminers.Config.RTGWattsMin, CH_Bitminers.Config.RTGWattsMax )
		self:SetWattsGenerated( self:GetWattsGenerated() + rand_watts_generated )
		
		-- Update shelf watts
		if IsValid( self.ConnectedEntity ) then
			if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
				local shelf_ent = self.ConnectedEntity.Parent.ConnectedEntity

				if shelf_ent:GetClass() == "ch_bitminer_power_combiner" then
					shelf_ent:SetWattsGenerated( math.Clamp( shelf_ent:GetWattsGenerated() + rand_watts_generated, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
				else
					shelf_ent:SetWattsGenerated( math.Clamp( self:GetWattsGenerated(), 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
					
					if shelf_ent:GetWattsGenerated() > 0 then
						shelf_ent:SetHasPower( true )
					end
				end
			end
		end
	end )
end

function ENT:DecreaseWatts()
	timer.Create( "bitminer_rtg_decreasewatts_".. self:EntIndex(), CH_Bitminers.Config.WattsDecreaseInterval, 0, function()
		if IsValid( self ) then
			local rand_watts_decreased = math.random( CH_Bitminers.Config.DecreaseAmountMin, CH_Bitminers.Config.DecreaseAmountMax )
			
			self:SetWattsGenerated( math.Clamp( self:GetWattsGenerated() - rand_watts_decreased, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
		end
	end )
end

function ENT:EmitRadiation()
	local owner = self:CPPIGetOwner()
	
	timer.Create( "bitminer_rtg_radiation_".. self:EntIndex(), CH_Bitminers.Config.RTGRadiationInterval, 0, function()

		self:EmitSound( table.Random( RTG_RandomSounds ), 75, 100, 1, CHAN_AUTO )
		
		-- Check players nearby and deal damage if they stay close to the RTG
		if CH_Bitminers.Config.RTGRadiationDamageOwnerOnly then
			if owner:GetPos():DistToSqr( self:GetPos() ) < CH_Bitminers.Config.RTGRadiationDistance then
				local random_dmg = math.random( 3, 10 )
				owner:TakeDamage( random_dmg, self, self )
			end
		else
			for k, v in pairs( player.GetAll() ) do
				if v:GetPos():DistToSqr( self:GetPos() ) < CH_Bitminers.Config.RTGRadiationDistance then
					local random_dmg = math.random( 3, 10 )
					v:TakeDamage( random_dmg, self, self )
				end
			end
		end
	end )
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true

		self:SetHealth( ( self:Health() or 100 ) - dmg:GetDamage() )
		if self:Health() <= 0 then
			self:Destruct()
			self:Remove()
		end
		
		self.m_bApplyingDamage = false
	end
end

function ENT:SkyTrace()
    local sky = {}
    sky.start = self:GetPos()
    sky.endpos = self:GetPos() + Vector( 0, 0, 100000 ) -- 76561198051291901
    sky.filter = self
	
    local tsky = util.TraceLine( sky )
	
    return tsky.HitSky
end

function ENT:Destruct()
	local owner = self:CPPIGetOwner()

	if CH_Bitminers.Config.RTGGeneratorExplosion and not self.IsDestroyed then
		self.IsDestroyed = true
		
		local vPoint = self:GetPos()
		local effect_explode = ents.Create( "env_explosion" )
		if not IsValid( effect_explode ) then return end
		effect_explode:SetPos( vPoint )
		effect_explode:Spawn()
		effect_explode:SetKeyValue( "iMagnitude","200" )
		effect_explode:Fire( "Explode", 0, 0 )
		
		if CH_Bitminers.Config.CreateFireOnExplode then
			local Fire = ents.Create( "fire" )
			Fire:SetPos( vPoint )
			Fire:SetAngles( Angle( 0, 0, 0 ) )
			Fire:Spawn()
		end
	end

	self:Remove()
end

function ENT:OnRemove()
	self:RTGPluggedOut()
	
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_rtg_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_rtg_decreasewatts_".. self:EntIndex() )
	end
	
	-- Unplug from solar panel if removed
	if IsValid( self.ConnectedEntity ) then
		self.ConnectedEntity:UnplugCable( self )
	end
end