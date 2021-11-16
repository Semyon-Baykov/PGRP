function FIRESYSTEM_Disconnect( ply )
	if ply:IsFireFighter() then
		for k, ent in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
			if ent:IsFireTruck() then
				if ent:GetNWInt( "Owner" ) == ply:EntIndex() then
					ent:Remove()
				end
			end
		end
	end
	
	timer.Simple( 1, function()
		if CH_FireSystem.Config.RemoveAllOnLastDC then
			if #player.GetAll() == 0 then
				for k, v in pairs( ents.FindByClass( "fire" ) ) do
					v:KillFire()
				end
			end
		end
	end )
end
hook.Add( "PlayerDisconnected", "FIRESYSTEM_Disconnect", FIRESYSTEM_Disconnect )

function FIRESYSTEM_PlayerCanPickupMolotov( ply, wep )
	if ply:HasWeapon( "fire_molotov" ) then
		if wep:GetClass() == "fire_molotov" then 
			return false 
		end
	end

	return true
end
hook.Add( "PlayerCanPickupWeapon", "FIRESYSTEM_PlayerCanPickupMolotov", FIRESYSTEM_PlayerCanPickupMolotov )

function FIRESYSTEM_FFChangeTeam( ply, before, after )
	if not CH_FireSystem.Config.ExtinguishAllFiresOnFFLeave then
		return
	end
	
	timer.Simple( 1, function()
		local TotalPlayers = 0
		local TotalFFCount = 0
		
		for k, v in pairs( player.GetAll() ) do
			TotalPlayers = TotalPlayers + 1

			if v:IsFireFighter() then
				TotalFFCount = TotalFFCount + 1
			end

			if TotalPlayers == #player.GetAll() then
				if TotalFFCount == 0 then
					-- Turn off all fires
					for k, v in pairs( ents.FindByClass( "fire" ) ) do
						v:KillFire()
					end
				end
			end
		end
	end)
end
hook.Add( "OnPlayerChangedTeam", "FIRESYSTEM_FFChangeTeam", FIRESYSTEM_FFChangeTeam ) -- DarkRP Special Hook (2.5.0+ Only)

local function FIRESYSTEM_RespawnEntsCleanup()
   print( "[DarkRP Fire System] - Map cleaned up. Respawning extinguisher cabinets and firetruck NPC..." )

   timer.Simple( 1, function()
		FIRE_ExtCabinetsSpawn()
		FIRE_TruckNPC_Spawn()
   end )
end
hook.Add( "PostCleanupMap", "FIRESYSTEM_RespawnEntsCleanup", FIRESYSTEM_RespawnEntsCleanup )