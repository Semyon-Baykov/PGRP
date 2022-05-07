hook.Add( 'PlayerFootstep', 'nrg_footsteps', function( ply )
	if ply:IsNRG() then	
		ply:EmitSound( 'nrg/nrgfoot'..math.random( 1, 4 )..'.wav', 70, 100, 0.5)
	end
end )