util.AddNetworkString( 'admingift' )

admingift = admingift or {}

admingift.usergroups = {
		
	'superadmin',
	'sponsor+',
	'nab_admin',
	'nab_moder+',
	'owner',

}

admingift.giftDelay = 60 * 60 * 24 * 2 // seconds

admingift.chatCommand = 'спасибо цой'

admingift.getGiftDate = function( ply )
		
		local date = ply:GetPData( 'admingift_' )
	
		if not date then

			return nil

		end

		return tonumber( date )

end

admingift.canGetGift = function( ply )
		
	local date = admingift.getGiftDate( ply )

	if not date then

		return true

	else

		if date - os.time() < 0 then

			return true 

		else

			return false

		end

	end

end

admingift.inclineTime = function( time, array )
		
	local i = time % 10

	local time = time % 100


	if time >= 11 and time <= 19 then

		return array[ 3 ]

	else

		if i == 1 then return array[ 1 ]

		elseif i > 1 and i < 5 then return array[ 2 ]

		else return array[ 3 ] end

	end

end

admingift.getRemainingTime = function( ply )
		
	local when = 'прямо сейчас'

	local cangetgift = admingift.canGetGift( ply )

	if not cangetgift then

		local date = admingift.getGiftDate( ply )

		local remainingTime = date - os.time()

		if remainingTime < 60 then

			local time = math.floor( remainingTime )

			when = 'через ' .. time .. admingift.inclineTime( time, { 'секунду', 'секунды', 'секунд' } )

		elseif remainingTime < ( 60 * 60 ) then

			local time = math.floor( remainingTime / 60 )

			when = 'через ' ..time .. admingift.inclineTime( time, { 'минуту', 'минуты', 'минут' } )

		elseif remainingTime > ( 60 * 60 ) then 

			local time = math.floor( remainingTime / ( 60 * 60 ) )

			when = 'через ' .. time .. admingift.inclineTime( time, { 'час', 'часа', 'часов' } )

		end

	end

	return when

end

admingift.sendOffer = function( ply, showTime, permanentShow )
	
	local when = admingift.getRemainingTime( ply )

	local cangetgift = admingift.canGetGift( ply )


	net.Start( 'admingift' )

	net.WriteBool( true )

	net.WriteBool( cangetgift )

	if cangetgift then
			
		net.WriteBool( permanentShow )

		if not permanentShow then
			
			net.WriteUInt( showTime, 4 )

		end

	else

		net.WriteUInt( showTime, 4 )

	end

	net.WriteString( 'Вы ' .. ( cangetgift and 'можете' or 'сможете' ) .. ' получить 500к ' .. when .. ( cangetgift and '. Используйте команду "' .. admingift.chatCommand or '".' ) )

	net.Send( ply )

end

admingift.giveGift = function( ply )
	
	ply:addMoney( 500000 )

	ply:SetPData( 'admingift_', os.time() + admingift.giftDelay )


	net.Start( 'admingift' )

	net.WriteBool( true )

	net.WriteBool( true )

	net.WriteBool( false )

	net.WriteUInt( 5, 4 )

	net.WriteString( 'Вам было выдано 500к!' )

	net.Send( ply )


	-- remove permanent notify

	net.Start( 'admingift' )

	net.WriteBool( false )

	net.Send( ply )



	timer.Simple( 0.5, function()

		admingift.sendOffer( ply, 7, false )

	end )

end

hook.Add( 'PlayerInitialSpawn', 'admingift', function( ply )

	if not table.HasValue( admingift.usergroups, ply:GetUserGroup() ) then return end

	admingift.sendOffer( ply, 120, true )

end )


hook.Add( 'PostPlayerSay', 'admingift', function( ply, text )

	if not table.HasValue( admingift.usergroups, ply:GetUserGroup() ) then return end

	if text != admingift.chatCommand then return end
	
	if not admingift.canGetGift( ply ) then

		admingift.sendOffer( ply, 10, false )

	else

		admingift.giveGift( ply )

	end

end )