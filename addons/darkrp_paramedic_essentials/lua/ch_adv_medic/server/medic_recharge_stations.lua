-- Spawn and save recharge stations
function RECHARGE_Stations_Spawn()
	for k, v in pairs( file.Find( "craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/recharge_stations/recharge_station_*.txt", "DATA" ) ) do
		local PositionFile = file.Read( "craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/recharge_stations/".. v, "DATA" )
	
		local ThePosition = string.Explode( ";", PositionFile )
		
		local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
		local TheAngle = Angle( ThePosition[4], ThePosition[5], ThePosition[6] )

		local Recharge_Station = ents.Create( "ch_recharge_station" )
		Recharge_Station:SetPos( TheVector )
		Recharge_Station:SetAngles( TheAngle )
		Recharge_Station:Spawn()
	end
end

function RECHARGE_Stations_SavePos( ply, cmd, args )
	if ply:IsAdmin() then
		for k, v in pairs( file.Find( "craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/recharge_stations/recharge_station_*.txt", "DATA" ) ) do
			file.Delete( "craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/recharge_stations/".. v )
		end
		for k, showcase in pairs( ents.FindByClass( "ch_recharge_station" ) ) do
			local pos = string.Explode( " ", tostring( showcase:GetPos() ) )
			local ang = string.Explode( " ", tostring( showcase:GetAngles() ) )
			
			file.Write( "craphead_scripts/medic_system/".. string.lower( game.GetMap() ) .."/recharge_stations/recharge_station_".. math.random( 1, 9999999 ) ..".txt", ""..(pos[1])..";"..(pos[2])..";"..(pos[3])..";"..(ang[1])..";"..(ang[2])..";"..(ang[3]).."", "DATA" )
		end
		
		ply:ChatPrint( "All recharge stations have been saved!" )
	else
		ply:ChatPrint( "Only administrators can perform this action" )
	end
end
concommand.Add( "paramedic_rechargestation_savepos", RECHARGE_Stations_SavePos )

-- Regain Charges Timer
function ADV_MEDIC_RegainCharges()
	timer.Create( "MEDIC_RechargeRegain", CH_AdvMedic.Config.RegainTime * 60, 0, function()
		for k, ent in ipairs( ents.FindByClass( "ch_recharge_station" ) ) do
			ent:SetNWInt( "RechargesLeft", CH_AdvMedic.Config.RegainCharges )
		end
		
		if CH_AdvMedic.Config.NotifyMedics then
			for k, ply in ipairs( player.GetAll() ) do
				if table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( ply:Team() ) ) then
					DarkRP.notify( ply, 1, CH_AdvMedic.Config.NotificationTime, CH_AdvMedic.Config.Lang["The recharge stations has been refilled with new charges!"][CH_AdvMedic.Config.Language] )
				end
			end
		end
	end )
end