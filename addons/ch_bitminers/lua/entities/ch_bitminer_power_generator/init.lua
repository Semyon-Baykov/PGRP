AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/power/generator.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()
	
	self:SetSkin( 0 )
	self:SetHealth( CH_Bitminers.Config.FuelGeneratorHealth )
	self:SetMaxHealth( CH_Bitminers.Config.FuelGeneratorHealth )
	
	self:SetFuel( 0 )
	self:SetWattsGenerated( 0 )
	self:SetPowerOn( false )
	
	self.IsPluggedIn = false
	self.ConnectedEntity = nil
	
	self.GeneratorStartSound = CreateSound( self, "vehicles/airboat/fan_motor_start1.wav" )
	self.GeneratorStopSound = CreateSound( self, "vehicles/airboat/fan_motor_shut_off1.wav" )
	self.GeneratorLoopSound = CreateSound( self, "vehicles/airboat/fan_motor_idle_loop1.wav" )
	
	self.GeneratorStartSound:SetSoundLevel( CH_Bitminers.Config.FuelGeneratorSoundLevel )
	self.GeneratorStopSound:SetSoundLevel( CH_Bitminers.Config.FuelGeneratorSoundLevel )
	self.GeneratorLoopSound:SetSoundLevel( CH_Bitminers.Config.FuelGeneratorSoundLevel )
	
	self:CPPISetOwner( self:Getowning_ent() )
end

function ENT:AcceptInput( key, ply )
	if ( self.LastUsed or CurTime() ) <= CurTime() then
		self.LastUsed = CurTime() + 3

		local tr = self:WorldToLocal( ply:GetEyeTrace().HitPos ) 
		
		if tr:WithinAABox( CH_Bitminers.Config.GeneratorPositions.power_on_one, CH_Bitminers.Config.GeneratorPositions.power_on_two ) then
			if not self:GetPowerOn() then
				if self:GetFuel() > 0 then
					self:PowerOn()
					DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["You have powered on the generator!"][CH_Bitminers.Config.Language] )
				else
					DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["The generator has no fuel!"][CH_Bitminers.Config.Language] )
				end
			else
				DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["The generator is already powered on!"][CH_Bitminers.Config.Language] )
			end
		elseif tr:WithinAABox( CH_Bitminers.Config.GeneratorPositions.power_off_one, CH_Bitminers.Config.GeneratorPositions.power_off_two ) then
			if self:GetPowerOn() then
				self:PowerOff()
				DarkRP.notify( ply, 1, 5, CH_Bitminers.Config.Lang["The generator has been turned off!"][CH_Bitminers.Config.Language] )
			else
				DarkRP.notify( ply, 1, 5, CH_Bitminers.Config.Lang["The generator is already turned off!"][CH_Bitminers.Config.Language] )
			end
		end
	end	
end

function ENT:PowerOn()
	self:ResetSequence( "start" )
	
	-- Sounds and loop
	self.GeneratorStartSound:Play()
	
	timer.Simple( 3, function()
		if IsValid( self ) then
			self.GeneratorStartSound:Stop()
			self.GeneratorLoopSound:Play()
		end
	end )
	
	timer.Simple( 0.2, function()
		if IsValid( self ) then
			self:SetPowerOn( true )
			self:SetSkin( 1 )
		end
	end )
	
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_generator_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_generator_decreasewatts_".. self:EntIndex() )
	end
	
	-- Start fuel consumption
	self:FuelConsumption()
	
	-- Start generating power/watts
	self:GenerateWatts()
	
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

