hook.Add( 'PlayerDeath', 'gp_spawnprice', function( ply )

	ply.rip = true

end )


hook.Add( 'PlayerSpawn', 'SpawnPrice', function( ply ) 
	if ply:getDarkRPVar( 'money' ) - 2500 < 0 then return end
	
	if ply.init_spawn != true then return end

	if ply.rip != true then return end

	if gp_upg and ply:GetUPG('death') == true then
		return
	end

	if ply:getDarkRPVar( 'money' ) >= 1000000 then
		ply:addMoney( -3500 )
		ply:SendLua( [[ notification.AddLegacy( 'Вы заплатили 3500₽ за лечение.', 0, 12 ) ]] ) 
	else
		ply:addMoney( -1500 )
		ply:SendLua( [[ notification.AddLegacy( 'Вы заплатили 1500₽ за лечение.', 0, 12 ) ]] ) 
	end

	ply.rip = false

end ) 

hook.Add( 'PlayerInitialSpawn', 'gp_spawnprice', function( ply )

	timer.Simple( 5, function() ply.init_spawn = true end )

end)