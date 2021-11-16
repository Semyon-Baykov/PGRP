local blacklist = {
	['Airboat'] = true,
	['Jeep'] = true,
	['sim_fphys_couch'] = true,
	['drb_gopnik_drift'] = true,
	['sim_fphys_mer_cedes_benz_gt63s_amg_notwhite'] = true,
	['sim_fphys_mer_cedes_benz_gt63s_amg'] = true,
	['sim_fphys_jeep'] = true,
	['sim_fphys_jalopy'] = true,
	['sim_fphys_combineapc'] = true
}



hook.Add( 'PlayerSpawnVehicle', 'gp_vehaccess', function( ply, model, name )
	if not ply:gp_VehAccess() then 
		return false 
	elseif ply:GetUserGroup() == 'superadmin' or ply:GetUserGroup() == 'sponsor+' then
		return true
	else
		-- Check bl
		if blacklist[name] then 
			ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-qspawn] ', Color( 255, 255, 255 ), 'Данный автомобиль нельзя заспавнить, попробуйте другой!' )
			return false 
		end
		-- Notify the players
		local nick = ply:Nick()
		for k, v in ipairs( ents.FindByClass("player") ) do
			v:ChatAddText( Color( 139, 0, 0 ), '[PGRP Admin] ', Color( 255, 255, 255 ), 'Администратор ', nick, ' заспавнил автомобиль: ', name )
		end
		-- Allow the spawn
		return true
	end
end )