hook.Add( "EntityTakeDamage", "RSP.stopDamage", function( targ, dmg )
	if ( RSP:InsideSafeZone( targ:GetPos() ) ) then
		dmg:SetDamage( 0 )
	end
end )