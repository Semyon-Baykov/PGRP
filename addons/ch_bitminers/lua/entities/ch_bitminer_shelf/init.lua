AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/bitminers/rack/rack.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()
	
	self.ConnectedEntity = nil -- no power cords connected
	self.IsPluggedIn = false
	
	-- Set default values
	self:SetHealth( CH_Bitminers.Config.ShelfHealth )
	self:SetMaxHealth( CH_Bitminers.Config.ShelfHealth )
	
	self:SetMinersInstalled( 1 )
	self:SetMinersAllowed( 4 )
	
	self:SetUPSInstalled( 1 )
	self:SetFansInstalled( 0 )
	self:SetTemperature( CH_Bitminers.Config.ShelfStartTemperature )
	self:SetBitcoinsMined( 0 )
	
	self:SetWattsRequired( CH_Bitminers.Config.WattsRequiredPerMiner )
	self:SetWattsGenerated( 0 )
	
	self:SetRGBInstalled( false )
	self.RGBLightsOn = false
	
	self:SetHasPower( false )
	self:SetIsMining( false )
	
	self:SetIsHacked( false )
	
	-- Create sound
	self.ShelfMiningSound = CreateSound( self, "ambient/machines/air_conditioner_loop_1.wav" )
	self.ShelfMiningSound:SetSoundLevel( CH_Bitminers.Config.ShelfMiningSoundLevel )
	
	-- Initialize bodygroups and skin
	self:SetBodygroup( self:GetMinersInstalled(), 1 ) -- Miners
	self:SetBodygroup( 17, 1 ) -- UPS's
	self:SetBodygroup( 18, 0 ) -- Fans
	
	self:SetSkin( 0 ) -- 1: white 2: on 3: rgb
	
	-- Start temperature & cooling systems
	self:Temperature()
	
	-- Set DarkRP owner
	self:CPPISetOwner( self:Getowning_ent() )
end

function ENT:StartMining()
	if timer.Exists( "bitminer_mining_".. self:EntIndex() ) then
		timer.Remove( "bitminer_mining_".. self:EntIndex() )
	end
	
	local mine_interval = CH_Bitminers.Config.MineMoneyInterval[ self:GetMinersInstalled() ] or 16
	
	if CH_Bitminers.Config.ShelfMiningSoundLevel > 0 then
		self.ShelfMiningSound:Play()
	end
	
	timer.Create( "bitminer_mining_".. self:EntIndex(), mine_interval, 0, function()
		if not IsValid( self ) then
			return
		end
		
		if not self:GetHasPower() then
			self:StopMining()
			return
		end
		
		if not self:GetIsMining() then
			self:StopMining()
			return
		end
		
		-- Adding bitcoins to the shelf (check if at max)
		if self:GetBitcoinsMined() >= CH_Bitminers.Config.MaxBitcoinsMined  then
			return
		end
		
		-- Don't generate any bitcoins if generated watts is under required amount.
		if self:GetWattsGenerated() < self:GetWattsRequired() then
			return
		end
		
		local to_earn = self:GetBitcoinsMined() + CH_Bitminers.Config.BitcoinsMinedPer
		
		-- Update bitcoins if there's enough watts generated and everything else is good
		self:SetBitcoinsMined( math.Clamp( to_earn, 0, CH_Bitminers.Config.MaxBitcoinsMined ) )
	end )
end

function ENT:StopMining()
	-- Remove mining timer until started again
	if timer.Exists( "bitminer_mining_".. self:EntIndex() ) then
		timer.Remove( "bitminer_mining_".. self:EntIndex() )
	end
	
	-- Stop sounds
	if self.ShelfMiningSound then
		self.ShelfMiningSound:Stop()
	end
end

