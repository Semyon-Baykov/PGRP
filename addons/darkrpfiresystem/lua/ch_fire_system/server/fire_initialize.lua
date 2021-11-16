print( "SV - Crap-Head's Fire System Initialized" )

resource.AddWorkshop( "1598105059" ) -- Script content

-- Initialize net library
util.AddNetworkString( "FIRE_SendTruckModelCL" )
util.AddNetworkString( "FIRE_CreateFireTruck" )
util.AddNetworkString( "FIRE_RemoveFireTruck" )

function FIRESYSTEM_InitializeAddon()
	timer.Simple( 3, function()
		if not file.IsDir( "craphead_scripts", "DATA" ) then
			file.CreateDir( "craphead_scripts", "DATA" )
		end

		if not file.IsDir( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/", "DATA" ) then
			file.CreateDir( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."", "DATA" )
		end

		if not file.IsDir( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/fire_trucks_spawn", "DATA" ) then
			file.CreateDir( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/fire_trucks_spawn", "DATA" )
		end
		
		if not file.IsDir( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets", "DATA" ) then
			file.CreateDir( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets", "DATA" )
		end

		FIRE_CreateFireSpawns()
		FIRE_ExtCabinetsSpawn()
		
		FIRETRUCK_AddTruckModels()
	end )
end
hook.Add( "Initialize", "FIRESYSTEM_InitializeAddon", FIRESYSTEM_InitializeAddon )

function FIRE_CreateFireSpawns()
	timer.Create( "FIRE_CreateTimer", CH_FireSystem.Config.RandomFireInterval, 0, function()
		local TeamsRequiredCount = 0
		local TotalPlayerCount = 0
		
		for k, v in pairs( player.GetAll() ) do
			TotalPlayerCount = TotalPlayerCount + 1

			if v:IsFireFighter() then
				TeamsRequiredCount = TeamsRequiredCount + 1
			end

			if TotalPlayerCount == #player.GetAll() then
				if TeamsRequiredCount < CH_FireSystem.Config.FireFightersRequired then
					return
				end
			end
		end
		
		if CH_FireSystem.CurrentFires <= 0 then	
			for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_*.txt", "DATA" ) ) do
				if CH_FireSystem.CurrentFires >= CH_FireSystem.Config.MaxFires then 
					return
				end

				local Randomize = 2
				if CH_FireSystem.Config.RandomizeFireSpawn then
					Randomize = math.random( 1, 2 )
				end
				
				if tonumber( Randomize ) == 2 then
					local PositionFile = file.Read( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/".. v, "DATA" )
				
					local ThePosition = string.Explode( ";", PositionFile )
					
					local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
					local TheAngle = Angle( tonumber(ThePosition[4]), ThePosition[5], ThePosition[6] )

					local Fire = ents.Create( "fire" )
					Fire:SetPos( TheVector )
					Fire:SetAngles( TheAngle )
					Fire:Spawn()
				end
			end
		end
	end )
end

-- Advanced Weapons DLC (Fire Hose)
function FIREADV_GiveFireHose( ply, before, after )
	if CH_FIRE_WeaponsDLC then
		timer.Simple( 0.5, function()
			if IsValid( ply ) then
				if ply:IsFireFighter() then
					ply:Give( "fire_hose" )
				end
			end
		end )
	end
end
hook.Add( "OnPlayerChangedTeam", "FIREADV_GiveFireHose", FIREADV_GiveFireHose )
hook.Add( "PlayerSpawn", "FIREADV_GiveFireHose", FIREADV_GiveFireHose )