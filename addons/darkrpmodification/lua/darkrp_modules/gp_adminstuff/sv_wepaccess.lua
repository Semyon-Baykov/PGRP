local blacklist = {
	['weapon_koran_b'] = true,
	['weapon_koran'] = true,
	['brax_crowbar'] = true,
	['weapon_ak472'] = true,
	['weapon_deagle2'] = true,
	['weapon_fiveseven2'] = true,
	['weapon_glock2'] = true,
	['weapon_m42'] = true,
	['weapon_mac102'] = true,
	['weapon_mp52'] = true,
	['weapon_p2282'] = true,
	['weapon_pumpshotgun2'] = true,
	['ls_sniper'] = true,
	['weapon_frag'] = true,
	['weapon_rpg'] = true,
	['weapon_slam'] = true,
	['weapon_chainsaw_new'] = true,
	['weapon_vape_dragon'] = true,
	['weapon_vape_mega'] = true
}

function allow_wep_access (ply, wep, swep) 

	if not ply:gp_WepAccess() then return false end
--[[
	if not ply:gp_IsSuperAdmin()() and blacklist[wep] then 
		ply:ChatAddText( Color( 139, 0, 0 ), '[Ошибка] ', Color(255,255,255), 'Вы не можете брать это оружие.' )
		return false 
	end
--]]
	for k,v in pairs( player.GetAll() ) do
		v:ChatAddText( Color( 139, 0, 0 ), '[PGRP Admin] ', Color(255,255,255), 'Администратор '..ply:Nick()..' взял оружие "'..wep..'"' )
	end
	return true
end


hook.Add( 'PlayerSpawnSWEP', 'gp_wepaccess', allow_wep_access )
hook.Add( 'PlayerGiveSWEP', 'gp_wepacces', allow_wep_access )