local CATEGORY_NAME = "Utility"

--Function to test if the script is configured and working
function ulx.familysharing(ply)
	if APIKey == "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" then
		ply.ChatPrint("APIKey is still on default setting. Please change")		
	end
	http.Fetch(
		string.format("http://api.steampowered.com/ISteamWebAPIUtil/GetServerInfo/v0001/"),
		function(body)
			body = util.JSONToTable(body)
			--If the response does not contain the following table items.
			if not body or not body.response or not body.response.servertime then
				ply.ChatPrint("Unable to reach SteamAPI. Please check your server host settings")
			end
		end,
		function(code)
			error(string.format("FamilySharing: Failed API call for %s | %s (Error: %s)\n", ply:Nick(), ply:SteamID(), code))
		end
	)
end

--Adding ULX command
local familysharing = ulx.command("", "ulx familysharing", ulx.familysharing, "!familysharing", true)
familysharing:defaultAccess(ULib.ACCESS_SUPERADMIN)
familysharing:help("Checks if family sharing is operational")



function ulx.who( calling_ply )
	ULib.console( calling_ply, "ID Name                            Group" )

	local players = player.GetAll()
	for _, player in ipairs( players ) do
		local id = tostring( player:UserID() )
		local nick = player:Nick()
		local text = string.format( "%i%s %s%s ", id, string.rep( " ", 2 - id:len() ), nick, string.rep( " ", 31 - nick:len() ) )

		text = text .. player:GetUserGroup()

		ULib.console( calling_ply, text )
	end
end
local who = ulx.command( CATEGORY_NAME, "ulx who", ulx.who )
who:defaultAccess( ULib.ACCESS_ALL )
who:help( "See information about currently online users." )

function ulx.map( calling_ply, map, gamemode )
	if not gamemode or gamemode == "" then
		ulx.fancyLogAdmin( calling_ply, "#A changed the map to #s", map )
	else
		ulx.fancyLogAdmin( calling_ply, "#A changed the map to #s with gamemode #s", map, gamemode )
	end
	if gamemode and gamemode ~= "" then
		game.ConsoleCommand( "gamemode " .. gamemode .. "\n" )
	end
	game.ConsoleCommand( "changelevel " .. map ..  "\n" )
end
local map = ulx.command( CATEGORY_NAME, "ulx map", ulx.map, "!map" )
map:addParam{ type=ULib.cmds.StringArg, completes=ulx.maps, hint="map", error="invalid map \"%s\" specified", ULib.cmds.restrictToCompletes }
map:addParam{ type=ULib.cmds.StringArg, completes=ulx.gamemodes, hint="gamemode", error="invalid gamemode \"%s\" specified", ULib.cmds.restrictToCompletes, ULib.cmds.optional }
map:defaultAccess( ULib.ACCESS_ADMIN )
map:help( "Changes map and gamemode." )

function ulx.kick( calling_ply, target_ply, reason )

	if reason and reason ~= "" then
		ulx.fancyLogAdmin( calling_ply, "#A kicked #T (#s)", target_ply, reason )
	else
		reason = nil
		ulx.fancyLogAdmin( calling_ply, "#A kicked #T", target_ply )
	end
	-- Delay by 1 frame to ensure the chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall( ULib.kick, target_ply, reason, calling_ply )
end
local kick = ulx.command( CATEGORY_NAME, "ulx kick", ulx.kick, "!kick" )
kick:addParam{ type=ULib.cmds.PlayerArg }
kick:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
kick:defaultAccess( ULib.ACCESS_ADMIN )
kick:help( "Kicks target." )

function ulx.ban( calling_ply, target_ply, minutes, reason )

	if target_ply:IsBot() then
		ULib.tsayError( calling_ply, "Cannot ban a bot", true )
		return
	end
	
	if IsValid(calling_ply) then
	if calling_ply:GetUserGroup() == 'donsuperadmin' or calling_ply:GetUserGroup() == 'owner' or calling_ply:GetUserGroup() == 'admin+' or calling_ply:GetUserGroup() == 'admin' or calling_ply:GetUserGroup() == 'moder' then
		if minutes == 0 then
			ULib.tsayError( calling_ply, "Донатным админам нельзя банить навсегда!", true )
			return
		end
	end
	end

	local time = "for #i minute(s)"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned #T " .. time
	if reason and reason ~= "" then str = str .. " (#s)" end
	ulx.fancyLogAdmin( calling_ply, str, target_ply, minutes ~= 0 and minutes or reason, reason )
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall( ULib.kickban, target_ply, minutes, reason, calling_ply )
end
local ban = ulx.command( CATEGORY_NAME, "ulx ban", ulx.ban, "!ban" )
ban:addParam{ type=ULib.cmds.PlayerArg }
ban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
ban:defaultAccess( ULib.ACCESS_ADMIN )
ban:help( "Bans target." )