function ENT:Temperature()
	timer.Create( "bitminer_temperature_".. self:EntIndex(), CH_Bitminers.Config.TemperatureInterval, 0, function()
		-- If not mining/does not have power, then we can cooldown the miners
		if not self:GetHasPower() or not self:GetIsMining() then
			local temp_to_take = CH_Bitminers.Config.TempToTakeWhenOff
			
			self:SetTemperature( math.Clamp( self:GetTemperature() - temp_to_take, 0, 100 ) )
			return
		end
		
		-- If temperature is at 100, start overheating the mining shelf
		if self:GetTemperature() >= 100 then
			local health_to_take = 10

			self:SetHealth( self:Health() - health_to_take )
			
			if self:Health() <= 0 then
				self:Destruct()
			end
			
			return
		end
		
		-- Temperature system (as long as it's not overheating or turned off)
		local new_temp = 0
		
		local temp_to_add = CH_Bitminers.Config.TempToAddPerMiner * self:GetMinersInstalled()
		local temp_to_take = 0
		
		-- Cooldown based on how good the fan system is
		if self:GetFansInstalled() > 0 then
			temp_to_take = CH_Bitminers.Config.TempToTakePerCooling * self:GetFansInstalled()
		end
		
		temp_to_add = temp_to_add - temp_to_take
		new_temp = self:GetTemperature() + temp_to_add
		
		self:SetTemperature( math.Clamp( new_temp, 0, 100 ) )
		
		-- Notify owner of overheating if enabled
		if CH_Bitminers.Config.NotifyOwnerOverheating then
			if self:GetTemperature() >= 100 then
				local owner = self:CPPIGetOwner()
				
				DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["Your bitmining shelf is overheating!"][CH_Bitminers.Config.Language] )
			end
		end
	end )	
end

