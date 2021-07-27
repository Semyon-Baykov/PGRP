function CH_BITMINERS_RandomizeBitcoinRate()
	timer.Create( "ch_bitminers_randomize_rate", CH_Bitminers.Config.RateRandomizeInterval, 0, function()
		local current_rate = CH_Bitminers.Config.BitcoinRate
		local randomized_change = math.random( -CH_Bitminers.Config.RateUpdateInterval, CH_Bitminers.Config.RateUpdateInterval )
		
		-- Update bitcoin rate
		CH_Bitminers.Config.BitcoinRate = math.Clamp( CH_Bitminers.Config.BitcoinRate + randomized_change, CH_Bitminers.Config.MinBitcoinRate, CH_Bitminers.Config.MaxBitcoinRate )

		-- Network bitcoin rate
		net.Start( "CH_BITMINERS_UpdateBitcoinRates" )
			net.WriteUInt( CH_Bitminers.Config.BitcoinRate, 20 )
		net.Broadcast()
	end )
end

-- Delete bitminer entities on disconnect/team change if enabled.
--[[local function CH_BITMINERS_RemoveAllEntitiesDC( ply )
	if CH_Bitminers.Config.RemoveEntsOnDC then
		for k, v in ipairs( ents.GetAll() ) do
			if table.HasValue( CH_Bitminers.ListOfEntities, v:GetClass() ) then
				local ent_owner = v:CPPIGetOwner()
				
				if ent_owner == ply then
					v:Remove()
				end
			end
		 end
	end
end
hook.Add( "PlayerDisconnected", "CH_BITMINERS_RemoveAllEntitiesDC", CH_BITMINERS_RemoveAllEntitiesDC ) --]]

local function CH_BITMINERS_RemoveAllEntitiesTeamChange( ply, before, after )
	if CH_Bitminers.Config.RemoveEntsOnTeamChange then
		for k, v in ipairs( ents.GetAll() ) do
			if table.HasValue( CH_Bitminers.ListOfEntities, v:GetClass() ) then
				local ent_owner = v:CPPIGetOwner()

				if ent_owner == ply then
					v:Remove()
				end
			end
		 end
	end
end
hook.Add( "OnPlayerChangedTeam", "CH_BITMINERS_RemoveAllEntitiesTeamChange", CH_BITMINERS_RemoveAllEntitiesTeamChange )