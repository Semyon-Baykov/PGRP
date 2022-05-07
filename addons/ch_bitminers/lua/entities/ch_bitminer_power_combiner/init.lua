AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/power/power_combiner.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()
	
	self:SetHealth( CH_Bitminers.Config.PowerCombinerHealth )
	self:SetMaxHealth( CH_Bitminers.Config.PowerCombinerHealth )
	
	self:SetWattsGenerated( 0 )
	self:SetPowerOn( true )
	
	self.IsPluggedIn = false
	self.ConnectedEntity = nil
	
	self.RopeToShelf = nil
	self.ConnectedCables = 0
	
	self:CPPISetOwner( self:Getowning_ent() )
	
	self.ConnectedCablesTable = {
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
		[5] = false,
	}
end

function ENT:CombinerPluggedInShelf()
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_combiner_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_combiner_decreasewatts_".. self:EntIndex() )
	end
	
	-- Start generating power/watts
	self:GenerateWatts()
end

function ENT:CombinerPluggedOut()
	-- Remove watt generator timer
	if timer.Exists( "bitminer_combiner_generatewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_combiner_generatewatts_".. self:EntIndex() )
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
	timer.Create( "bitminer_combiner_generatewatts_".. self:EntIndex(), CH_Bitminers.Config.SolarPanelWattsInterval, 0, function()
		if self.ConnectedCables < 2 then -- There are no power sources connected to combiner (maybe only a shelf)
			-- Start decreasing watts
			self:DecreaseWatts()
		end
		
		-- Update shelf watts
		if IsValid( self.ConnectedEntity ) then
			if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
				local shelf_ent = self.ConnectedEntity.Parent.ConnectedEntity
				
				-- Power on if watts in power combiner > 0
				if self:GetWattsGenerated() > 0 then
					shelf_ent:SetHasPower( true )
				else
					shelf_ent:SetHasPower( false )
					
					-- Stop spin sequence and set skin to off
					shelf_ent:PowerOff()
				end
				
				-- Update watts generated on shelf
				shelf_ent:SetWattsGenerated( math.Clamp( self:GetWattsGenerated(), 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
			end
		end
	end )
end

function ENT:DecreaseWatts()
	-- If already decreasing then return end
	if timer.Exists( "bitminer_combiner_decreasewatts_".. self:EntIndex() ) then
		return
	end
	
	local latest_total_watts = 0
	
	timer.Create( "bitminer_combiner_decreasewatts_".. self:EntIndex(), CH_Bitminers.Config.WattsDecreaseInterval, 0, function()
		if IsValid( self ) then
			local rand_watts_decreased = math.random( CH_Bitminers.Config.DecreaseAmountMin, CH_Bitminers.Config.DecreaseAmountMax )
			
			self:SetWattsGenerated( math.Clamp( self:GetWattsGenerated() - rand_watts_decreased, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
			
			-- Update shelf watts
			if IsValid( self.ConnectedEntity ) then
				if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
					local shelf_ent = self.ConnectedEntity.Parent.ConnectedEntity
					
					if self:GetWattsGenerated() > latest_total_watts then
						shelf_ent:SetWattsGenerated( math.Clamp( self:GetWattsGenerated(), 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
					
						latest_total_watts = self:GetWattsGenerated()
					end
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
    sky.endpos = self:GetPos() + Vector( 0, 0, 100000 )
    sky.filter = self
	
    local tsky = util.TraceLine( sky )
	
    return tsky.HitSky
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "ManhackSparks", effectdata )
end

function ENT:OnRemove()
	self:CombinerPluggedOut()
	
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_combiner_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_combiner_decreasewatts_".. self:EntIndex() )
	end
	
	-- Unplug from combiner if removed
	if IsValid( self.ConnectedEntity ) then
		self.ConnectedEntity:UnplugCable( self )
	end
end