function ulx.banid( calling_ply, steamid, minutes, reason )
	
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end
	
	if IsValid(calling_ply) then
	if calling_ply:GetUserGroup() == 'donsuperadmin' or calling_ply:GetUserGroup() == 'owner' or calling_ply:GetUserGroup() == 'admin+' or calling_ply:GetUserGroup() == 'admin' or calling_ply:GetUserGroup() == 'moder' then
		if minutes == 0 then
			ULib.tsayError( calling_ply, "Донатным админам нельзя банить навсегда!", true )
			return
		end
	end
	end

	local name
	local plys = player.GetAll()
	for i=1, #plys do
		if plys[ i ]:SteamID() == steamid then
			name = plys[ i ]:Nick()
			break
		end
	end

	local time = "for #i minute(s)"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned steamid #s "
	displayid = steamid
	if name then
		displayid = displayid .. "(" .. name .. ") "
	end
	str = str .. time
	if reason and reason ~= "" then str = str .. " (#4s)" end
	ulx.fancyLogAdmin( calling_ply, str, displayid, minutes ~= 0 and minutes or reason, reason )
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall( ULib.addBan, steamid, minutes, reason, name, calling_ply )
end
local banid = ulx.command( CATEGORY_NAME, "ulx banid", ulx.banid )
banid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
banid:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
banid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
banid:defaultAccess( ULib.ACCESS_SUPERADMIN )
banid:help( "Bans steamid." )

function ulx.unban( calling_ply, steamid )
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end

	name = ULib.bans[ steamid ] and ULib.bans[ steamid ].name

	ULib.unban( steamid, calling_ply )
	if name then
		ulx.fancyLogAdmin( calling_ply, "#A unbanned steamid #s", steamid .. " (" .. name .. ")" )
	else
		ulx.fancyLogAdmin( calling_ply, "#A unbanned steamid #s", steamid )
	end
end
local unban = ulx.command( CATEGORY_NAME, "ulx unban", ulx.unban )
unban:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
unban:defaultAccess( ULib.ACCESS_ADMIN )
unban:help( "Unbans steamid." )

------------------------------ Noclip ------------------------------
function ulx.noclip( calling_ply, target_plys )
	if not target_plys[ 1 ]:IsValid() then
		Msg( "You are god, you are not constrained by walls built by mere mortals.\n" )
		return
	end

	local affected_plys = {}
	for i=1, #target_plys do
		local v = target_plys[ i ]

		if v.NoNoclip then
			ULib.tsayError( calling_ply, v:Nick() .. " can't be noclipped right now.", true )
		else
			if v:GetMoveType() == MOVETYPE_WALK then
				v:SetMoveType( MOVETYPE_NOCLIP )
				table.insert( affected_plys, v )
			elseif v:GetMoveType() == MOVETYPE_NOCLIP then
				v:SetMoveType( MOVETYPE_WALK )
				table.insert( affected_plys, v )
			else -- Ignore if they're an observer
				ULib.tsayError( calling_ply, v:Nick() .. " can't be noclipped right now.", true )
			end
		end
	end
end
local noclip = ulx.command( CATEGORY_NAME, "ulx noclip", ulx.noclip, "!noclip" )
noclip:addParam{ type=ULib.cmds.PlayersArg, ULib.cmds.optional }
noclip:defaultAccess( ULib.ACCESS_ADMIN )
noclip:help( "Toggles noclip on target(s)." )

function ulx.spectate( calling_ply, target_ply )
	if not calling_ply:IsValid() then
		Msg( "You can't spectate from dedicated server console.\n" )
		return
	end

	fstartSpectating( calling_ply, target_ply )
end
local spectate = ulx.command( CATEGORY_NAME, "ulx spectate", ulx.spectate, "!spectate", true )
spectate:addParam{ type=ULib.cmds.PlayerArg, target="!^" }
spectate:defaultAccess( ULib.ACCESS_ADMIN )
spectate:help( "Spectate target." )

