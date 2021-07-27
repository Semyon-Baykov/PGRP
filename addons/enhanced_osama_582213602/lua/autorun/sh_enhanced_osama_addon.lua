
AddCSLuaFile()

-------------------------------------------------------
--	Enhanced Osama bin Laden Addon
--	Model @ Kuma Games
--	Hex/Player/NPC/C_Arms/Enhance @ V92
-------------------------------------------------------
--	Let's get moving...
-------------------------------------------------------
-------------------------------------------------------
if !ConVarExists("VNT_Debug_Prints") then	CreateClientConVar( "VNT_Debug_Prints", '0', true, false )	end
-------------------------------------------------------
-------------------------------------------------------
--	Setting up Workshop Auto-DL just in case...
-------------------------------------------------------
-------------------------------------------------------
if SERVER then	
	-- resource.AddWorkshop("136077464")	--	NPCG
	resource.AddWorkshop("582213602")	--	Enhanced Osama
end

-------------------------------------------------------
-------------------------------------------------------
--	Player Shit
-------------------------------------------------------
-------------------------------------------------------
local function AddPlayerModel( name, model )
	player_manager.AddValidModel( name, model )	
end

local function AddPlayerHands( name, model, skin, bodygroup )
	player_manager.AddValidHands( name, model, skin, bodygroup )
end

AddPlayerModel("OsamaEnhanced", "models/jessev92/kuma/characters/osama_ply.mdl" )
AddPlayerHands( "OsamaEnhanced", "models/jessev92/kuma/weapons/arms_osama.mdl", 1, "00000000" )
list.Set( "PlayerOptionsAnimations", "OsamaEnhanced", 	{ "menu_combine" } )

-------------------------------------------------------
-------------------------------------------------------
--	NPC Shit
-------------------------------------------------------
-------------------------------------------------------
local Category = "NPCG - Booster Packs"
local OsamaF = {	Name = "Osama (Friendly)",	Class = "ent_npc_osamabl_cit",	Category = Category	}
list.Set( "NPC", "ent_npc_osamabl_cit", OsamaF )
local OsamaE = {	Name = "Osama (Enemy)",	Class = "ent_npc_osamabl_cmb",	Category = Category	}
list.Set( "NPC", "ent_npc_osamabl_cmb", OsamaE )

if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] Enhanced Osama bin Laden Addon Loaded")	end
