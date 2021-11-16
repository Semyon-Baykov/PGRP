function FIRETRUCK_AddSpawnPos( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode( " ", tostring( ply:GetPos() ) )
		local HisAngles = string.Explode( " ", tostring( ply:GetAngles() ) )
		
		file.Write( "craphead_scripts/fire_system/".. string.lower( game.GetMap()) .."/fire_trucks_spawn/firetruck_location_".. math.random( 1, 9999999 ) ..".txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( CH_FireSystem.Config.Lang["Added a new spawn point for fire trucks. The new position is now in effect!"][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "firetruck_addspawnpos", FIRETRUCK_AddSpawnPos )

function FIRETRUCK_ClearAllSpawnPos( ply )
	if ply:IsAdmin() then
		for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/fire_trucks_spawn/firetruck_location_*.txt", "DATA" ) ) do
			file.Delete( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/fire_trucks_spawn/".. v )
		end
		
		ply:ChatPrint( CH_FireSystem.Config.Lang["All fire truck spawn positions have been cleared."][CH_FireSystem.Config.Language] )
		ply:ChatPrint( CH_FireSystem.Config.Lang["Type firetruck_addspawnpos to start adding new ones!"][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "firetruck_clearallspawns", FIRETRUCK_ClearAllSpawnPos )

local CurFireTrucks = 0
net.Receive( "FIRE_CreateFireTruck", function(length, ply)
	local truck = net.ReadString()
	
	-- Check for fire truck spawns
	CH_FireSystem.FireTruckSpawns = {}
	for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/fire_trucks_spawn/firetruck_location_*.txt", "DATA" ) ) do
		table.insert( CH_FireSystem.FireTruckSpawns, v )
	end
	
	local RandomFile = table.Random( CH_FireSystem.FireTruckSpawns )
	
	if table.IsEmpty( CH_FireSystem.FireTruckSpawns ) then
		DarkRP.notify( ply, 1, 5,  CH_FireSystem.Config.Lang["The server owner has not configured any fire truck spawn positions!"][CH_FireSystem.Config.Language] )
		return
	end
	
	-- Create variables for selected truck
	local Name = CH_FireSystem.Trucks[truck].Name
	local Model = CH_FireSystem.Trucks[truck].Model
	local Script = CH_FireSystem.Trucks[truck].Script
	local Health = CH_FireSystem.Trucks[truck].Health
	local Skin = CH_FireSystem.Trucks[truck].VehicleSkin
	local AllowedTeams = CH_FireSystem.Trucks[truck].AllowedTeamNames
	local AllowedULXRanks = CH_FireSystem.Trucks[truck].ULXRanksAllowed
	
	-- Check if player can retrieve a fire truck
	if ply.HasFireTruck then
		DarkRP.notify( ply, 1, 5,  CH_FireSystem.Config.Lang["You already own a fire truck. Please remove your current one to retrieve a new one!"][CH_FireSystem.Config.Language] )
		return
	end
	
	if CurFireTrucks == CH_FireSystem.Config.MaxTrucks then
		DarkRP.notify( ply, 1, 5,  CH_FireSystem.Config.Lang["The limitation of maximum fire trucks has been reached!"][CH_FireSystem.Config.Language] )
		return
	end

	if not table.HasValue( AllowedTeams, team.GetName( ply:Team() ) ) then
		DarkRP.notify( ply, 1, 5, CH_FireSystem.Config.Lang["You can not retrieve this fire truck as a"][CH_FireSystem.Config.Language] .." ".. team.GetName( ply:Team() ) )
		return
	end
	
	if CH_FireSystem.Config.UseRequiredULXRanks then
		if not table.HasValue( AllowedULXRanks, ply:GetUserGroup() ) then
			DarkRP.notify( ply, 1, 5, CH_FireSystem.Config.Lang["You are not the required ulx rank to retrieve the"][CH_FireSystem.Config.Language].. " ".. Name )
			return
		end
	end
	
	-- If all checks are passed then spawn fire truck!
	local PositionFile = file.Read( "craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_trucks_spawn/".. RandomFile, "DATA" )
	local ThePosition = string.Explode( ";", PositionFile )
	local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
	local TheAngle = Angle( tonumber( ThePosition[4] ), ThePosition[5], ThePosition[6] )
	
	local FireTruck = ents.Create( "prop_vehicle_jeep" )
	FireTruck:SetKeyValue( "vehiclescript", Script )
	FireTruck:SetPos( TheVector )
	FireTruck:SetAngles( TheAngle )
	FireTruck:SetRenderMode( RENDERMODE_TRANSADDFRAMEBLEND )
	FireTruck:SetModel( Model )
	FireTruck:SetSkin( Skin )
	FireTruck:Spawn()
	FireTruck:Activate()
	FireTruck:SetHealth( Health ) 
	FireTruck:SetNWInt( "Owner", ply:EntIndex() )
	FireTruck:keysOwn( ply )
	FireTruck.PhysgunPickup = false
	
	net.Start( "FIRE_SendTruckModelCL" )
		net.WriteString( Model )
	net.Send( ply )
	
	ply.HasFireTruck = true
	CurFireTrucks = CurFireTrucks + 1
	
	DarkRP.notify( ply, 1, 5,  CH_FireSystem.Config.Lang["You have successfully retrieved a"][CH_FireSystem.Config.Language].. " ".. Name )
end )

net.Receive( "FIRE_RemoveFireTruck", function( length, ply )
	if ply.HasFireTruck then
		for k, ent in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
			if ent:IsFireTruck() then
				if ent:GetNWInt( "Owner" ) == ply:EntIndex() then
					ent:Remove()
					DarkRP.notify( ply, 1, 5, CH_FireSystem.Config.Lang["Your fire truck has been removed!"][CH_FireSystem.Config.Language] )
				end
			end
		end
	else
		DarkRP.notify( ply, 1, 5, CH_FireSystem.Config.Lang["You don't have a fire truck!"][CH_FireSystem.Config.Language] )
	end
end )

function FIRETRUCK_Removal( ent )
	if ent:IsFireTruck() then
		local owner = player.GetByID( ent:GetNWInt("Owner") )
		
		owner.HasFireTruck = false
		CurFireTrucks = CurFireTrucks - 1
	end
end
hook.Add( "EntityRemoved", "FIRETRUCK_Removal", FIRETRUCK_Removal )

function FIRETRUCK_JobChange( ply )
	if ply.HasFireTruck then
		for k, ent in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
			if not ply:IsFireFighter() then
				if ent:GetNWInt("Owner") == ply:EntIndex() then
					if IsValid( ent ) then
						ent:Remove()
						
						net.Start( "FIRE_SendTruckModelCL" )
							net.WriteString( "" )
						net.Send( ply )
					end
				end
			end
		end
	end
end
hook.Add( "PlayerSwitchWeapon", "FIRETRUCK_JobChange", FIRETRUCK_JobChange )

-- Add all models from firetrucks_config.lua to the necessary table.
function FIRETRUCK_AddTruckModels()
	for k, v in pairs( CH_FireSystem.Trucks ) do
		if v.Model then
			if not table.HasValue( CH_FireSystem.Config.FiretruckModels, v.Model ) then
				table.insert( CH_FireSystem.Config.FiretruckModels, v.Model )
			end
		end
	end
end