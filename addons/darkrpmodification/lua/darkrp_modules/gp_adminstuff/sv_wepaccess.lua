local blacklist = {
	['weapon_slovar'] = true,
	['weapon_snuphuy'] = true,
	['weapon_flechettegun'] = true,
	['weapon_vape_mega'] = true,
}



hook.Add( 'PlayerSpawnSWEP', 'gp_wepaccess', function( ply, wep, swep )

	if not ply:gp_WepAccess() then return false end

	if not ply:IsSuperAdmin() and blacklist[wep] then 
		ply:ChatAddText( Color(255, 0, 0), '[Ошибка] ', Color(255,255,255), 'Вы не можете брать это оружие.' )
		return false 
	end

	if not ply:IsSuperAdmin() then
		for k,v in pairs( player.GetAll() ) do
			v:ChatAddText( Color(255, 0, 0), '[PGRP Admin] ', Color(255,255,255), 'Администратор '..ply:Nick()..' взял оружие "'..wep..'"' )
		end
	end
	return true

end )


hook.Add( 'PlayerGiveSWEP', 'gp_wepacces', function( ply, wep, swep )

	if not ply:gp_WepAccess() then return false end

	if not ply:IsSuperAdmin() and blacklist[wep] then 
		ply:ChatAddText( Color(255, 0, 0), '[Ошибка] ', Color(255,255,255), 'Вы не можете брать это оружие.' )
		return false 
	end

	if not ply:IsSuperAdmin() then
		for k,v in pairs( player.GetAll() ) do
			v:ChatAddText( Color(255, 0, 0), '[PGRP Admin] ', Color(255,255,255), 'Администратор '..ply:Nick()..' взял оружие "'..wep..'"' )
		end
	end
	return true

end )