function ENT:AcceptInput( key, ply )
	if ( self.LastUsed or CurTime() ) <= CurTime() then

		self.LastUsed = CurTime() + 1
		
		local tr = self:WorldToLocal( ply:GetEyeTrace().HitPos ) 
		
		if self.IsBeingHacked then
			return
		end
		
		local owner = self:CPPIGetOwner()

		-- If the bitminer is not hacked, only allow the owner to access it.
		if not self:GetIsHacked() then -- if not hacked
			if ply != owner then -- person trying to access is not owner
				DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["Only the owner of this bitminer can access it!"][CH_Bitminers.Config.Language] )
				return
			end
		end
		
		-- If hacked or owner then allow access
		if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.power_btn_one, CH_Bitminers.Config.ScreenPositions.power_btn_two ) then
			if self:GetHasPower() then -- power source is connected
				if not self:GetIsMining() then
					self:PowerOn()
					
					DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["You have powered on your bitminers!"][CH_Bitminers.Config.Language] )
				end
			else
				DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["Your bitminer has no active power source."][CH_Bitminers.Config.Language] )
			end
		elseif tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.power_btn_small_one, CH_Bitminers.Config.ScreenPositions.power_btn_small_two ) then
			if self:GetIsMining() then
				self:PowerOff()
				
				DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["You have shut down your bitminers!"][CH_Bitminers.Config.Language] )
			end
		elseif tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.withdraw_one, CH_Bitminers.Config.ScreenPositions.withdraw_two ) then
			-- Don't allow if not turned on!
			if not self:GetIsMining() then
				return
			end

			self:WithdrawMoney( ply, false )
		elseif tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.rgb_btn_one, CH_Bitminers.Config.ScreenPositions.rgb_btn_two ) then
			-- Don't allow if not turned on!
			if not self:GetIsMining() then
				return
			end
			
			if self:GetRGBInstalled() then
				if not self.RGBLightsOn then
					self:SetSkin( 4 )
					self.RGBLightsOn = true
					self:SetRGBEnabled( true )
				else
					self:SetSkin( 3 )
					self.RGBLightsOn = false
					self:SetRGBEnabled( false )
				end
			else
				DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["You need to install an RGB upgrade to enable this!"][CH_Bitminers.Config.Language] )
			end
		end
	end	
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.LastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.LastTouch = CurTime() + 2
	
	local owner = self:CPPIGetOwner()
	
	if ent:GetClass() == "ch_bitminer_upgrade_miner" then
		if self:GetMinersInstalled() == 16 then
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["You've reached the maximum amount of miners installed at once."][CH_Bitminers.Config.Language] )
			return
		elseif self:GetMinersInstalled() == owner:GetMaxMiners() then
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["You've reached the maximum amount of miners based on your current rank."][CH_Bitminers.Config.Language] )
			return
		elseif self:GetMinersInstalled() >= self:GetMinersAllowed() then
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["You've reached the maximum amount of miners installed at once."][CH_Bitminers.Config.Language] )
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["Upgrade with another UPS to install more miners."][CH_Bitminers.Config.Language] )
			return
		end
		
		-- Add another miner to the shelf
		self:SetMinersInstalled( self:GetMinersInstalled() + 1 )

		self:SetBodygroup( self:GetMinersInstalled(), 1 )
		
		-- Update mine intervals
		self:StartMining()
		
		-- Update watts required
		self:SetWattsRequired( self:GetWattsRequired() + CH_Bitminers.Config.WattsRequiredPerMiner )
		
		SafeRemoveEntityDelayed( ent, 0 )
	elseif ent:GetClass() == "ch_bitminer_upgrade_ups" then
		if self:GetMinersAllowed() >= 16 then
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["You've reached the maximum amount of UPS upgrades for this mining shelf!"][CH_Bitminers.Config.Language] )
			return
		end
		
		self:SetMinersAllowed( self:GetMinersAllowed() + 4 )
		self:SetBodygroup( 17, self:GetMinersAllowed() / 4 )
		
		self:SetUPSInstalled( self:GetUPSInstalled() + 1 )
		
		SafeRemoveEntityDelayed( ent, 0 )
	elseif ent:GetClass() == "ch_bitminer_upgrade_cooling1" or ent:GetClass() == "ch_bitminer_upgrade_cooling2" or ent:GetClass() == "ch_bitminer_upgrade_cooling3" then
		if self:GetFansInstalled() >= 3 then
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["You've reached the highest level of ventilation on your miner."][CH_Bitminers.Config.Language] )
			return
		end

		if self:GetFansInstalled() < ent.CoolingLevel then
			self:SetFansInstalled( ent.CoolingLevel )
		
			self:SetBodygroup( 18, self:GetFansInstalled() )
		
			SafeRemoveEntityDelayed( ent, 0 )
		else
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["Your miner has a better ventilation system installed!"][CH_Bitminers.Config.Language] )
			return
		end
	elseif ent:GetClass() == "ch_bitminer_upgrade_rgb" then
		if not self:GetRGBInstalled() then
			self:SetRGBInstalled( true )
			self:SetSkin( 3 )
			
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["RGB lightning upgrade has been successfully installed!"][CH_Bitminers.Config.Language] )
			
			SafeRemoveEntityDelayed( ent, 0 )
		else
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["Your shelf already has RGB lights installed!"][CH_Bitminers.Config.Language] )
		end
	end
end

