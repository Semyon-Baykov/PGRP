module( 'gp_radio', package.seeall )

local meta = FindMetaTable( 'Player' )

local hasradiojobs = {
	[2] = {
		chan = 'Полицейская частота'
	},
	[5] = {
		chan = 'Полицейская частота'
	},
	[6] = {
		chan = 'Полицейская частота'
	},
	[4] = {
		chan = 'Полицейская частота'
	},
	[21] = {
		chan = 'Полицейская частота'
	},
	[24] = {
		chan = 'Полицейская частота'
	},
	[26] = {
		chan = 'Частота Росгвардии'
	},
}

function meta:JoinChannel( s )

	if self:GetNWBool( 'gp_radio', false ) ~= true then return end

	self:SetNWString( 'gp_radio_chan', s )
	local text = s == 'police' and 'Полицейская частота' or s == 'nrg' and 'Частота Росгвардии' or s
	DarkRP.notify(self, 2, 6, 'Вы сменили частоту рации на "'..text..'"!')

end

function meta:StartRadioTranslation()

	if self:GetNWBool( 'gp_radio', false ) ~= true then return end

	if self:GetNWString( 'gp_radio_chan', nil ) == nil then return end

	self:SetNWBool( 'gp_radio_translation', true )
	self:SendLua("RunConsoleCommand( '+voicerecord' )")
	self:EmitSound( 'snd_jack_job_radioswitch.wav', 60, 110 )

end

function meta:StopRadioTranslation()

	self:SetNWBool( 'gp_radio_translation', false )
	self:SendLua("RunConsoleCommand( '-voicerecord' )")

end


hook.Add( 'PlayerCanHearPlayersVoice', 'gp_radio', function( listener, talker )

	if listener:GetNWBool( 'gp_radio', false ) == true and talker:GetNWBool( 'gp_radio', false ) and listener:GetNWString( 'gp_radio_chan', nil ) == talker:GetNWString( 'gp_radio_chan', nil ) and talker:GetNWBool( 'gp_radio_translation', false ) == true and listener:GetNWBool( 'gp_radio_off', false ) ~= true then
		return true
	end 

end)

hook.Add( 'PlayerButtonDown', 'gp_radio', function( ply, key )

	if key == 12 and ply:GetNWBool( 'gp_radio', false ) ~= false then
		ply:StartRadioTranslation()
	end

end )


hook.Add( 'PlayerButtonUp', 'gp_radio', function( ply, key )

	if key == 12 and ply:GetNWBool( 'gp_radio', false ) ~= false then
		ply:StopRadioTranslation()
	end

end )

concommand.Add('gp_toggle_radio', function( ply )

	if ply:GetNWBool( 'gp_radio', false ) ~= true then return end

	ply:SetNWBool( 'gp_radio_off', !ply:GetNWBool( 'gp_radio_off', false ) )

	local text = ply:GetNWBool( 'gp_radio_off', false ) == true and 'выключили' or 'включили'
	DarkRP.notify(ply, 2, 6, 'Вы '..text..' рацию!')

end)
concommand.Add('gp_radio_setchannel', function( ply, cmd, args )
	if tbl[args[1]] and not tbl[args[1]].jobs[ply:Team()] then return end

	if tbl[args[1]] and tbl[args[1]].jobs[ply:Team()] then
		ply:JoinChannel( tbl[args[1]].id )
		return
	end
	ply:JoinChannel( args[1] )

end)

hook.Add( 'OnPlayerChangedTeam', 'gp_radio#OnPlayerChangedTeam', function( ply, before, after )

	if hasradiojobs[before] and ply:GetNWBool( 'gp_radio', false ) == true then
		ply:SetNWBool( 'gp_radio', false )
		ply:SetNWString( 'gp_radio_chan', '0' )
	end

	if hasradiojobs[after] then
		ply:SetNWBool( 'gp_radio', true )
		ply:SetNWString( 'gp_radio_chan', tbl[hasradiojobs[after].chan].id )
		DarkRP.notify(ply, 2, 6, 'Нажмите "B" для использования рации')
	end

end )

hook.Add( 'PlayerDeath', 'gp_radio#PlayerDeath', function( ply )

	if not hasradiojobs[ply:Team()] and ply:GetNWBool( 'gp_radio', false ) == true then
		ply:SetNWBool( 'gp_radio', false )
		ply:SetNWString( 'gp_radio_chan', '0' )
	end

end )