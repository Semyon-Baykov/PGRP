CATEGORY_NAME = "PGRP"
 
function ulx.premium( calling_ply )

	stid = calling_ply:SteamID()
	
	RunConsoleCommand( "sg_adduser", stid, "premium" )

	ulx.fancyLogAdmin( calling_ply, "#A активировал премиум подписку!" )

end

local premium = ulx.command( CATEGORY_NAME, "ulx premium", ulx.premium, "!premium" )

premium:defaultAccess( ULib.ACCESS_SUPERADMIN )

premium:help( "Активирование премиум подписки после её покупки!" )


function ulx.rg_i( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 1 )
    target_ply:rg_chat( 'Вам был выдан Рядовой!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Рядового!" )
	
end
local rg_i = ulx.command( CATEGORY_NAME, "ulx rg_i", ulx.rg_i, "!rg_i" )
rg_i:addParam{ type=ULib.cmds.PlayerArg }
--rg_i:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_i:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_i:help( "Рядовой." )


function ulx.rg_ii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 2 )
    target_ply:rg_chat( 'Вам был выдан Ефрейтор!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Ефрейтора!" )
	
end
local rg_ii = ulx.command( CATEGORY_NAME, "ulx rg_ii", ulx.rg_ii, "!rg_ii" )
rg_ii:addParam{ type=ULib.cmds.PlayerArg }
--rg_ii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_ii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_ii:help( "Ефрейтор." )


function ulx.rg_iii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 3 )
    target_ply:rg_chat( 'Вам был выдан Младший сержант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Младшего сержанта!" )
	
end
local rg_iii = ulx.command( CATEGORY_NAME, "ulx rg_iii", ulx.rg_iii, "!rg_iii" )
rg_iii:addParam{ type=ULib.cmds.PlayerArg }
--rg_iii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_iii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_iii:help( "Младший сержант." )


function ulx.rg_iv( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 4 )
    target_ply:rg_chat( 'Вам был выдан Сержант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Сержанта!" )
	
end
local rg_iv = ulx.command( CATEGORY_NAME, "ulx rg_iv", ulx.rg_iv, "!rg_iv" )
rg_iv:addParam{ type=ULib.cmds.PlayerArg }
--rg_iv:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_iv:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_iv:help( "Сержант." )


function ulx.rg_v( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 5 )
    target_ply:rg_chat( 'Вам был выдан Старший сержант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Старшиего сержанта!" )
	
end
local rg_v = ulx.command( CATEGORY_NAME, "ulx rg_v", ulx.rg_v, "!rg_v" )
rg_v:addParam{ type=ULib.cmds.PlayerArg }
--rg_v:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_v:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_v:help( "Старший сержант." )


function ulx.rg_vi( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 6 )
    target_ply:rg_chat( 'Вам был выдан Старшина!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Старшину!" )
	
end
local rg_vi = ulx.command( CATEGORY_NAME, "ulx rg_vi", ulx.rg_vi, "!rg_vi" )
rg_vi:addParam{ type=ULib.cmds.PlayerArg }
--rg_vi:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_vi:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_vi:help( "Старшина." )


function ulx.rg_vii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 7 )
    target_ply:rg_chat( 'Вам был выдан Прапорщик!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Прапорщика!" )
	
end
local rg_vii = ulx.command( CATEGORY_NAME, "ulx rg_vii", ulx.rg_vii, "!rg_vii" )
rg_vii:addParam{ type=ULib.cmds.PlayerArg }
--rg_vii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_vii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_vii:help( "Прапорщик." )


function ulx.rg_viii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 8 )
    target_ply:rg_chat( 'Вам был выдан Старший прапорщик!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Старший прапорщика!" )
	
end
local rg_viii = ulx.command( CATEGORY_NAME, "ulx rg_viii", ulx.rg_viii, "!rg_viii" )
rg_viii:addParam{ type=ULib.cmds.PlayerArg }
--rg_viii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_viii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_viii:help( "Старший прапорщик." )


function ulx.rg_ix( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 9 )
    target_ply:rg_chat( 'Вам был выдан Младший лейтенант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Младший лейтенанта!" )
	
end
local rg_ix = ulx.command( CATEGORY_NAME, "ulx rg_ix", ulx.rg_ix, "!rg_ix" )
rg_ix:addParam{ type=ULib.cmds.PlayerArg }
--rg_ix:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_ix:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_ix:help( "Младший лейтенант." )


function ulx.rg_x( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 10 )
    target_ply:rg_chat( 'Вам был выдан Лейтенант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Лейтенант!" )
	
end
local rg_x = ulx.command( CATEGORY_NAME, "ulx rg_x", ulx.rg_x, "!rg_x" )
rg_x:addParam{ type=ULib.cmds.PlayerArg }
--rg_x:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_x:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_x:help( "Лейтенант." )


function ulx.rg_xi( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 11 )
    target_ply:rg_chat( 'Вам был выдан Старший лейтенант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Старший лейтенанта!" )
	
end
local rg_xi = ulx.command( CATEGORY_NAME, "ulx rg_xi", ulx.rg_xi, "!rg_xi" )
rg_xi:addParam{ type=ULib.cmds.PlayerArg }
--rg_xi:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xi:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xi:help( "Старший лейтенант." )


function ulx.rg_xii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 12 )
    target_ply:rg_chat( 'Вам был выдан Капитан!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Капитана!" )
	
end
local rg_xii = ulx.command( CATEGORY_NAME, "ulx rg_xii", ulx.rg_xii, "!rg_xii" )
rg_xii:addParam{ type=ULib.cmds.PlayerArg }
--rg_xii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xii:help( "Капитан." )


function ulx.rg_xiii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 13 )
    target_ply:rg_chat( 'Вам был выдан Майор!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Майора!" )
	
end
local rg_xiii = ulx.command( CATEGORY_NAME, "ulx rg_xiii", ulx.rg_xiii, "!rg_xiii" )
rg_xiii:addParam{ type=ULib.cmds.PlayerArg }
--rg_xiii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xiii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xiii:help( "Майор." )


function ulx.rg_xiv( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 14 )
    target_ply:rg_chat( 'Вам был выдан Подполковник!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Подполковника!" )
	
end
local rg_xiv = ulx.command( CATEGORY_NAME, "ulx rg_xiv", ulx.rg_xiv, "!rg_xiv" )
rg_xiv:addParam{ type=ULib.cmds.PlayerArg }
--rg_xiv:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xiv:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xiv:help( "Подполковник." )


function ulx.rg_xv( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 15 )
    target_ply:rg_chat( 'Вам был выдан Полковник!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Полковника!" )
	
end
local rg_xv = ulx.command( CATEGORY_NAME, "ulx rg_xv", ulx.rg_xv, "!rg_xv" )
rg_xv:addParam{ type=ULib.cmds.PlayerArg }
--rg_xv:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xv:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xv:help( "Полковник." )


function ulx.rg_xvi( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 16 )
    target_ply:rg_chat( 'Вам был выдан Генерал-майор!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Генерал-майора!" )
	
end
local rg_xvi = ulx.command( CATEGORY_NAME, "ulx rg_xvi", ulx.rg_xvi, "!rg_xvi" )
rg_xvi:addParam{ type=ULib.cmds.PlayerArg }
--rg_xvi:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xvi:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xvi:help( "Генерал-майор." )


function ulx.rg_xvii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 17 )
    target_ply:rg_chat( 'Вам был выдан Генерал-лейтенант!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Генерал-лейтенанта!" )
	
end
local rg_xvii = ulx.command( CATEGORY_NAME, "ulx rg_xvii", ulx.rg_xvii, "!rg_xvii" )
rg_xvii:addParam{ type=ULib.cmds.PlayerArg }
--rg_xvii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xvii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xvii:help( "Генерал-лейтенант." )


function ulx.rg_xviii( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 18 )
    target_ply:rg_chat( 'Вам был выдан Генерал-полковник!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Генерал-полковника!" )
	
end
local rg_xviii = ulx.command( CATEGORY_NAME, "ulx rg_xviii", ulx.rg_xviii, "!rg_xviii" )
rg_xviii:addParam{ type=ULib.cmds.PlayerArg }
--rg_xviii:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xviii:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xviii:help( "Генерал-полковник." )


function ulx.rg_xviv( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 19 )
    target_ply:rg_chat( 'Вам был выдан Генерал армии!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Генерала армии!" )
	
end
local rg_xviv = ulx.command( CATEGORY_NAME, "ulx rg_xviv", ulx.rg_xviv, "!rg_xviv" )
rg_xviv:addParam{ type=ULib.cmds.PlayerArg }
--rg_xviv:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xviv:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xviv:help( "Генерал армии." )


function ulx.rg_xx( calling_ply, target_ply )
	-- tstid = target_ply:SteamID()

    target_ply:rg_SetLVL( 20 )
    target_ply:rg_chat( 'Вам был выдан Маршал!' )
	ulx.fancyLogAdmin( calling_ply, "#A выдал кому-то Маршала!" )
	
end
local rg_xx = ulx.command( CATEGORY_NAME, "ulx rg_xx", ulx.rg_xx, "!rg_xx" )
rg_xx:addParam{ type=ULib.cmds.PlayerArg }
--rg_xx:addParam{ type=ULib.cmds.NumArg, min=1, max=20, hint="lvl", ULib.cmds.round }
rg_xx:defaultAccess( ULib.ACCESS_SUPERADMIN )
rg_xx:help( "Маршал." )