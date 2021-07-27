AddCSLuaFile()
if SERVER then
	if not ConVarExists("pgrp_sp_damage") then CreateConVar( "pgrp_sp_damage", "0", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("pgrp_sp_arrest") then CreateConVar( "pgrp_sp_arrest", "0", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end

local pos1 = Vector(-2217.969482, -2449.479736, -195.652191)
local pos2 = Vector(-2807.336426, -2768.805176, 26.923752)


function spawn_protect_damage (ply, attacker) 
	
	if GetConVarNumber("pgrp_sp_damage") != 0 or not IsValid(ply) or not IsValid(attacker) then return true end
	
	for k, v in pairs( ents.FindInBox(pos1, pos2) ) do
		if ply == v then
			attacker:ChatAddText( Color( 139, 0, 0 ), '[PGRP-spawn] ', Color( 255, 255, 255 ), 'Вы не можете наносить дамаг игроку на спавне!' )
			return false
		end
		if attacker == v then
			attacker:ChatAddText( Color( 139, 0, 0 ), '[PGRP-spawn] ', Color( 255, 255, 255 ), 'Вы не можете наносить дамаг игроку со спавна!' )
			return false
		end
	end
	return true
	
end

function spawn_protect_arrest (arrester, arrestee)
	
	if GetConVarNumber("pgrp_sp_arrest") != 0 or not IsValid(arrester) or not IsValid(arrestee) then return true end
	
	for k, v in pairs( ents.FindInBox(pos1, pos2) ) do
		if arrestee == v then
			arrester:ChatAddText( Color( 139, 0, 0 ), '[PGRP-spawn] ', Color( 255, 255, 255 ), 'Вы не можете арестовывать на спавне!' )
			return false, "Вы не можете арестовывать на спавне"
		end
	end
	return true
	
end


hook.Add("PlayerShouldTakeDamage", "SpawnProtect_dmg", spawn_protect_damage)
hook.Add("canArrest", "SpawnProtect_arr", spawn_protect_arrest)