function ENT:PowerOff()
	self:ResetSequence( "stop" )
	
	-- Sound turn off and stop loop
	self.GeneratorLoopSound:Stop()
	self.GeneratorStopSound:Play()
	
	timer.Simple( 1, function()
		if IsValid( self ) then
			if self.GeneratorStopSound then
				self.GeneratorStopSound:Stop()
			end
		end
	end )
	
	timer.Simple( 0.2, function()
		if IsValid( self ) then
			self:SetPowerOn( false )
			self:SetSkin( 0 )
		end
	end )
	
	-- Remove fuel consumption timer
	if timer.Exists( "bitminer_generator_fuelconsumption_".. self:EntIndex() ) then
		timer.Remove( "bitminer_generator_fuelconsumption_".. self:EntIndex() )
	end
	
	-- Remove watt generator timer
	if timer.Exists( "bitminer_generator_generatewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_generator_generatewatts_".. self:EntIndex() )
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
	timer.Create( "bitminer_generator_generatewatts_".. self:EntIndex(), CH_Bitminers.Config.GeneratorWattsInterval, 0, function()
		local rand_watts_generated = math.random( CH_Bitminers.Config.GeneratorWattsMin, CH_Bitminers.Config.GeneratorWattsMax )
		
		self:SetWattsGenerated( self:GetWattsGenerated() + rand_watts_generated )
		
		-- Update shelf watts
		if IsValid( self.ConnectedEntity ) then
			if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
				local shelf_ent = self.ConnectedEntity.Parent.ConnectedEntity
				
				if shelf_ent:GetClass() == "ch_bitminer_power_combiner" then
					shelf_ent:SetWattsGenerated( math.Clamp( shelf_ent:GetWattsGenerated() + rand_watts_generated, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
				else
					shelf_ent:SetWattsGenerated( math.Clamp( self:GetWattsGenerated(), 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
				end
			end
		end
	end )
end

function ENT:DecreaseWatts()
	-- If already decreasing then return end
	if timer.Exists( "bitminer_generator_decreasewatts_".. self:EntIndex() ) then
		return
	end
	
	timer.Create( "bitminer_generator_decreasewatts_".. self:EntIndex(), CH_Bitminers.Config.WattsDecreaseInterval, 0, function()
		if IsValid( self ) then
			local rand_watts_decreased = math.random( CH_Bitminers.Config.DecreaseAmountMin, CH_Bitminers.Config.DecreaseAmountMax )
			
			self:SetWattsGenerated( math.Clamp( self:GetWattsGenerated() - rand_watts_decreased, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
			
			-- Update shelf watts
			if IsValid( self.ConnectedEntity ) then
				if IsValid( self.ConnectedEntity.Parent.ConnectedEntity ) then
					local shelf_ent = self.ConnectedEntity.Parent.ConnectedEntity
					
					if shelf_ent:GetClass() == "ch_bitminer_power_combiner" then
						shelf_ent:SetWattsGenerated( math.Clamp( shelf_ent:GetWattsGenerated() - rand_watts_decreased, 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
					else
						shelf_ent:SetWattsGenerated( math.Clamp( self:GetWattsGenerated(), 0, ( 16 * CH_Bitminers.Config.WattsRequiredPerMiner ) ) )
					end
				end
			end
		end
	end )
end

function ENT:FuelConsumption()
	local owner = self:CPPIGetOwner()
	
	timer.Create( "bitminer_generator_fuelconsumption_".. self:EntIndex(), CH_Bitminers.Config.FuelConsumptionRate, 0, function()
		local rand_fuel_consumption = math.random( CH_Bitminers.Config.FuelConsumptionMin, CH_Bitminers.Config.FuelConsumptionMax )
		
		self:SetFuel( self:GetFuel() - rand_fuel_consumption )
		
		if self:GetFuel() <= 0 then
			self:PowerOff()
			
			DarkRP.notify( owner, 1, 5, CH_Bitminers.Config.Lang["Your generator has ran out of fuel!"][CH_Bitminers.Config.Language] )
		end
	end )
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.LastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.LastTouch = CurTime() + 1
	
	local owner = self:CPPIGetOwner()
	
	if ent:GetClass() == "ch_bitminer_power_generator_fuel_small" or ent:GetClass() == "ch_bitminer_power_generator_fuel_medium" or ent:GetClass() == "ch_bitminer_power_generator_fuel_large" then
		if self:GetFuel() >= 100 then
			DarkRP.notify( owner, 1, 5, CH_Bitminers.Config.Lang["Your generator is already full of fuel!"][CH_Bitminers.Config.Language] )
			return
		end
		
		-- Refill fuel level to 100
		self:SetFuel( math.Clamp( self:GetFuel() + ent.FuelAmount, 0, 100 ) )
		
		ent:Remove()
	end
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

function ENT:Destruct()
	local owner = self:CPPIGetOwner()

	if CH_Bitminers.Config.FuelGeneratorExplosion and not self.IsDestroyed then
		self.IsDestroyed = true
		
		local vPoint = self:GetPos()
		local effect_explode = ents.Create( "env_explosion" )
		if not IsValid( effect_explode ) then return end
		effect_explode:SetPos( vPoint )
		effect_explode:Spawn()
		effect_explode:SetKeyValue( "iMagnitude","75" )
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
	self:PowerOff()
	
	-- Remove watt decrease timer
	if timer.Exists( "bitminer_generator_decreasewatts_".. self:EntIndex() ) then
		timer.Remove( "bitminer_generator_decreasewatts_".. self:EntIndex() )
	end
	
	-- Unplug from generator if removed
	if IsValid( self.ConnectedEntity ) then
		self.ConnectedEntity:UnplugCable( self )
	end
	
	-- Stop sounds if playing
	if self.GeneratorStopSound then
		self.GeneratorStopSound:Stop()
	end
	if self.GeneratorStartSound then
		self.GeneratorStartSound:Stop()
	end
	if self.GeneratorLoopSound then
		self.GeneratorLoopSound:Stop()
	end
end