local PossiblePlaces = {

	{ Vector( 3978.428955, 5465.711914, -258.958832 ), 'Лесной пожар!' }, -- Лес около шахты

	{ Vector( -1212.690430, 1805.715576, -116.968750 ), 'Пожар в полицейском участке!' }, -- ПУ

	{ Vector( -13746.802734, -591.070435, -190.968750 ), 'Пожар в гараже росгвардии' }, -- Росгвардия

	{ Vector( 3802.271729, -5128.406738, -210.932724 ), 'Лесной пожар!' }, -- Лес около большого камня

	{ Vector( 10027.645508, 10099.986328, -98.000000 ), 'Лесной пожар!' }, -- Лес около дома маньяка

	{ Vector( -728.617920, 49.640556, -195.968750 ), 'Пожар во многэтажке!' }, -- Многоэтажка

	{ Vector( -6191.087891, 6250.879883, -202.641205 ), 'Лесной пожар!' }, -- рядом с озером

	{ Vector( -4154.411621, 4958.851074, -175.968750 ), 'Пожар в доме!' }, -- Дом рядом с озером
}

local ActiveCall = nil 

--me:EmitSound( 'snd_jack_job_radiotone.wav' )

local function sendMark( ply, pos, text )

	umsg.Start( 'markmsg', ply )

        umsg.Vector( pos )

        umsg.String( text or 'Пожар!' )

        umsg.String( 'request' )

    umsg.End()

end

local function createFire( place )

	local place = place or table.Random( PossiblePlaces )

	for k, v in pairs( player.GetAll() ) do

		if not v:isMedic() then continue end

		v:ChatPrint( 'Диспетчер Олег: ' .. place[ 2 ] )

		v:ChatPrint( 'Примите вызов в течении минуты: /v' )

		v:SendLua( [[LocalPlayer():EmitSound('snd_jack_job_radiotone.wav')]] )

	end


	local fire = ents.Create( 'sfire' )

	fire:SetPos( place[ 1 ] )

	fire:Spawn()

	timer.Simple( 180, function() if not IsValid( fire ) or fire.havefires then return end

		for k, v in pairs( SFires[ fire:EntIndex() ] ) do 

			if IsValid( v ) then v:Remove() end 

		end 

	end )


	ActiveCall = { fire, {}, CurTime(),  place } 


	return fire

end


local function tm()

	for k, fire in pairs( SFires ) do

		local valid = 0

		for i, sfire in pairs( fire ) do 

			if IsValid( sfire ) and IsValid( sfire.fire ) then

				valid = valid + 1

			end

		end

		if valid <= 0 then

			SFires[ k ] = nil

		end

	end

	local FiresCount = table.Count( SFires )

	local count = team.NumPlayers( TEAM_MEDIC ) 



	if count >= 2 and FiresCount < 2 then

		createFire()

	elseif count == 1 and FiresCount < 1 then

		createFire()

	end


	timer.Adjust( 'CreateFire', 1050 - ( 100 * team.NumPlayers( TEAM_MEDIC ) ), 0, tm ) 

end

timer.Create( 'CreateFire', 300, 0, tm ) 

hook.Add( 'Think', 'ExtinguisherInWater', function() 

	for k, v in pairs( player.GetAll() ) do

		if v:IsOnFire() and v:WaterLevel() >= 2 then

			v:Extinguish()

		end

	end

end )

local function playerSay( ply, text )

	if text != '/v' then return end

	if not ply:isMedic() then return nil end

	if not ActiveCall or CurTime() - ActiveCall[ 3 ] > 60 then ply:ChatPrint( 'Нет активных вызовов!' ) return '' end 

	if table.HasValue( ActiveCall[ 2 ], ply ) then ply:ChatPrint( 'Вы уже приняли вызов!' ) return '' end  


	ActiveCall[ 1 ].havefires = true


	sendMark( ply, ActiveCall[ 4 ][ 1 ], ActiveCall[ 4 ][ 2 ] )

	table.insert( ActiveCall[ 2 ], ply )

	ply:ChatPrint( 'Вызов принят!' ) 

	return ''

end

if GAMEMODE.Name == 'DarkRP' and GAMEMODE.OldChatHooks then

	GAMEMODE.OldChatHooks[ 'SFire' ] = playerSay

else

	hook.Add( 'PlayerSay', 'SFire', playerSay )

end


