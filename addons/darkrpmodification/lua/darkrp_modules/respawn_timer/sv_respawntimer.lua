local function respawnTime( ply )

	local premium = false 

	if ply:IsSecondaryUserGroup "premium" then premium = true end

	return premium and 10 or 45

end

local screams = {
	
	'ambient/creatures/town_child_scream1.wav',

	'ambient/voices/f_scream1.wav',

	'ambient/voices/m_scream1.wav',

	'vo/coast/odessa/male01/nlo_cubdeath01.wav',

	'vo/coast/odessa/male01/nlo_cubdeath02.wav',

	'vo/ravenholm/monk_death07.wav'

}


util.AddNetworkString( 'RespawnTimer' )

hook.Add( 'PlayerDeath', 'RespawnTimer', function( ply )

	timer.Simple( 0.2, function()

		if IsValid( ply:GetNWEntity( 'DeathRagdoll' ) ) then
		
			ply:GetNWEntity( 'DeathRagdoll' ):EmitSound( screams[ math.random( 1, #screams ) ] )

		end

	end )

	ply.deadtime = CurTime()

	ply:SetDSP( 33, true )

	net.Start( 'RespawnTimer' )

		net.WriteBool( true )

	net.Send( ply )

end )

hook.Add( 'PlayerDeathThink', 'RespawnTimer', function( ply )

	if ply.deadtime and CurTime() - ply.deadtime < respawnTime( ply ) then

		return false

	end

	if ply.mayordemote and CurTime() - ply.deadtime > respawnTime( ply ) then

		return false
		
	end
end )

hook.Add( 'PlayerSpawn', 'RespawnTimer', function( ply )

	ply:SetDSP( 0, true )

	net.Start( 'RespawnTimer' )

		net.WriteBool( false )

	net.Send( ply )

end )



hook.Add( 'PlayerCanHearPlayersVoice', 'RespawnTimer', function( listener, talker ) 

	if not talker:Alive() then return false end

end )

hook.Add( 'PlayerSay', 'RespawnTimer', function( ply )

	if not ply:Alive() then return '' end

end )