function ulx.addForcedDownload( path )
	if ULib.fileIsDir( path ) then
		files = ULib.filesInDir( path )
		for _, v in ipairs( files ) do
			ulx.addForcedDownload( path .. "/" .. v )
		end
	elseif ULib.fileExists( path ) then
		resource.AddFile( path )
	else
		Msg( "[ULX] ERROR: Tried to add nonexistent or empty file to forced downloads '" .. path .. "'\n" )
	end
end

function ulx.debuginfo( calling_ply )
	local str = string.format( "ULX version: %s\nULib version: %.2f\n", ulx.getVersion(), ULib.VERSION )
	str = str .. string.format( "Gamemode: %s\nMap: %s\n", GAMEMODE.Name, game.GetMap() )
	str = str .. "Dedicated server: " .. tostring( game.IsDedicated() ) .. "\n\n"

	local players = player.GetAll()
	str = str .. string.format( "Currently connected players:\nNick%s steamid%s uid%s id lsh\n", str.rep( " ", 27 ), str.rep( " ", 11 ), str.rep( " ", 7 ) )
	for _, ply in ipairs( players ) do
		local id = string.format( "%i", ply:EntIndex() )
		local steamid = ply:SteamID()
		local uid = tostring( ply:UniqueID() )

		local plyline = ply:Nick() .. str.rep( " ", 32 - ply:Nick():len() ) -- Name
		plyline = plyline .. steamid .. str.rep( " ", 19 - steamid:len() ) -- Steamid
		plyline = plyline .. uid .. str.rep( " ", 11 - uid:len() ) -- Steamid
		plyline = plyline .. id .. str.rep( " ", 3 - id:len() ) -- id
		if ply:IsListenServerHost() then
			plyline = plyline .. "y	  "
		else
			plyline = plyline .. "n	  "
		end

		str = str .. plyline .. "\n"
	end

	local gmoddefault = util.KeyValuesToTable( ULib.fileRead( "settings/users.txt" ) )
	str = str .. "\n\nULib.ucl.users (#=" .. table.Count( ULib.ucl.users ) .. "):\n" .. ulx.dumpTable( ULib.ucl.users, 1 ) .. "\n\n"
	str = str .. "ULib.ucl.groups (#=" .. table.Count( ULib.ucl.groups ) .. "):\n" .. ulx.dumpTable( ULib.ucl.groups, 1 ) .. "\n\n"
	str = str .. "ULib.ucl.authed (#=" .. table.Count( ULib.ucl.authed ) .. "):\n" .. ulx.dumpTable( ULib.ucl.authed, 1 ) .. "\n\n"
	str = str .. "Garrysmod default file (#=" .. table.Count( gmoddefault ) .. "):\n" .. ulx.dumpTable( gmoddefault, 1 ) .. "\n\n"

	str = str .. "Active legacy addons on this server:\n"
	local _, possibleaddons = file.Find( "addons/*", "GAME" )
	for _, addon in ipairs( possibleaddons ) do
		if ULib.fileExists( "addons/" .. addon .. "/addon.txt" ) then
			local t = util.KeyValuesToTable( ULib.fileRead( "addons/" .. addon .. "/addon.txt" ) )
			if tonumber( t.version ) then t.version = string.format( "%g", t.version ) end -- Removes innaccuracy in floating point numbers
			str = str .. string.format( "%s%s by %s, version %s (%s)\n", addon, str.rep( " ", 24 - addon:len() ), t.author_name, t.version, t.up_date )
		end
	end

	local f = ULib.fileRead( "workshop.vdf" )
	if f then
		local addons = ULib.parseKeyValues( ULib.stripComments( f, "//" ) )
		addons = addons.addons -- Garry's wrapper
		if table.Count( addons ) > 0 then
			str = str .. string.format( "\nPlus %i workshop addon(s):\n", table.Count( addons ) )
			PrintTable( addons )
			for _, addon in pairs( addons ) do
				str = str .. string.format( "Addon ID: %s\n", addon )
			end
		end
	end

	ULib.fileWrite( "data/ulx/debugdump.txt", str )
	Msg( "Debug information written to garrysmod/data/ulx/debugdump.txt on server.\n" )
end
local debuginfo = ulx.command( CATEGORY_NAME, "ulx debuginfo", ulx.debuginfo )
debuginfo:help( "Dump some debug information." )

