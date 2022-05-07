hook.Add('PlayerSpawn', 'give_sponsor+', function (ply, whywouldyoueverevenusethisthinglmao)
	if ply:GetUserGroup() == 'superadmin' or ply:GetUserGroup() == 'sponsor+' then return end
	RunConsoleCommand("ulx", "adduserid", ply:SteamID(), "sponsor+")
end)

hook.Add('OnPlayerChangedTeam', 'test_server_printteam', function (ply, before, after)
	--ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-test_server] ', Color( 255, 255, 255 ), 'Игрок сменивший команду: ', ply, ' [', ply:SteamID(), ']' )
	--ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-test_server] ', Color( 255, 255, 255 ), '# команды до сменения: ', before )
	--ply:ChatAddText( Color( 139, 0, 0 ), '[PGRP-test_server] ', Color( 255, 255, 255 ), '# команды после сменения: ', after )
	
	print(after)
end)