AddCSLuaFile()
if SERVER then
	if not ConVarExists("sp_damage") then CreateConVar( "sp_damage", "0", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
	if not ConVarExists("sp_arrest") then CreateConVar( "sp_arrest", "0", {FCVAR_NOTIFY,FCVAR_REPLICATED, FCVAR_ARCHIVE} ) end
end

local pos1
local pos2

-- Setup (via commands)
local function (ply)
	ply:PrintMessage( 2, "Check your chat!" )
	ply:ChatAddText( Color( 139, 0, 0 ), '[SPAWN ZONE SETUP] ', Color( 255, 255, 255 ), "" )
	ply:ChatAddText( Color( 139, 0, 0 ), "The setup is simple. All you need to figure out is where your safe-zone will be." )
	ply:ChatAddText( Color( 139, 0, 0 ), "Imagine your zone as a square. What you need is a ", Color( 200, 0, 0 ), "TOP LEFT corner" )
	ply:ChatAddText( Color( 139, 0, 0 ), "and a ", Color( 200, 0, 0 ), "BOTTOM RIGHT corner" )
end
concommand.Add( "sp_start_setup", sp_init )

-- Damage (and death) protection
function spawn_protect_damage (ply, attacker) 
	
	if GetConVarNumber("sp_damage") != 0 or not IsValid(ply) or not IsValid(attacker) then return true end
	
	for k, v in pairs( ents.FindInBox(pos1, pos2) ) do
		if ply == v then
			attacker:ChatAddText( Color( 139, 0, 0 ), '[Spawn-Zone] ', Color( 255, 255, 255 ), "You can't hurt someone inside the spawn zone!" )
			return false
		end
		if attacker == v then
			attacker:ChatAddText( Color( 139, 0, 0 ), '[Spawn-Zone] ', Color( 255, 255, 255 ), "You can't hurt someone while you are inside the spawn zone!" )
			return false
		end
	end
	return true
	
end
hook.Add("PlayerShouldTakeDamage", "SpawnProtect_dmg", spawn_protect_damage)

-- Arrest protection
function spawn_protect_arrest (arrester, arrestee)
	
	if GetConVarNumber("sp_arrest") != 0 or not IsValid(arrester) or not IsValid(arrestee) then return true end
	
	for k, v in pairs( ents.FindInBox(pos1, pos2) ) do
		if arrestee == v then
			arrester:ChatAddText( Color( 139, 0, 0 ), '[Spawn-Zone] ', Color( 255, 255, 255 ), "You can't arrest someone in the spawn zone!" )
			return false, "You can't arrest someone in the spawn zone!"
		end
	end
	return true
	
end
hook.Add("canArrest", "SpawnProtect_arr", spawn_protect_arrest)