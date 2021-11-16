print( "[Paramedic Essentials] - Initializing addon..." )
-- Resources
--resource.AddWorkshop( "343729375" ) -- [LW] Ford F350 Ambulance
--resource.AddWorkshop( "1980971647" ) -- Script Content

-- Net messages
util.AddNetworkString( "ADV_MEDIC_DEFIB_UpdateSeconds" )

util.AddNetworkString( "ADV_MEDIC_AmbulanceMenu" )

util.AddNetworkString( "ADV_MEDIC_CreateAmbulance" )
util.AddNetworkString( "ADV_MEDIC_RemoveAmbulance" )

util.AddNetworkString( "ADV_MEDIC_HealthMenu" )
util.AddNetworkString( "ADV_MEDIC_PurchaseHealth" )
util.AddNetworkString( "ADV_MEDIC_PurchaseArmor" )

local map = string.lower( game.GetMap() )

-- Initialize script
function ADV_MEDIC_Initialize()
	timer.Simple( 2, function()
		-- Default file locations
		if not file.IsDir( "craphead_scripts", "DATA" ) then
			file.CreateDir( "craphead_scripts", "DATA" )
		end
		
		if not file.IsDir( "craphead_scripts/medic_system/".. map .."", "DATA" ) then
			file.CreateDir( "craphead_scripts/medic_system/".. map .."", "DATA" )
		end
		
		-- Ambulance NPC
		if not file.Exists( "craphead_scripts/medic_system/".. map .."/ambulancenpc_location.txt", "DATA" ) then
			file.Write("craphead_scripts/medic_system/".. map .."/ambulancenpc_location.txt", "0;-0;-0;0;0;0", "DATA" )
		end
		
		-- Create ambulance spawn pos file
		if not file.Exists( "craphead_scripts/medic_system/".. map .."/ambulance_location.txt", "DATA" ) then
			file.Write( "craphead_scripts/medic_system/".. map .."/ambulance_location.txt", "0;-0;-0;0;0;0", "DATA" )
		end
		
		-- Recharge Station
		if not file.IsDir( "craphead_scripts/medic_system/".. map .."/recharge_stations/", "DATA" ) then
			file.CreateDir( "craphead_scripts/medic_system/".. map .."/recharge_stations/", "DATA" )
		end
		
		-- Health NPC
		if not file.Exists( "craphead_scripts/medic_system/".. map .."/healthnpc_location.txt", "DATA" ) then
			file.Write( "craphead_scripts/medic_system/".. map .."/healthnpc_location.txt", "0;-0;-0;0;0;0", "DATA" )
		end
		
		RECHARGE_Stations_Spawn()
		ADV_MEDIC_RegainCharges()
		
		-- Spawn NPCs
		MEDIC_HealthNPC_Spawn()
		MEDIC_TruckNPC_Spawn()
	end )
end
hook.Add( "Initialize", "ADV_MEDIC_Initialize", ADV_MEDIC_Initialize )

print( "[Paramedic Essentials] - Addon successfully initialized!" )