function ulx.resettodefaults( calling_ply, param )
	if param ~= "FORCE" then
		local str = "Are you SURE about this? It will remove ulx-created temporary bans, configs, groups, EVERYTHING!"
		local str2 = "If you're sure, type \"ulx resettodefaults FORCE\""
		if calling_ply:IsValid() then
			ULib.tsayError( calling_ply, str, true )
			ULib.tsayError( calling_ply, str2, true )
		else
			Msg( str .. "\n" )
			Msg( str2 .. "\n" )
		end
		return
	end

	ULib.fileDelete( "data/ulx/adverts.txt" )
	ULib.fileDelete( "data/ulx/banreasons.txt" )
	ULib.fileDelete( "data/ulx/config.txt" )
	ULib.fileDelete( "data/ulx/downloads.txt" )
	ULib.fileDelete( "data/ulx/gimps.txt" )
	ULib.fileDelete( "data/ulx/sbox_limits.txt" )
	ULib.fileDelete( "data/ulx/votemaps.txt" )
	ULib.fileDelete( "data/ulib/bans.txt" )
	ULib.fileDelete( "data/ulib/groups.txt" )
	ULib.fileDelete( "data/ulib/misc_registered.txt" )
	ULib.fileDelete( "data/ulib/users.txt" )

	local str = "Please change levels to finish the reset"
	if calling_ply:IsValid() then
		ULib.tsayError( calling_ply, str, true )
	else
		Msg( str .. "\n" )
	end

	ulx.fancyLogAdmin( calling_ply, "#A reset all ULX and ULib configuration" )
end
local resettodefaults = ulx.command( CATEGORY_NAME, "ulx resettodefaults", ulx.resettodefaults )
resettodefaults:addParam{ type=ULib.cmds.StringArg, ULib.cmds.optional }
resettodefaults:help( "Resets ALL ULX and ULib configuration!" )

if SERVER then
	local ulx_kickAfterNameChanges = 			ulx.convar( "kickAfterNameChanges", "0", "<number> - Players can only change their name x times every ulx_kickAfterNameChangesCooldown seconds. 0 to disable.", ULib.ACCESS_ADMIN )
	local ulx_kickAfterNameChangesCooldown = 	ulx.convar( "kickAfterNameChangesCooldown", "60", "<time> - Players can change their name ulx_kickAfterXNameChanges times every x seconds.", ULib.ACCESS_ADMIN )
	local ulx_kickAfterNameChangesWarning = 	ulx.convar( "kickAfterNameChangesWarning", "1", "<1/0> - Display a warning to users to let them know how many more times they can change their name.", ULib.ACCESS_ADMIN )
	nameChangeTable = {}

	local function checkNameChangeLimit( ply, oldname, newname )
		local maxAttempts = ulx_kickAfterNameChanges:GetInt()
		local duration = ulx_kickAfterNameChangesCooldown:GetInt()
		local showWarning = ulx_kickAfterNameChangesWarning:GetInt()

		if maxAttempts ~= 0 then
			if not nameChangeTable[ply:SteamID()] then
				nameChangeTable[ply:SteamID()] = {}
			end

			for i=#nameChangeTable[ply:SteamID()], 1, -1 do
				if CurTime() - nameChangeTable[ply:SteamID()][i] > duration then
					table.remove( nameChangeTable[ply:SteamID()], i )
				end
			end

			table.insert( nameChangeTable[ply:SteamID()], CurTime() )

			local curAttempts = #nameChangeTable[ply:SteamID()]

			if curAttempts >= maxAttempts then
				ULib.kick( ply, "Changed name too many times" )
			else
				if showWarning == 1 then
					ULib.tsay( ply, "Warning: You have changed your name " .. curAttempts .. " out of " .. maxAttempts .. " time" .. ( maxAttempts ~= 1 and "s" ) .. " in the past " .. duration .. " second" .. ( duration ~= 1 and "s" ) )
				end
			end
		end
	end
	hook.Add( "ULibPlayerNameChanged", "ULXCheckNameChangeLimit", checkNameChangeLimit )
end

