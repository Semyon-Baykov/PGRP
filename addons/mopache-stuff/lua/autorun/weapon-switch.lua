AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_weapon_switch_script") then CreateConVar( "pgrp_weapon_switch_script", "1", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end


function weapon_switch_script(ply, old, new)
	if GetConVarNumber("pgrp_weapon_switch_script") == 0 then return end
	
	-- First, we have to check if the weapon is something to worry about
	if new == "crowbar" then end
	
	-- Now, we check if there is a policeman looking at a player with a weapon
	if not check_if_player_scoped() then return end
	
	-- Now, we are ready to proceed with the fearrp protection
	
end


hook.Add("PlayerSwitchWeapon", "pg_fearrp_weapon_switch_script", weapon_switch_script )