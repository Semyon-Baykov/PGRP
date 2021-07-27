local blacklist = {
	['freshcardealer'] = true,
	['chopshop'] = true,
	['medgovcar'] = true,
	['money_printer'] = true,
	['omongovcar'] = true,
	['policegovcar'] = true,
	['rggovcar'] = true,
	['rg'] = true,
	['eblannpc2'] = true,
	['buyer'] = true, 
	['buyoutent'] = true,
	['givable_license'] = true,
	['dumpster'] = true,
	['gift'] = true,
	['eblannpc'] = true,
	['gasmask_bag'] = true,
	['gp_ore'] = true,
	['buyer1'] = true,
	['brax_atm'] = true,
	['ent_ars'] = true,
	['prop_thumper'] = true,
	['boyar_vendingmachine'] = true,
	['edit_fog'] = true,
	['edit_sky'] = true,
	['edit_sun'] = true,
	['entity_dshk'] = true
}



hook.Add( 'PlayerSpawnSENT', 'gp_sentaccess', function( ply, name )

	if ( string.sub( string.lower( name ), 1, 9 ) == "gmod_wire" ) then
		return true
	end
	if ( string.sub( string.lower( name ), 1, 15 ) == "darkrp_moneypot" ) then
		return true
	end
	if not ply:gp_SentAccess() then return false end

	if not ply:IsSuperAdmin() and blacklist[name] then 
		ply:ChatAddText( Color(255, 0, 0), '[Ошибка] ', Color(255,255,255), 'Вы не можете использовать данный предмет.' )
		return false 
	end
	return true

end )