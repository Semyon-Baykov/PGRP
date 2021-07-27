--[[---------------------------------------------------------------------------
Group chats
---------------------------------------------------------------------------
Team chat for when you have a certain job.
e.g. with the default police group chat, police officers, chiefs and mayors can
talk to one another through /g or team chat.

HOW TO MAKE A GROUP CHAT:
Simple method:
GAMEMODE:AddGroupChat(List of team variables separated by comma)

Advanced method:
GAMEMODE:AddGroupChat(a function with ply as argument that returns whether a random player is in one chat group)
This is for people who know how to script Lua.

---------------------------------------------------------------------------]]
-- Example: GAMEMODE:AddGroupChat(TEAM_MOB, TEAM_GANG)
-- Example: GAMEMODE:AddGroupChat(function(ply) return ply:isCP() end)

			GAMEMODE:AddGroupChat(TEAM_MOB, TEAM_GANG, TEAM_GANGVIP)
			GAMEMODE:AddGroupChat(TEAM_POLICE, TEAM_CHIEF, TEAM_MAYOR, TEAM_PPS, TEAM_OMON, TEAM_FBI)
			GAMEMODE:AddGroupChat(TEAM_NRG1, TEAM_NRG2, TEAM_NRG3, TEAM_NRG4)