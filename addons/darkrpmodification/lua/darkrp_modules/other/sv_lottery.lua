hook.Add( 'lotteryEnded', 'gprpLottory', function( _, ply, amount )

	ply:EmitSound( "ui/achievement_earned.wav" )

end )