function ENT:WithdrawMoney( ply, remotely )
	if self:GetBitcoinsMined() > 0 then
		sound.Play( "buttons/lever8.wav", self:GetPos() )
		
		local bitcoin_rate = CH_Bitminers.Config.BitcoinRate
		local money_to_withdraw = math.Round( self:GetBitcoinsMined() * bitcoin_rate )

		-- Exchange bitcoins to money
		self:SetBitcoinsMined( 0 )
		ply:addMoney( money_to_withdraw )

		DarkRP.notify( ply, 1, 5,  DarkRP.formatMoney( money_to_withdraw ).." ".. CH_Bitminers.Config.Lang["has been withdrawn from the bitminer!"][CH_Bitminers.Config.Language] )

		-- Give experience support for Vronkadis DarkRP Level System
		if CH_Bitminers.Config.DarkRPLevelSystemEnabled then
			ply:addXP( CH_Bitminers.Config.WithdrawXPAmount, true )
		end

		-- Give experience support for Sublime Levels
		if CH_Bitminers.Config.SublimeLevelSystemEnabled then
			ply:SL_AddExperience( CH_Bitminers.Config.WithdrawXPAmount, "for exchanging bitcoins.")
		end
		
		if CH_Bitminers.Config.EXP2SystemEnabled then
			EliteXP.CheckXP( ply, CH_Bitminers.Config.WithdrawXPAmount )
		end
		
		-- bLogs support
		hook.Run( "CH_BITMINER_PlayerWithdrawMoney", ply, money_to_withdraw )
		
		if remotely then
			-- bLogs support
			hook.Run( "CH_BITMINER_DLC_PlayerWithdrawRemotely", ply, money_to_withdraw )
		end
	else
		DarkRP.notify( ply, 1, 5,  CH_Bitminers.Config.Lang["You have no bitcoins to exchange!"][CH_Bitminers.Config.Language] )
	end
end

function ENT:PowerOn()
	self:SetIsMining( true )
	self:ResetSequence( "on" )
	
	if self:GetRGBInstalled() then
		self:SetSkin( 3 )
	else
		self:SetSkin( 1 )
	end
	
	self:StartMining()
end

function ENT:PowerOff()
	self:SetIsMining( false )
	self:ResetSequence( "off" )
	
	if self:GetRGBInstalled() then
		self:SetSkin( 2 )
		if self:GetRGBEnabled() then
			self:SetRGBEnabled( false )
		end
	else
		self:SetSkin( 0 )
	end
	
	self:StopMining()
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHealth( ( self:Health() or 100 ) - dmg:GetDamage() )
		if self:Health() <= 0 then                  
			if not IsValid( self ) then
				return
			end
			
			self:Destruct()
		end
		
		self.m_bApplyingDamage = false
	end
end

function ENT:Destruct()
	local owner = self:CPPIGetOwner()

	if CH_Bitminers.Config.ShelfExplosion and not self.IsDestroyed then
		self.IsDestroyed = true
		
		local calculated_damage = 75 + ( self:GetMinersInstalled() * 15 )

		local vPoint = self:GetPos()
		local effect_explode = ents.Create( "env_explosion" )
		if not IsValid( effect_explode ) then return end
		effect_explode:SetPos( vPoint )
		effect_explode:Spawn()
		effect_explode:SetKeyValue( "iMagnitude", calculated_damage )
		effect_explode:Fire( "Explode", 0, 0 )
		
		if CH_Bitminers.Config.CreateFireOnExplode then
			local Fire = ents.Create( "fire" )
			Fire:SetPos( vPoint )
			Fire:SetAngles( Angle( 0, 0, 0 ) )
			Fire:Spawn()
		
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["Your bitmining shelf has exploded and caught fire due to taking an excessive amount of damage!"][CH_Bitminers.Config.Language] )
		else
			DarkRP.notify( owner, 1, 5,  CH_Bitminers.Config.Lang["Your bitmining shelf has exploded due to taking an excessive amount of damage!"][CH_Bitminers.Config.Language] )
		end
	end

	self:Remove()
end

-- 76561198051291901

function ENT:OnRemove()
	self:StopMining()
	
	-- Remove temperature timer on deletion
	if timer.Exists( "bitminer_temperature_".. self:EntIndex() ) then
		timer.Remove( "bitminer_temperature_".. self:EntIndex() )
	end
	
	-- Unplug from shelf if removed
	if IsValid( self.ConnectedEntity ) then
		self.ConnectedEntity:UnplugCable( self )
	end
end

function ENT:Think()
    self:NextThink( CurTime() + 0.1 )
	return true
end