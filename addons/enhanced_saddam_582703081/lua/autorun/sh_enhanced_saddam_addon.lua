
AddCSLuaFile()

-------------------------------------------------------
--	Enhanced Saddam Hussein Addon
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
	--resource.AddWorkshop("136077464")	--	NPCG
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

AddPlayerModel("SaddamEnhanced", "models/jessev92/kuma/characters/saddam_ply.mdl" )
AddPlayerHands( "SaddamEnhanced", "models/jessev92/kuma/weapons/arms_saddam.mdl", 1, "00000000" )
list.Set( "PlayerOptionsAnimations", "SaddamEnhanced", 	{ "menu_zombie" } )

-------------------------------------------------------
-------------------------------------------------------
--	NPC Shit
-------------------------------------------------------
-------------------------------------------------------
local Category = "NPCG - Booster Packs"
local SaddamF = {	Name = "Saddam (Friendly)",	Class = "ent_npc_saddam_cit",	Category = Category	}
list.Set( "NPC", "ent_npc_saddam_cit", SaddamF )
local SaddamE = {	Name = "Saddam (Enemy)",	Class = "ent_npc_saddam_cmb",	Category = Category	}
list.Set( "NPC", "ent_npc_saddam_cmb", SaddamE )

if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] Enhanced Saddam Addon Loaded")	end
