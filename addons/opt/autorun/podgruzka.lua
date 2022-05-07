AddCSLuaFile()
AddCSLuaFile "cl_optimize.lua"
AddCSLuaFile "sh_optimize.lua"

local function podgruzkaon()
	include "sh_optimize.lua"
	if CLIENT then
		include "cl_optimize.lua"
	else
		include "sv_optimize.lua"
	end
end

if GAMEMODE then podgruzkaon() else hook.Add('InitPostEntity', 'pizdec)', podgruzkaon) end

print("Оптимизация произошла успешно. Версия скрипта: 1.1")