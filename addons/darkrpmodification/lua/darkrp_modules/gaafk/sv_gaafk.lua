gaafk = gaafk or {}

gaafk.kickTime = 5

gaafk.playersData = gaafk.playersData or {}

--hook.GetTable().HUDShouldDraw.GPortalRP_HideUIWelcome

gaafk.isAFK = function( ply )

	return ply:GetNWBool( 'gaafk_isAfk', false )

end

gaafk.getAFKTime = function( ply )

	return math.Round( ( CurTime() - ply:GetNWInt( 'gaafk_afkTime', 0 ) ) / 60, 1 )

end 

gaafk.canCheckAFK = function( ply )

	if not IsValid( ply ) then

		return false

	end

	if ply:Team() == 1 then
		
		return false
	
	end


	if ply:IsUserGroup( 'superadmin' ) then

		return false

	end

	if not ply:IsConnected() then

		return false
		
	end

	if ply:TimeConnected() < 60 then

		return false

	end
	
	if ply.FAdmin_SetGlobal then

		if ply:FAdmin_GetGlobal( 'fadmin_jailed' ) then

			return false

		end

	end

	if ulx then

		if ply.jail and ply.jail.key then

			return false

		end

	end

	if gaafk.playersData[ ply:SteamID() ] then

		if CurTime() - gaafk.playersData[ ply:SteamID() ].time < 60 then

			return false

		end

	end


	return true

end

gaafk.sendStatus = function( ply, status )

	if not IsValid( ply ) then

		return

	end

	if ply:IsUserGroup( 'superadmin' ) and status then

		return

	end
	
	net.Start( 'gaafk' )

	net.WriteBool( status )

	net.Send( ply )

end

gaafk.resetPlayerData = function( ply )

	if not IsValid( ply ) then

		return

	end


	gaafk.sendStatus( ply, false )
	
	ply:SetNWBool( 'gaafk_isAfk', false )

	ply:SetNWInt( 'gaafk_afkTime', CurTime() )


	timer.Create( 'gaafk_checkPlayer' .. ply:UniqueID(), 60, 0, function()

		if not IsValid( ply ) then

			timer.Remove( 'gaafk_checkPlayer' .. ply:UniqueID() )

			return

		end

		gaafk.checkPlayer( ply )

	end )

	
	gaafk.playersData[ ply:SteamID() ] = {

		eyeangles = ply:EyeAngles(),

		angles = ply:GetAngles(),

		time = CurTime()

	}
end

gaafk.checkPlayer = function( ply )
	
	if not IsValid( ply ) then

		return

	end

	if not ply:IsConnected() then return end

	if not gaafk.playersData[ ply:SteamID() ] then

		gaafk.resetPlayerData( ply )

	else

		local data = gaafk.playersData[ ply:SteamID() ]

		local isAfk = false

		if not gaafk.canCheckAFK( ply ) then

			return false

		end

		if data.eyeangles == ply:EyeAngles() or data.angles == ply:GetAngles() then

			if not gaafk.isAFK( ply ) then

				MsgN( string.format( '[gaafk] Player %s at the moment in afk mode', ply:Nick() ) )

				ply:SetNWBool( 'gaafk_isAfk', true )

				ply:SetNWInt( 'gaafk_afkTime', data.time )

				gaafk.sendStatus( ply, true )

			else

				if gaafk.getAFKTime( ply ) >= gaafk.kickTime then

					ply:changeTeam( TEAM_CITIZEN, true )

				end

			end

			return true

		else

			gaafk.resetPlayerData( ply )

			return false

		end

	end

end

util.AddNetworkString( 'gaafk' )

hook.Add( 'PlayerInitialSpawn', 'gaafk', function( ply )

	if not gaafk.playersData[ ply:SteamID() ] then

		gaafk.resetPlayerData( ply )

	end

end )


hook.Add( 'PlayerDisconnected', 'gaafk', function( ply )

	if gaafk.playersData[ ply:SteamID() ] then

		gaafk.playersData[ ply:SteamID() ] = nil

	end

	if timer.Exists( 'gaafk_checkPlayer' .. ply:UniqueID()  ) then

		timer.Remove( 'gaafk_checkPlayer' .. ply:UniqueID() )

	end

end )

hook.Add( 'PlayerSay', 'gaafk', function( ply )

	if not gaafk.canCheckAFK( ply ) then return end

	if gaafk.isAFK( ply ) then

		MsgN( string.format( '[gaafk] The player %s left AFK after %s minutes', ply:Nick(), tostring( gaafk.getAFKTime( ply ) ) ) )

		gaafk.resetPlayerData( ply )

	else

		local data = gaafk.playersData[ ply:SteamID() ]

		data.time = CurTime()

	end

end )

hook.Add( 'KeyPress', 'gaafk', function( ply )

	if not gaafk.canCheckAFK( ply ) then return end

	if gaafk.isAFK( ply ) then

		MsgN( string.format( '[gaafk] The player %s left AFK after %s minutes', ply:Nick(), tostring( gaafk.getAFKTime( ply ) ) ) )

		gaafk.resetPlayerData( ply )

	else

		local data = gaafk.playersData[ ply:SteamID() ]

		data.time = CurTime()

	end

end )

hook.Add( 'PlayerFootstep', 'gaafk', function( ply )

	if not gaafk.canCheckAFK( ply ) then return end

	if gaafk.isAFK( ply ) then

		MsgN( string.format( '[gaafk] The player %s left AFK after %s minutes', ply:Nick(), tostring( gaafk.getAFKTime( ply ) ) ) )

		gaafk.resetPlayerData( ply )

	else

		local data = gaafk.playersData[ ply:SteamID() ]

		data.time = CurTime()

	end

end )
