function FIRE_ExtCabinetsSpawn()
	for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets/ext_cabinet_*.txt", "DATA" ) ) do
		local PositionFile = file.Read( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets/".. v, "DATA" )

		local ThePosition = string.Explode( ";", PositionFile )

		local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
		local TheAngle = Angle( ThePosition[4], ThePosition[5], ThePosition[6] )

		local Extinguisher_Cabinet = ents.Create( "ch_fire_extinguisher_cabinet" )
		Extinguisher_Cabinet:SetPos( TheVector )
		Extinguisher_Cabinet:SetAngles( TheAngle )
		Extinguisher_Cabinet:Spawn()
	end
end

function FIRE_ExtCabinets_SavePos( ply, cmd, args )
	if ply:IsAdmin() then
		for k, v in pairs( file.Find( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets/ext_cabinet_*.txt", "DATA" ) ) do
			file.Delete( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets/".. v )
		end
		for k, cabinet in pairs( ents.FindByClass( "ch_fire_extinguisher_cabinet" ) ) do
			local pos = string.Explode( " ", tostring( cabinet:GetPos() ) )
			local ang = string.Explode( " ", tostring( cabinet:GetAngles() ) )
			
			file.Write( "craphead_scripts/fire_system/".. string.lower( game.GetMap() ) .."/extinguisher_cabinets/ext_cabinet_".. math.random( 1, 9999999 ) ..".txt", ""..(pos[1])..";"..(pos[2])..";"..(pos[3])..";"..(ang[1])..";"..(ang[2])..";"..(ang[3]).."", "DATA" )
		end

		ply:ChatPrint( CH_FireSystem.Config.Lang["All fire extinguisher cabinets have been saved!"][CH_FireSystem.Config.Language] )
	else
		ply:ChatPrint( CH_FireSystem.Config.Lang["Only administrators can perform this action!"][CH_FireSystem.Config.Language] )
	end
end
concommand.Add( "fire_ext_cabinets_savepos", FIRE_ExtCabinets_SavePos )