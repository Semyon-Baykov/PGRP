local blacklist = {
	['Airboat'] = true,
	['Jeep'] = true
}



hook.Add( 'PlayerSpawnVehicle', 'gp_vehaccess', function( ply, model, name )

	if not ply:gp_VehAccess() then return false end

	if not ply:IsSuperAdmin() and blacklist[name] then 
		ply:ChatAddText( Color(255, 0, 0), '[Ошибка] ', Color(255,255,255), 'Вы не можете вызвать данный транспорт.' )
		return false 
	end
	return true

end )