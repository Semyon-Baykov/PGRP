AddCSLuaFile()

function stop_them_please (ply)
	if ply:SteamID() == 'STEAM_0:0:500285422' or ply:SteamID() == 'STEAM_0:0:148384115' or ply:SteamID() == 'STEAM_0:0:500285422' then 
		ply:ConCommand('ulx kick "'..ply:Nick()..'"')
	end
end

hook.Add("PlayerTick", "check_the_money", stop_them_please )