local function ADV_MEDIC_GiveWeapons( ply, before, after )
	timer.Simple( 0.5, function()
		if IsValid( ply ) then
			if ply:HasWeapon( "med_kit" ) then -- Strip default darkrp health kit.
				ply:StripWeapon( "med_kit" )
			end
			
			if table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then -- Give new medkit to medic teams
				ply:Give( "med_kit_advanced" )
				ply:Give( "defibrillator_advanced" )
			end
		end
	end )
end
hook.Add( "OnPlayerChangedTeam", "ADV_MEDIC_GiveWeapons", ADV_MEDIC_GiveWeapons ) -- DarkRP Special Hook (2.5.0+ Only)
hook.Add( "PlayerSpawn", "ADV_MEDIC_GiveWeapons", ADV_MEDIC_GiveWeapons )

local function ADV_MEDIC_RespawnEntCleanup()
	print( "[Paramedic Essentials] - Map cleaned up. Respawning entities..." )

	timer.Simple( 1, function()
		RECHARGE_Stations_Spawn()
		MEDIC_HealthNPC_Spawn()
		MEDIC_TruckNPC_Spawn()
	end )
end
hook.Add( "PostCleanupMap", "ADV_MEDIC_RespawnEntCleanup", ADV_MEDIC_RespawnEntCleanup )