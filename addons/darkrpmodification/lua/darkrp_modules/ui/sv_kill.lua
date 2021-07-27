hook.Add( 'PlayerDeath', 'BlueScreen', function( who, inf, killer )

	if killer:IsPlayer() then
		killer:SendLua( [[
			kill_blya = 1
			blue = 100
			timer.Simple( 4, function() kill_blya = 0 end )
		]] )
	end

end )