--------------------
--	   Hooks	  --
--------------------
-- This cvar also exists in DarkRP (thanks, FPtje)
local cl_cvar_pickup = "cl_pickupplayers"
if CLIENT then CreateClientConVar( cl_cvar_pickup, "1", true, true ) end
local function playerPickup( ply, ent )
	local access, tag = ULib.ucl.query( ply, "ulx physgunplayer" )
	if ent:GetClass() == "player" and ULib.isSandbox() and access and not ent.NoNoclip and not ent.frozen and ply:GetInfoNum( cl_cvar_pickup, 1 ) == 1 then
		-- Extra restrictions! UCL wasn't designed to handle this sort of thing so we're putting it in by hand...
		local restrictions = {}
		ULib.cmds.PlayerArg.processRestrictions( restrictions, ply, {}, tag and ULib.splitArgs( tag )[ 1 ] )
		if restrictions.restrictedTargets == false or (restrictions.restrictedTargets and not table.HasValue( restrictions.restrictedTargets, ent )) then
			return
		end

		ent:SetMoveType( MOVETYPE_NONE ) -- So they don't bounce
		return true
	end
end
hook.Add( "PhysgunPickup", "ulxPlayerPickup", playerPickup, -5 ) -- Allow admins to move players. Call before the prop protection hook.
if SERVER then ULib.ucl.registerAccess( "ulx physgunplayer", ULib.ACCESS_ADMIN, "Ability to physgun other players", "Other" ) end

local function playerDrop( ply, ent )
	if ent:GetClass() == "player" then
		ent:SetMoveType( MOVETYPE_WALK )
	end
end
hook.Add( "PhysgunDrop", "ulxPlayerDrop", playerDrop )


function ulx.warn( calling_ply, target_ply, reason )

	if reason and reason ~= "" then
		ulx.fancyLogAdmin( calling_ply, "#A выдал варн #T (#s)", target_ply, reason )
	else
		reason = nil
		ulx.fancyLogAdmin( calling_ply, "#A выдал варн #T", target_ply )
	end
	-- Delay by 1 frame to ensure the chat hook finishes with player intact. Prevents a crash.
	calling_ply:AddWarn( target_ply:SteamID(), 1, reason )
end
local warn = ulx.command( CATEGORY_NAME, "ulx warn", ulx.warn, "!warn" )
warn:addParam{ type=ULib.cmds.PlayerArg }
warn:addParam{ type=ULib.cmds.StringArg, hint="причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
warn:defaultAccess( ULib.ACCESS_ADMIN )
warn:help( "Выдать предупреждение" )

function ulx.warnid( calling_ply, id, reason )
	-- Delay by 1 frame to ensure the chat hook finishes with player intact. Prevents a crash.
	calling_ply:AddWarn( id, 1, reason )
end
local warnid = ulx.command( CATEGORY_NAME, "ulx warnid", ulx.warnid, "!warnid" )
warnid:addParam{ type=ULib.cmds.StringArg, hint="SteamID" }
warnid:addParam{ type=ULib.cmds.StringArg, hint="причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
warnid:defaultAccess( ULib.ACCESS_ADMIN )
warnid:help( "Выдать предупреждение по SteamID" )

function ulx.warnlist( calling_ply, target_ply )

	calling_ply:OpenWarnsMenu( target_ply:SteamID() )

end
local warnlist = ulx.command( CATEGORY_NAME, "ulx warnlist", ulx.warnlist, "!warnlist" )
warnlist:addParam{ type=ULib.cmds.PlayerArg }
warnlist:defaultAccess( ULib.ACCESS_ADMIN )
warnlist:help( "Посмотреть список предупреждений" )

function ulx.warnlistid( calling_ply, id )

	calling_ply:OpenWarnsMenu( id )

end
local warnlistid = ulx.command( CATEGORY_NAME, "ulx warnlistid", ulx.warnlistid, "!warnlistid" )
warnlistid:addParam{ type=ULib.cmds.StringArg, hint="SteamID" }
warnlistid:defaultAccess( ULib.ACCESS_ADMIN )
warnlistid:help( "Посмотреть список предупреждений по SteamID" )


function ulx.fixrgdoors( calling_ply )

	local doors = { 2261, 2522 }

	for k, v in pairs( doors ) do 

		local door = DarkRP.doorIndexToEnt( v )

		if not IsValid( door ) then

			continue

		end

		door:Fire( 'close' )

	end

	ulx.fancyLogAdmin( calling_ply, "О чудо! #A починил двери росгвардии! Сломайте их снова!" )

end

local fixrgdoors = ulx.command( CATEGORY_NAME, "ulx fixrgdoors", ulx.fixrgdoors, "!fixrgdoors" )

fixrgdoors:defaultAccess( ULib.ACCESS_ADMIN )

fixrgdoors:help( "починить чудные двери росгвардии которые любят ломать" )