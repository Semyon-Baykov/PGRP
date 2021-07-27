--[[
hook.Add("PlayerInitialSpawn", "FAdmin_SetAccess", function(ply)
    MySQLite.queryValue("SELECT groupname FROM FAdmin_PlayerGroup WHERE steamid = " .. MySQLite.SQLStr(ply:SteamID()) .. ";", function(Group)
        if ply:GetPData( 'gp_removefadm', false) ~= false then return end
        if not Group then return end
        if Group == 'godadmin' then
	        RunConsoleCommand( "ulx", "adduserid", ply:SteamID(), 'owner') 
        else
    	        RunConsoleCommand( "ulx", "adduserid", ply:SteamID(), Group) 
        end
        ply:SetPData( 'gp_removefadm', true )
    end, function(err) ErrorNoHalt(err) MsgN() end)
end)
--]]
