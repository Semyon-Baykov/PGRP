phone = phone or {}

phone.tag = 'gmphone'
phone.cl_tag = 'gmphone_cl'

phone.ActiveCalls = {}

phone.GetCall = function( ply )
	for k,v in pairs( phone.ActiveCalls ) do
		if v[1] == ply or v[2] == ply then return k,v end
	end
end

phone.CanPhone = function( talker, receiver, note )
	if talker:GetNWBool( 'phone_status', false ) == false then
		if note then DarkRP.notify( talker, 1, 3, 'Ваш телефон выключен' ) end
		return false
	end
	if receiver:GetNWBool( 'phone_status', false ) == false then
		return false, 'not_avaliable'
	end
	if phone.GetCall( talker ) or phone.GetCall( receiver ) then
		return false, 'busy'
	end
	return true, 'started'
end

phone.Free = function( ply )
	for k,v in pairs( phone.ActiveCalls ) do
		if v[1] == ply then
			if not v[2] then table.remove( phone.ActiveCalls, k ) return end
			phone.ActiveCalls[k][1] = nil
		end
		if v[2] == ply then
			if not v[1] then table.remove( phone.ActiveCalls, k ) return end
			phone.ActiveCalls[k][2] = nil
		end
	end
end

phone.SendStatus = function( who, what, data )
	net.Start( phone.cl_tag )
		net.WriteString( what )
		net.WriteTable( data or {} )
	net.Send( who )
end

phone.RegisterCall = function( talker, receiver )
	local canphone, why = phone.CanPhone( talker, receiver )
	if not canphone and why then
		phone.SendStatus( talker, why )
		return
	end
	if not canphone then
		return
	end
	phone.SendStatus( talker, 'calling', { ply = receiver } )
	phone.SendStatus( receiver, 'incoming', { ply = talker } )
	phone.SendStatus( player.GetAll(), 'ringtone', { ply = receiver } )
	table.insert( phone.ActiveCalls, { talker, receiver, false } )
end

phone.SetCallStatus = function( callid, status )
	phone.ActiveCalls[ callid ][3] = status == true
end

phone.SetRingtone = function( ply, ringtone )
	local ringtone_valid = phone.Ringtones[ringtone]
	if not ringtone_valid then
		return false, "Такой мелодии не существует"
	end
	ply:SetNWString( 'phone_ringtone', ringtone )
	ply:SetPData( 'phone_ringtone', ringtone )
	
	return true, 'Мелодия звонка изменена'
end

phone.Reply = function( callid, calldata )
	phone.SetCallStatus( callid, true )
	phone.SendStatus( player.GetAll(), 'stopringtone', { ply = calldata[2] } )
	phone.SendStatus( { calldata[1], calldata[2] }, 'started', { talker = calldata[1], receiver = calldata[2] } )
end

phone.Decline = function( callid, calldata )
	phone.SetCallStatus( callid, true )
	phone.SendStatus( player.GetAll(), 'stopringtone', { ply = calldata[2] } )
	phone.SendStatus( { calldata[1], calldata[2] }, 'decline', { talker = calldata[1], receiver = calldata[2] } )
	
	table.remove( phone.ActiveCalls, callid )
end

phone.LoadPlayer = function(ply)
	local ringtone = ply:GetPData( 'phone_ringtone' )
	if ringtone ~= nil then
		ply:SetNWString( 'phone_ringtone', ringtone )
	end
	ply:SetNWBool( 'phone_status', true )
end

phone.Disconnect = function(ply)
	local call, data = phone.GetCall( ply )
	if call then
		phone.Decline( call, data )
	end
end

phone.CanHear = function( receiver, talker )
	local call, data = phone.GetCall( talker )
	if call and (data[1] == receiver or data[2] == receiver) and data[3] == true then
		return true
	end
end

DarkRP.defineChatCommand("ringtone", function(ply, n)
	local result, what = phone.SetRingtone( ply, n )
	DarkRP.notify( ply, result and 2 or 1, 4, what )
	return ""
end)

DarkRP.defineChatCommand("phone_reply", function( ply )
	local call, calldata = phone.GetCall( ply )
	if not call then
		DarkRP.notify( ply, 1, 3, 'Нет активных вызовов' )
		return
	end
	if calldata[3] ~= false or ply ~= calldata[2] then
		return
	end
	phone.Reply( call, calldata )
end)

DarkRP.defineChatCommand("phone_decline", function( ply )
	local call, calldata = phone.GetCall( ply )
	if not call then
		DarkRP.notify( ply, 1, 3, 'Нет активных вызовов' )
		return
	end
	phone.Decline( call, calldata )
end)

DarkRP.defineChatCommand( 'call', function( ply, uid )
	uid = tonumber(uid)
	if not uid then return end
	for k,v in pairs( player.GetAll() ) do
		if v:UserID() == uid and v ~= ply then phone.RegisterCall( ply, v ) end
	end
end)

DarkRP.defineChatCommand( 'toggleon_phone', function(ply)
	if ply:GetNWBool( 'phone_status', false ) == false then
		ply:SetNWBool( 'phone_status', true )
		DarkRP.notify( ply, 2, 3, 'Телефон включен' )
	end
end)

DarkRP.defineChatCommand( 'toggleoff_phone', function(ply)
	if ply:GetNWBool( 'phone_status', false ) == true then
		ply:SetNWBool( 'phone_status', false )
		DarkRP.notify( ply, 2, 3, 'Телефон выключен' )
	end
end)

hook.Add( 'PlayerInitialSpawn', 'Phone - Load Ringtone', phone.LoadPlayer )
hook.Add( 'PlayerDisconnected', 'Phone - End Call', phone.Disconnect )
hook.Add( 'PlayerCanHearPlayersVoice', 'Phone - Think Call', phone.CanHear )

util.AddNetworkString( phone.tag )
util.AddNetworkString( phone.cl_tag )