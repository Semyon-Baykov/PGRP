
local function respawnTime( ply )

	local premium = false 

	if ply:IsSecondaryUserGroup "premium" then premium = true end

	return premium and 10 or 45

end

local function inclineTime( time, array ) -- 1, { год, года, лет }

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

surface.CreateFont( 'RespawnTimer', {

	font = 'Roboto',

	size = 35,

	weight = 1000,

	extended = true, 

	antialias = true

} )

 local effect = {}

effect[ '$pp_colour_addr' ] = 0

effect[ '$pp_colour_addg' ] = 0

effect[ '$pp_colour_addb' ] = 0


effect[ '$pp_colour_brightness' ] = -0.25

effect[ '$pp_colour_contrast' ] = 1

effect[ '$pp_colour_colour' ] = 1


effect[ '$pp_colour_mulr' ] = 0

effect[ '$pp_colour_mulg' ] = 0

effect[ '$pp_colour_mulb' ] = 0


hook.Add( 'RenderScreenspaceEffects', 'RespawnTimer', function() 

	if LocalPlayer():Alive() then

		effect[ '$pp_colour_colour' ] = 1

	else

		DrawColorModify( effect )

		effect[ '$pp_colour_colour' ] = Lerp( FrameTime() / 5, effect[ '$pp_colour_colour' ], 0.1 )

	end

end )

hook.Add( 'HUDShouldDraw', 'HideRedDeath', function( name )

	if name == 'CHudDamageIndicator' then return false end

end )

local sounds = {

	'music/hl2_song7.mp3',

	'music/hl2_song8.mp3',

	'music/hl1_song14.mp3',

	'music/hl1_song10.mp3',

	'music/hl2_song33.mp3',

	'music/hl2_song28.mp3',

	'music/hl2_song25_teleporter.mp3',

	'music/hl2_song23_suitsong3.mp3'

}

local music

net.Receive( 'RespawnTimer', function()

	local bool = net.ReadBool()

	if bool then

		local dead_time = CurTime()

		local alpha = 255

		hook.Add( 'HUDPaint', 'RespawnTimer', function()

			local time = math.Clamp( math.Round( respawnTime( LocalPlayer() ) - CurTime() + dead_time ), 0, respawnTime( LocalPlayer() ) )

			if alpha > 0 then

				if time < 1 or LocalPlayer():Alive() then

				 	alpha = Lerp( FrameTime(), alpha, 0 )

				end

				draw.SimpleText( 'До возрождения осталось: ' .. time .. inclineTime( time, { ' секунда', ' секунды', ' секунд' } ), 'RespawnTimer', ScrW() / 2, ScrH() / 2 - 30, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				draw.SimpleText( 'Если вы хотите вызвать администратора, напишите: /// [жалоба]', 'RespawnTimer', ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				draw.SimpleText( 'Вас никто не слышит!', 'RespawnTimer', ScrW() / 2, ScrH() / 2 + 30, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )


			else

				hook.Remove( 'HUDPaint', 'RespawnTimer' )

			end


		end )

		hook.Add( 'Think', 'RespawnTimer', function()

			if CurTime() - dead_time < 1 then return end

			hook.Remove( 'Think', 'RespawnTimer' )

			if LocalPlayer():Alive() then return end

			if music then

				music:Stop()

				music = nil

			end

			timer.Simple( 1, function()

				sound.PlayFile( 'sound/' .. table.Random( sounds ), '', function( channel, err, msg )

					if err then return print( msg ) end

					music = channel

					print( music:GetVolume() )

				end )

			end )

			hook.Add( 'Think', 'RespawnSound', function()

				if LocalPlayer():Alive() then 

					if music then

						music:SetVolume( Lerp( 0.1, music:GetVolume(), 0 ) )

						if music:GetVolume() < 0.05 then

							music:Stop()

							music = nil 

							hook.Remove( 'Think', 'RespawnSound' )

						end

					end

					return
				end

			end )

		end )

		system.FlashWindow()

	else

		hook.Remove( 'Think', 'RespawnTimer' )

	end

end )