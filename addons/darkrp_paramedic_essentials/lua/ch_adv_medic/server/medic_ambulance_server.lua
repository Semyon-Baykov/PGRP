local CurAmbulances = 0

local function MEDIC_Ambulance_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/medic_system/".. string.lower(game.GetMap()) .."/ambulance_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint("New position for the ambulance has been succesfully set. The new position is now in effect!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add( "paramedic_ambulance_setpos", MEDIC_Ambulance_Position )

net.Receive( "ADV_MEDIC_CreateAmbulance", function( length, ply )
	if ( ply.CH_ADV_MEDIC_NetRateLimit or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ADV_MEDIC_NetRateLimit = CurTime() + 1.5
	
	if not table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
		return
	end
	
	if ply.HasAmbulance then
		DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You already own an ambulance!"][CH_AdvMedic.Config.Language] )
		return
	end
	
	if CurAmbulances == CH_AdvMedic.Config.MaxTrucks then
		DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["The limitation of maximum ambulances has been reached!"][CH_AdvMedic.Config.Language] )
		return
	end
	
	DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You have succesfully retrieved an ambulance! It's parked right outside the building."][CH_AdvMedic.Config.Language] )
	
	-- Update variables
	ply.HasAmbulance = true
	CurAmbulances = CurAmbulances + 1
	
	-- Spawn ambulance truck
	
	local PositionFile = file.Read("craphead_scripts/medic_system/".. string.lower(game.GetMap()) .."/ambulance_location.txt", "DATA")
	local ThePosition = string.Explode( ";", PositionFile )
	local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
	local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
	
	local AmbulanceTruck = ents.Create( "prop_vehicle_jeep" )
	AmbulanceTruck:SetKeyValue( "vehiclescript", CH_AdvMedic.Config.VehicleScript )
	AmbulanceTruck:SetPos( TheVector )
	AmbulanceTruck:SetAngles( TheAngle )
	AmbulanceTruck:SetRenderMode( RENDERMODE_TRANSADDFRAMEBLEND )
	AmbulanceTruck:SetModel( CH_AdvMedic.Config.VehicleModel )
	AmbulanceTruck:Spawn()
	AmbulanceTruck:SetSkin( CH_AdvMedic.Config.VehicleSkin )
	AmbulanceTruck:Activate()
	AmbulanceTruck:SetHealth( CH_AdvMedic.Config.AmbulanceHealth ) 
	AmbulanceTruck:SetNWInt( "Owner", ply:EntIndex() )
	AmbulanceTruck:keysOwn( ply )
	
	-- Setup lights (disabled if vcmod, etc)
	AmbulanceTruck.Lights = {}
	local TruckLight = ents.Create("ambulance_siren")
	TruckLight:SetPos( AmbulanceTruck:GetPos() + Vector( 0, 50, 120 ) )
	TruckLight:SetParent( AmbulanceTruck )
	TruckLight:Spawn()
	table.insert( AmbulanceTruck.Lights, TruckLight )
	
	-- Run hook
	hook.Run( "PlayerSpawnedVehicle", ply, AmbulanceTruck )
end )

net.Receive( "ADV_MEDIC_RemoveAmbulance", function( length, ply )
	if ( ply.CH_ADV_MEDIC_NetRateLimit or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ADV_MEDIC_NetRateLimit = CurTime() + 1.5
	
	if not table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
		return
	end

	if ply.HasAmbulance then
		for k, ent in ipairs( ents.GetAll() ) do
			if ent:GetModel() == CH_AdvMedic.Config.VehicleModel then
				if ent:GetNWInt( "Owner" ) == ply:EntIndex() then
					ent:Remove()
					DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["Your current ambulance has been removed!"][CH_AdvMedic.Config.Language] )
				end
			end
		end
	else
		DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["You don't have an ambulance!"][CH_AdvMedic.Config.Language] )
	end
end )

local function AMBULANCE_Removal( ent )
	if ent:GetModel() == CH_AdvMedic.Config.VehicleModel then
		player.GetByID( ent:GetNWInt("Owner") ).HasAmbulance = false
		CurAmbulances = CurAmbulances - 1
	end
end
hook.Add( "EntityRemoved", "AMBULANCE_Removal", AMBULANCE_Removal )

local function AMBULANCE_Disconnect( ply )
	for k, ent in ipairs( ents.GetAll() ) do
		if ent:GetModel() == CH_AdvMedic.Config.VehicleModel then
			if ent:GetNWInt( "Owner" ) == ply:EntIndex() then
				ent:Remove()
			end
		end
	end
end
hook.Add("PlayerDisconnected", "AMBULANCE_Disconnect", AMBULANCE_Disconnect)

local function AMBULANCE_JobChange( ply )
	for k, ent in ipairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
		if not table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
			if ply.HasAmbulance then
				if ent:GetNWInt( "Owner" ) == ply:EntIndex() then
					if ent:IsValid() then
						ent:Remove()
					end
				end
			end
		end
	end
end
hook.Add( "PlayerSwitchWeapon", "AMBULANCE_JobChange", AMBULANCE_JobChange )