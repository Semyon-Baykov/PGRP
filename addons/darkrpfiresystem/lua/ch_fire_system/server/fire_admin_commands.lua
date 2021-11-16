function FIRE_CreateFire( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint( CH_FireSystem.Config.Lang["Please choose a unique name for the fire!"][CH_FireSystem.Config.Language] ) 
			return
		end
		
		if file.Exists( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_".. FileName ..".txt", "DATA" ) then 
			ply:ChatPrint( CH_FireSystem.Config.Lang["This file name is already in use. Please choose another name for this location of fire."][CH_FireSystem.Config.Language] )
			return
		end
		
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_".. FileName ..".txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( CH_FireSystem.Config.Lang["New fire location created!"][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "ch_create_fire", FIRE_CreateFire )

function FIRE_RemoveFire( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint( CH_FireSystem.Config.Lang["Please enter a filename!"][CH_FireSystem.Config.Language] ) 
			return
		end
		
		if file.Exists( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_".. FileName ..".txt", "DATA" ) then
			file.Delete( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_".. FileName ..".txt" )
			ply:ChatPrint( CH_FireSystem.Config.Lang["The selected fire has been removed!"][CH_FireSystem.Config.Language] )
		else
			ply:ChatPrint( CH_FireSystem.Config.Lang["The selected fire does not exist!"][CH_FireSystem.Config.Language] )
		end
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "ch_remove_fire", FIRE_RemoveFire )

function FIRE_RemoveFireAll( ply, cmd, args )
	if ply:IsAdmin() then
		for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/fire_location_*.txt", "DATA" ) ) do
			file.Delete( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/".. v )
		end
		
		ply:ChatPrint( CH_FireSystem.Config.Lang["Successfully deleted all fire locations!"][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "ch_remove_fire_all", FIRE_RemoveFireAll )

function FIREADMIN_FireOff( ply )
	if ply:IsAdmin() then
		for k, v in pairs( ents.FindByClass( "fire" ) ) do
			v:KillFire()
		end
		
		ply:ChatPrint( CH_FireSystem.Config.Lang["[ADMIN FIRE] All fires have been turned off."][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "adminfire_fireoff", FIREADMIN_FireOff )

function FIREADMIN_SpawnFire( ply )
	if ply:IsAdmin() then
		local trace = ply:GetEyeTrace()
		
		local Fire = ents.Create( "fire" )
		Fire:SetPos(trace.HitPos)
		Fire:Spawn()
		
		ply:ChatPrint( CH_FireSystem.Config.Lang["[ADMIN FIRE] Fire created at your aim of sight."][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "adminfire_spawnfire", FIREADMIN_SpawnFire )

function FIREADMIN_ValidFires( ply )
	if ply:IsAdmin() then
		ply:ChatPrint( "[ADMIN FIRE] NAMES OF VALID FIRES:" )
		
		for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_*.txt", "DATA" ) ) do
			local PosFile = file.Read("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/".. v, "DATA")
			local ThePos = string.Explode( ";", PosFile )
			local ThePrintPos = ThePos[1], ThePos[2], ThePos[3]
			
			ply:ChatPrint( "[ADMIN FIRE] File Name: ".. v .." - Fire Position: ".. ThePrintPos )
		end
		ply:ChatPrint( CH_FireSystem.Config.Lang["[ADMIN FIRE] REMOVING FIRE: YOU ONLY USE THE LAST OF THE FILE NAME."][CH_FireSystem.Config.Language] )
		ply:ChatPrint( CH_FireSystem.Config.Lang["[ADMIN FIRE] SO IF A FILE NAME IS CALLED 'FIRE_LOCATION_TRAIN', THEN YOU WOULD USE 'CH_REMOVE_FIRE TRAIN' TO REMOVE IT!"][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "adminfire_validfire", FIREADMIN_ValidFires )

function FIREADMIN_StartAll( ply )
	if ply:IsAdmin() then
		for k, v in pairs(file.Find("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_*.txt", "DATA")) do
			if CH_FireSystem.CurrentFires >= CH_FireSystem.Config.MaxFires then 
				return 
			end
			
			local Randomize = 2
			if CH_FireSystem.Config.RandomizeFireSpawn then
				Randomize = math.random(1,2)
			end
			
			if tonumber( Randomize ) == 2 then
				local PositionFile = file.Read("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/".. v, "DATA")
					
				local ThePosition = string.Explode( ";", PositionFile )
					
				local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
				local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])

				local Fire = ents.Create( "fire" )
				Fire:SetPos(TheVector)
				Fire:SetAngles(TheAngle)
				Fire:Spawn()
			end
		end
		ply:ChatPrint( CH_FireSystem.Config.Lang["[ADMIN FIRE] You have started all fires at all set spawn locations."][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "adminfire_startall", FIREADMIN_StartAll )

function FIREADMIN_CurrentFires( ply )
	if ply:IsAdmin() then
		ply:ChatPrint( CH_FireSystem.Config.Lang["[ADMIN FIRE] Amount of active fires:"][CH_FireSystem.Config.Language] .." ".. CH_FireSystem.CurrentFires )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add("adminfire_fireamount", FIREADMIN_CurrentFires)
-- 76561197989440650