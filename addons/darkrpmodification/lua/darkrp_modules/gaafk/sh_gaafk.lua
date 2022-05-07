local meta = FindMetaTable( 'Player' )

function meta:isAFK()

	if not IsValid( self ) then

		return false

	end
	
	return self:GetNWBool( 'gaafk_isAfk', false )

end

function meta:getAFKTime()

	if not IsValid( self ) then

		return 0

	end
		
	return math.Round( ( CurTime() - self:GetNWInt( 'gaafk_afkTime', 0 ) ) / 60, 1 )

end